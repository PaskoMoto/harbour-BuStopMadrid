import pyotherside
from pyemtmad import Wrapper
import uuid
from datetime import datetime


def getTiemposLlegada(parada = 154):
    if type(parada) != type(1):
        parada = int(parada)
    con = Wrapper('WEB.SERV.fernando@cardelina.linkpc.net','6B4AE029-2E12-4C56-BE41-BA608A18A953')
    result = con.geo.get_arrive_stop(stop_number=parada, lang='ES')[1]
    result.sort(key=lambda time: time.line_id)
#    self.db.execute("SELECT line_codes FROM nodes WHERE code = ?", (parada,) )
#    correspondencias = self.db.fetchall()
#    fastest = 60
    output = []
    for time in result:
        line = [time.line_id]
        if time.time_left != 999999:
             line.append(str(round(time.time_left/60,)))
        else:
             line.append(" >20 ")
        line.append(str(abs(time.distance)))
        line.append(str(time.destination))
        line.append(str(time.bus_id))
        output.append(line)
    
    pyotherside.send('TiemposLlegada',output)
    print(output)
    return 1

# def getCardBalance(cardCode):
#    con = Client("http://www.infobustussam.com:9005/InfoTusWS/services/InfoTus?wsdl", username="infotus-usermobile", password="2infotus0user1mobile2", headers={"deviceid":str(uuid.uuid4())})
#    r = con.service.getCardState(cardCode,datetime.today().__format__("%d/%m/%Y"))
#    if r.chipNumber != -1:
#        output = [str(r.chipNumber), r.passName, r.expiryDate, r.moneyCredit, r.tripsCredit]
#    else:
#        output = [None]
#    pyotherside.send('CardBalance',output)
#    print(output)
#    return 1
