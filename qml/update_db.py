from database import internal_db

if __name__ == '__main__':
    x = internal_db()
    x.update_emtmad_lines()
    x.update_emtmad_nodes()
    x.close_db()
