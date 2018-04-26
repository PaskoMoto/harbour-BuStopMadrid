/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3
import "pages"
import "cover"

ApplicationWindow
{
    id: rootPage
    property bool modules_unloaded: true
    property var var_tiempos_llegada
    property var var_line_details
    property var var_card_balance: []
    property bool var_updatingdb: false
    property bool var_wipeupdatingdb: false
    property var current_page
    initialPage: Component { FrontPage { } }
    cover: if (current_page[0] === 'StopPage'){
    return Qt.resolvedUrl("cover/CoverStopPage.qml")
}
    else{
        return Qt.resolvedUrl("cover/CoverPage.qml")
    }

    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
    Python{
        id:pythonMain
        Component.onCompleted: {
            if(modules_unloaded){
                addImportPath(Qt.resolvedUrl('.'));
                importModule('api', function () {});
                importModule('utils', function () {});
                modules_unloaded = false;
                console.log("===> Modules loaded!")
            }
            checkDB();
            setHandler('TiemposLlegada',function(TiemposLlegada){
                            var_tiempos_llegada = TiemposLlegada;
                            console.log("===> Got some info!!")
                        });
            setHandler('LineDetails',function(LineDetails){
                            var_line_details = LineDetails;
                            console.log("===> Got some info!!")
                        });
            setHandler('UpdatingDB',function(UpdatingDB){
                            var_updatingdb = UpdatingDB;
                            console.log("===> Got some info!!")
                        });
            setHandler('WipeUpdatingDB',function(WipeUpdatingDB){
                            var_wipeupdatingdb = WipeUpdatingDB;
                            console.log("===> Got some info!!")
                        });
/*            setHandler('CardBalance',function(CardBalance){
                            var_card_balance = CardBalance;
                            console.log("===> Got some info!!")
                        });*/
        }
        function ask(stopCode){
            call('api.getTiemposLlegada', [stopCode] , function(parada) {});
            var_tiempos_llegada = []
            console.log("Details requested.")
        }
        function askLineDetails(code){
            call('api.getLineDetails', [code] , function(linea) {});
            var_line_details = []
            console.log("Line details requested for line:"+code)
        }
        function checkDB(){
            call('utils.checkDB',[],console.log("DB OK."))
        }
        function update_database(){
            call('utils.update_database',[],console.log("Updating the DB."))
        }
        function wipe_update_database(){
            call('utils.wipe_update_database',[],console.log("Wiping and updating the DB."))
        }
/*        function askCardBalance(cardCode){
              call('api.getCardBalance', [cardCode] , function(cardCode) {});
              console.log("Card Balance requested")
*/
        onReceived:
        {
            // All the stuff you send, not assigned to a 'setHandler', will be shown here:
            console.log('Got message from python: ' + data);
        }
    }
}

