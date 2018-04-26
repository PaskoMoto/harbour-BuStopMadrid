#! vevn/bin/python
from pyemtmad import Wrapper
import uuid
import os
import sqlite3
from datetime import datetime

dd = datetime.today().day
mm = datetime.today().month
yy = datetime.today().year

class internal_db:
    def __init__(self, db_path='../db/7e3f3d4078aa797ff831e9bc3fbbfe46.sqlite'):
        self.db_path = db_path
        self.db = self.__init_db__()
        self.__create_tables_db__()
        self.__emtmad_connect__()
        self.data_tables = ['lines', 'nodes', 'line_nodes']
    
    def __init_db__(self):
        self.db_conn = sqlite3.connect(self.db_path)
        c = self.db_conn.cursor()
        return c
    
    def __close_db__(self):
        self.db_conn.close()
        return 1
        
    def __create_tables_db__(self):
        if not self.db.execute('''CREATE TABLE IF NOT EXISTS lines
             (code INTEGER, name TEXT, label TEXT, color TEXT, category TEXT,
             head_name TEXT, head_number INTEGER, head_start_time TEXT, head_end_time TEXT,
             tail_name TEXT, tail_number INTEGER, tail_start_time TEXT, tail_end_time TEXT, PRIMARY KEY (code, label))'''):
            return 0

        if not self.db.execute('''CREATE TABLE IF NOT EXISTS nodes
            (code INTEGER UNIQUE PRIMARY KEY, name TEXT, latitude REAL, longitude REAL, altitude REAL, line_codes TEXT)'''):
            return 0
        
        if not self.db.execute('''CREATE TABLE IF NOT EXISTS line_nodes
            (id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, line_code INTEGER NOT NULL, line_label TEXT, section INTEGER, nodes TEXT, distance INTEGER)'''):
            return 0
        
        if not self.db.execute('''CREATE TABLE IF NOT EXISTS usual_nodes
            (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, code INTEGER UNIQUE, custom_label TEXT, custom_color TEXT)'''):
            return 0
        
        if not self.db.execute('''CREATE TABLE IF NOT EXISTS metadata
            (field TEXT, data TEXT)'''):
            return 0
        
        return 1
    
    def __emtmad_connect__(self):
        self.emtmad = Wrapper('WEB.SERV.vendofalco@gmail.com','25C3A749-08E3-45E0-B821-9E8EE8D08A09')
        return 1
        
    def __update_emtmad_lines__(self):
        # Download lines from API to DB
        lines = self.emtmad.bus.get_list_lines(day=dd,month=mm,year=yy,lines=[])[1]
        color = "#aaaaaa"
        category = 'Red Diurna Convencional'
        for line in lines:
            if line not in ["", None, "None", []]:
                self.db.execute("SELECT * FROM lines WHERE code = ?", (int(line.line),) )
                if self.db.fetchone() == None:
                    if str(line.group) in ['110','120','155','160','171']:
                        category = 'Red Diurna Convencional'
                        color = "#f54129"
                    elif str(line.group) in ['210']:
                        category = 'Red Universitaria'
                        color = "#000d6f"
                    elif str(line.group) in ['320']:
                        category = 'Red Nocturna'
                        color = "#742929"
                    elif str(line.group) in ['410','420']:
                        category = 'Líneas Aeropuerto'
                        color = "#84c6e3"
                    else:
                        category = '---------------'
                    line.header_a = line.header_a.replace("  ","")
                    line.header_b = line.header_b.replace("  ","")
                    data = (line.line,line.header_a+"-- "+line.header_b,line.label,color,category)
                    data = data + (line.header_a, 1, line.start_date, line.end_date)
                    data = data + (line.header_b, 2, line.start_date, line.end_date)
                    self.db.execute('INSERT INTO lines VALUES (?,upper(?),?,?,?,upper(?),?,?,?,upper(?),?,?,?)',data)

        self.db.execute('UPDATE lines SET name=? where label=?',('CIRCULAR 1','C1'))
        self.db.execute('UPDATE lines SET name=? where label=?',('CIRCULAR 2','C2'))

        if self.db_conn.commit():
            return 1
        else:
            return 0

    def __update_emtmad_nodes__(self):
        self.__emtmad_connect__()

        nodes = self.emtmad.bus.get_nodes_lines(nodes=[])[1]
        for node in nodes:
            if node not in ["", None, "None", []]:
                self.db.execute("SELECT * FROM nodes WHERE code = ?", (int(node.id),) )
                if self.db.fetchone() == None:
                   lineinfo = ":"
                   for line in node.lines:
                       if line[1] == 'forward':
                           lineinfo = lineinfo+str(line[0])+".1:"
                       else:
                           lineinfo = lineinfo+str(line[0])+".2:"
                   data = (node.id, node.name, node.latitude, node.longitude, "667", lineinfo)
                   self.db.execute('INSERT INTO nodes VALUES (?,upper(?),?,?,?,?)',data)

        self.db.execute("SELECT label, code, head_number, tail_number FROM lines")
        for line, code, head, tail in self.db.fetchall():
            raw_data = self.emtmad.bus.get_route_lines(day=dd,month=mm,year=yy,lines=code)[1]
            if len(raw_data) > 0:

                section = 1   # head-to-tail
                if section != None:
                    node_list = []
                    distance_list = []
                    way = str(code)+"."+str(section)
                    for remot_node in raw_data:
                         if remot_node.node_type == 'forward_stop':
                              node_list.append(str(remot_node.id))
                              distance_list.append(str(remot_node.distance_orig))
                    temp = (code, line, int(section),)
                    self.db.execute('SELECT nodes, distance FROM line_nodes WHERE line_code=? AND line_label=? AND section=?', temp)
                    local_data = self.db.fetchone()
                    if local_data == None or (node_list != "::" and distance_list != "::" and (local_data[0] == "::" or local_data[1] == "::")):
                                 data = (code, line, int(section), ":"+":".join(node_list)+":",":"+":".join(distance_list)+":",)
                                 self.db.execute('INSERT INTO line_nodes VALUES (NULL,?,?,?,?,?)', data)

                section = 2   # tail-to-head
                if section != None:
                    node_list = []
                    distance_list = []
                    way = str(code)+"."+str(section)
                    for remote_node in raw_data:
                         if remote_node.node_type == 'backward_stop':
                              node_list.append(str(remote_node.id))
                              distance_list.append(str(remote_node.distance_orig))
                    temp = (code, line, int(section),)
                    self.db.execute('SELECT nodes, distance FROM line_nodes WHERE line_code=? AND line_label=? AND section=?', temp)
                    local_data = self.db.fetchone()
                    if local_data == None or (node_list != "::" and distance_list != "::" and (local_data[0] == "::" or local_data[1] == "::")):
                                 data = (code, line, int(section), ":"+":".join(node_list)+":",":"+":".join(distance_list)+":",)
                                 self.db.execute('INSERT INTO line_nodes VALUES (NULL,?,?,?,?,?)', data)

        self.db_conn.commit()
                        
    def __get_table_names__(self):
        x = self.db.execute("SELECT name FROM sqlite_master WHERE type='table';")
        table_list = []
        for element in x.fetchall():
            if element[0] != 'sqlite_sequence':
                table_list.append(element[0])
        return table_list
        
    def __wipe_table__(self, table):
        """ Deletes the content of a table.
        """
        self.db.execute('DELETE FROM %s' % table)
        self.db_conn.commit()
        return True if self.db.execute('SELECT Count(*) FROM %s' % table).fetchone()[0] == 0 else False
    
    def __wipe_data_tables__(self):
        result = []
        for table in self.data_tables:
            result.append(self.__wipe_table__(table))
        return True if all(result) else False

    def update_data_tables(self, wipe = False):
        if wipe:
            self.__wipe_data_tables__()
        self.__update_emtmad_lines__()
        self.__update_emtmad_nodes__()
        self.__update_modification_date__()
        
    def __update_modification_date__(self):
        if self.db.execute("SELECT Count(*) from metadata WHERE field='last_db_update'").fetchone()[0] == 0:
            self.db.execute("INSERT INTO metadata VALUES (?, ?)", ('last_db_update', str(datetime.now().strftime("%d/%m/%Y - %H:%M")),))
        else:
            self.db.execute("UPDATE metadata SET data=? WHERE field=?", (str(datetime.now().strftime("%d/%m/%Y - %H:%M")), 'last_db_update',))
        self.db_conn.commit()
        
if __name__ == '__main__':
    x = internal_db()
    x.update_data_tables(wipe=True)
