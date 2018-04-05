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

Page {
    id: page
    property var var_tiempos_llegada: ""
    property bool modules_unloaded: true
    property var searchStop: "0"
    function pushAskButton(){
        pythonMain.ask();
        var_tiempos_llegada = [];
    }
    function toggleBusStopBlock(){
        if (busStopBlock.visible){
            busStopBlock.visible = false;
        }
        else{
            busStopBlock.visible = true;
        }
    }

        width: parent.width
        SilicaFlickable{
            anchors{
                fill: parent
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                top: parent.top
            }
            PullDownMenu{
                MenuItem{
                    text: qsTr("Settings")
                    onClicked: {
                        pageStack.push("Settings.qml")
                    }
                }
                MenuItem{
                    text: qsTr("About")
                    onClicked: {
                        pageStack.push("About.qml")
                    }
                }
                MenuItem{
                    text: qsTr("Official rates (website)")
                    onClicked: Qt.openUrlExternally("http://www.emtmadrid.es/ViajarenBus/Titulosytarifas")
                }
            }
            PageHeader{
                id: header
                title: qsTr("BuStop Madrid")
            }
            Item{
                id: busStopBlock
                width: parent.width
                height: Theme.itemSizeSmall
                visible: false
                anchors{
                    top: header.bottom
                }
                TextField{
                    id:busStopCode
                    width: parent.width*0.5
                    anchors{
                        top: parent.top
                        topMargin: Theme.itemSizeExtraSmall/5
                        left: parent.left
                        leftMargin: Theme.itemSizeExtraSmall/5
                    }
                    placeholderText: qsTr("Ask for a bus stop code")
                    label:qsTr("Bus stop code")
                    inputMethodHints: Qt.ImhDigitsOnly
                    text: if(searchStop != "0"){
                              return searchStop
                          }
                          else{
                              return ""
                          }
                }
                Button{
                    id: askButton
                    anchors{
                        top: parent.top
                        topMargin: Theme.itemSizeExtraSmall/5
                        right: parent.right
                        rightMargin: Theme.itemSizeExtraSmall/5
                    }
                    text: qsTr("Ask!")
                    enabled: {
                        if (busStopCode.text.length > 0){
                            return true
                        }
                        else{
                            return false
                        }
                    }
                }
            }
            SilicaGridView{
                clip: true
                id: mainGrid
                cellHeight: Theme.itemSizeMedium*2.75
                cellWidth: Theme.itemSizeMedium*2.2
                width: Math.floor(parent.width/cellWidth)*cellWidth
                anchors{
                    horizontalCenter: parent.Center
                    left: parent.left
                    bottom: parent.bottom
//                    top: parent.top
                    top: if (busStopBlock.visible){
                             return busStopBlock.bottom
                         }
                         else{
                             return parent.top
                         }
                    topMargin: Theme.itemSizeExtraSmall
                    leftMargin: (parent.width-width)/2
                }

            model: ListModel{
                ListElement{
                    title: qsTr("Bus stop")
                    icon: "qrc:///res/bus_stop.png"
                    move2: "BSCodePage.qml"
                }
                ListElement{
                    title: qsTr("Stops map")
                    icon: "qrc:///res/map.png"
                    move2: "StopsMap.qml"
                }
                ListElement{
                    title: qsTr("Usual stops")
                    icon: "image://theme/icon-m-favorite"
                    move2: "UsualStopsPage.qml"
                }
                ListElement{
                    title: qsTr("Nearest stops")
                    icon: "image://theme/icon-m-whereami"
                    move2: "TBDPage.qml"
                }
                ListElement{
                    title: qsTr("Lines")
                    icon: "image://theme/icon-l-document"
                    move2: "LinesPage.qml"
                }
/*                ListElement{
                    title: qsTr("Check card balance")
                    icon: "image://theme/icon-l-mobile-network"
                    move2: "CardBalancePage.qml"
                } */
            }
            delegate: BackgroundItem {
                height: mainGrid.cellHeight
                width: mainGrid.cellWidth
                onClicked: {
                    console.log("clicked!"+index)
                        pageStack.push(move2)
                }
                Image {
                    anchors{
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: Theme.itemSizeExtraSmall/2
                    }
                    id: imageIcon
                    width: Theme.itemSizeExtraLarge
                    height: width
                    source: icon
                }
                Label{
                    width: parent.width*0.9
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    anchors{
                        horizontalCenter: parent.horizontalCenter
                        top: imageIcon.bottom
                        topMargin: Theme.itemSizeExtraSmall/5
                    }
                    text: title
                    color: Theme.primaryColor
                }
            }
        }
    }
        Component.onCompleted: {
            rootPage.current_page = ['FrontPage']
        }
}

