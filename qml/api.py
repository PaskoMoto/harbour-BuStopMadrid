import pyotherside
from pyemtmad import Wrapper
import uuid
from datetime import datetime


def getTiemposLlegada(parada = 154):
    if type(parada) != type(1):
        parada = int(parada)
    con = Wrapper('WEB.SERV.vendofalco@gmail.com','25C3A749-08E3-45E0-B821-9E8EE8D08A09')
    result = con.geo.get_arrive_stop(stop_number=parada, lang='ES')
    if result[0] == True:
        times = result[1]
        times.sort(key=lambda time: time.line_id)
        output = []

# First Item

        line = [times[0].line_id]
        if times[0].time_left != 999999:
             line.append(str(round(times[0].time_left/60,)))
        else:
             line.append(" >20 ")
        line.append(str(abs(times[0].distance)))
#        output.append(line)

# Remaining Items

        for item in range(1 , len(times) ):
            if times[item].line_id == times[item-1].line_id:
                if times[item].time_left != 999999:
                     line.append(str(round(times[item].time_left/60,)))
                else:
                     line.append(" >20 ")
                line.append(str(abs(times[item].distance)))
                output.append(line)
                line = []
            else:
                 line.append(times[item].line_id)
                 if times[item].time_left != 999999:
                      line.append(str(round(times[item].time_left/60,)))
                 else:
                      line.append(" >20 ")
                 line.append(str(abs(times[item].distance)))

#        for time in times:
#            line = [time.line_id]
#            if time.time_left != 999999:
#                 line.append(str(round(time.time_left/60,)))
#            else:
#                 line.append(" >20 ")
#            line.append(str(abs(time.distance)))
#            line.append(str(time.destination))
#            line.append(str(time.bus_id))

    else:
        output = [["XX"," ?? ","??","NO SERVICE","??"]]
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
