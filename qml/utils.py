import pyotherside
import os
from hashlib import md5
from shutil import copyfile
from database import internal_db


def checkDB():
    source = '/usr/share/harbour-bustopmadrid/db'
    db_location = __get_db_location__()
    ini_location = __get_ini_location__()
    if os.path.isfile(ini_location) and os.path.isfile(db_location):
        return 1
    else:
        if not os.path.exists(path):
            os.makedirs(path)
        copyfile(os.path.join(source,db_hash+".ini"),ini_location)
        copyfile(os.path.join(source,db_hash+".sqlite"),db_location)
        return 1

def hash(my_string):
    m = md5()
    m.update(bytes(my_string,'utf-8'))
    return str(m.hexdigest())

def __get_db_location__():
    path = os.path.join(os.getenv("HOME"),".local/share/harbour-bustopmadrid/harbour-bustopmadrid/QML/OfflineStorage/Databases/")
    db_name = 'bustopmadridDB'
    db_hash = hash(db_name)
    return os.path.join(path,db_hash+".sqlite")

def __get_ini_location__():
    path = os.path.join(os.getenv("HOME"),".local/share/harbour-bustopmadrid/harbour-bustopmadrid/QML/OfflineStorage/Databases/")
    db_name = 'bustopmadridDB'
    db_hash = hash(db_name)
    return os.path.join(path,db_hash+".ini")

def update_database():
    pyotherside.send('UpdatingDB', True)
    my_db = internal_db(__get_db_location__())
    my_db.update_data_tables()
    my_db.__close_db__()
    pyotherside.send('UpdatingDB', False)
    
def wipe_update_database():
    pyotherside.send('WipeUpdatingDB', True)
    my_db = internal_db(__get_db_location__())
    my_db.update_data_tables(wipe=True)
    my_db.__close_db__()
    pyotherside.send('WipeUpdatingDB', False)
