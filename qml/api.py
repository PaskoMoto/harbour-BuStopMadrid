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
    else:
        output = [["--"," ?? ","??","NO SERVICE","??"]]

    pyotherside.send('TiemposLlegada',output)
    print(output)
    return 1


def getLineDetails(linea = 1):

    if type(linea) != type(1):
        linea = int(linea)

    dd = datetime.today().day
    mm = datetime.today().month
    yy = datetime.today().year

    con = Wrapper('WEB.SERV.vendofalco@gmail.com','25C3A749-08E3-45E0-B821-9E8EE8D08A09')
    timeslines = con.bus.get_times_lines(day=dd,month=mm,year=yy,lines=linea)#[1]
    if timeslines[0] == True:
            output=[]
            timeslines = timeslines[1]
            for detail in timeslines:
                    line = [detail.day_type]
                    line.append(detail.start_date)
                    line.append(detail.end_date)
                    line.append(detail.first_forward[10:15])
                    line.append(detail.last_forward[10:16])
                    line.append(detail.first_backward[10:15])
                    line.append(detail.last_backward[10:16])
                    output.append(line)
    else:
        output=[[]]
    print(output)
    pyotherside.send('LineDetails',output)
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
