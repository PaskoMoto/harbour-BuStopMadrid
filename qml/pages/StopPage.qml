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
import QtGraphicalEffects 1.0
import QtQuick.LocalStorage 2.0
import "utils.js" as MyUtils

Page {
    id:stopPage
    property bool testing_rectangles: false
    property string current_stop
    SilicaFlickable{
        anchors.fill: parent
        PullDownMenu{
            MenuItem{
                text: qsTr("Add to usual stops")
                onClicked: MyUtils.addUsual(current_stop,subHeader.text)
                visible: !favIcon.visible
            }
            MenuItem{
                text: qsTr("Remove from usual stops")
                onClicked: MyUtils.removeUsualStop(current_stop)
                visible: favIcon.visible
            }
            MenuItem{
                text: qsTr("Refresh")
                onClicked: {stopDataModel.clear();
                    pythonMain.ask(current_stop);}
            }
        }
        ViewPlaceholder {
            id: loadingIndicator
            enabled: if (linesList.count === 0){
                         MyUtils.populateStopData(rootPage.var_tiempos_llegada, current_stop);
                         return true
                     }
                     else{
                         return false
                     }
            text: qsTr("Loading...")
            BusyIndicator {
                anchors{
                    horizontalCenter: parent.horizontalCenter
                    top: parent.bottom
                    topMargin: Theme.itemSizeExtraSmall/2
                }
                size: BusyIndicatorSize.Large
                running: parent.enabled
            }
            Rectangle{
                visible: testing_rectangles
                anchors.fill: parent
                color: "transparent"
                border.color: "white"
            }
        }
        Label{
            id: header
            visible: ! loadingIndicator.enabled
            anchors{
                top:parent.top
                topMargin: Theme.itemSizeExtraSmall/2
                right: parent.right
                rightMargin: Theme.itemSizeExtraSmall/5
            }
            font.pixelSize: Theme.fontSizeExtraLarge
            text: current_stop
        }
        Label{
            id: subHeader
            visible: ! loadingIndicator.enabled
            anchors{
                left: parent.left
                leftMargin: Theme.itemSizeExtraSmall/3
                verticalCenter: header.verticalCenter
            }
            width: stopPage.width*0.8
            truncationMode: TruncationMode.Fade
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.secondaryColor
            text: " "
        }
        Item{
            id: topLayer
            visible: ! loadingIndicator.enabled
            height: Theme.itemSizeExtraSmall/1.5
            width: parent.width
            anchors{
                top: subHeader.bottom
            }
            Image{
                id: favIcon
                visible: false
                source:"image://theme/icon-s-favorite"
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: Theme.itemSizeExtraSmall/10
                }
                ColorOverlay{
                    anchors.fill: favIcon
                    source: favIcon
                    color: Theme.highlightColor
                }
            }
            Image{
                id: pinIcon
//                visible: ! loadingIndicator.enabled
                visible: false
                source:"image://theme/icon-s-certificates"
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: favIcon.right
                    leftMargin: Theme.itemSizeExtraSmall/10
                }
                ColorOverlay{
                    anchors.fill: pinIcon
                    source: pinIcon
                    color: Theme.highlightColor
                }
            }
            Image{
                id: syncIcon
//                visible: ! loadingIndicator.enabled
                visible: false
                source:"image://theme/icon-s-sync"
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: pinIcon.right
                    leftMargin: Theme.itemSizeExtraSmall/10
                }
                ColorOverlay{
                    anchors.fill: syncIcon
                    source: syncIcon
                    color: Theme.highlightColor
                }
                Label{
//                    visible: ! loadingIndicator.enabled
                    visible: false
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: syncIcon.right
                        leftMargin: Theme.itemSizeExtraSmall/10
                    }
                    id: time2Refresh
                    text: "55"+" s"
                    font.pixelSize: Theme.fontSizeSmall
                }
            }
            Image{
                visible: ! loadingIndicator.enabled
                anchors{
                    right: lastRefresh.left
                    rightMargin: Theme.itemSizeExtraSmall/20
                    verticalCenter: lastRefresh.verticalCenter
                }
                id: lastRefreshIcon
                source:"image://theme/icon-s-time"
            }
            Label{
                visible: ! loadingIndicator.enabled
                anchors{
                    right: parent.right
                    rightMargin: Theme.itemSizeExtraSmall/5
                    verticalCenter: parent.verticalCenter
                }
                id:lastRefresh
                font.bold: true
                font.pixelSize: Theme.fontSizeSmall
                //                color: "green" // To be implemented
                text: { var now = new Date()
                    return now.getHours()+":"+now.getMinutes()
                }

            }
            Rectangle{
                visible: testing_rectangles
                anchors.fill: parent
                color: "transparent"
                border.color: "green"
            }
        }
        SilicaListView{
            id: linesList
            clip: true
            width: parent.width
            anchors{
                top:topLayer.bottom
                topMargin: Theme.itemSizeExtraSmall/10
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }
            spacing: Theme.itemSizeExtraSmall/5
            model: ListModel{
                id: stopDataModel
            }
            delegate: Item{
                width: stopPage.width
                height: Theme.itemSizeHuge
                Rectangle{
                    id: lineIcon
                    anchors{
                        left: parent.left
                        leftMargin: Theme.itemSizeExtraSmall/4
                        top: parent.top
                        topMargin: Theme.itemSizeExtraSmall/4
                    }
                    color: 'transparent'
                    height: Theme.itemSizeExtraSmall
                    width: height
                    radius: width*0.5
                    border{
                        width: Theme.itemSizeExtraSmall/12
                        color: line_color
                    }
                    Label {
                        anchors.centerIn: parent
                        color: Theme.primaryColor
                        text: line
                        font.pixelSize: Theme.fontSizeMedium
                        font.bold: true
                    }
                }
                Item{
                    id: directionBus
                    width: parent.width-lineIcon.width-Theme.itemSizeExtraSmall
                    height: Theme.itemSizeSmall/1.5
                    anchors{
                        left: lineIcon.right
                        leftMargin: Theme.itemSizeExtraSmall/5
                        top: parent.top
                        topMargin: Theme.itemSizeExtraSmall/5
                    }
                    Image{
                        visible: true
                        id: directionBusIcon
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                        }
                        source: "image://theme/icon-s-task"
                    }
                    Label{
                        anchors{
                            left: directionBusIcon.right
                            leftMargin: Theme.itemSizeExtraSmall/20
                            verticalCenter: parent.verticalCenter
                        }
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.highlightColor
                        text: section_name
                    }
                    Rectangle{
                        visible: testing_rectangles
                        color: "transparent"
                        border.color: "orange"
                        anchors.fill: parent
                    }
                }
                Item{
                    id: firstBus
                    width: parent.width*2/3
                    height: Theme.itemSizeSmall/1.5
                    anchors{
                        left: lineIcon.right
                        leftMargin: Theme.itemSizeExtraSmall/5
                        top: directionBus.bottom
                    }
                    Image{
                        id: firstBusIcon
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                        }
                        source: "image://theme/icon-s-duration"
                    }
                    Label{
                        anchors{
                            left: firstBusIcon.right
                            leftMargin: Theme.itemSizeExtraSmall/20
                            verticalCenter: parent.verticalCenter
                        }
                        text: first_bus_time+qsTr(" minutes")+", "+first_bus_distance+qsTr(" meters")
                    }
                    Rectangle{
                        visible: testing_rectangles
                        color: "transparent"
                        border.color: "yellow"
                        anchors.fill: parent
                    }
                }
                Item{
                    id: secondBus
                    width: parent.width*2/3
                    height: Theme.itemSizeSmall/1.8
                    anchors{
                        left: firstBus.left
                        leftMargin: Theme.itemSizeExtraSmall/2
                        top: firstBus.bottom
                        topMargin: Theme.itemSizeExtraSmall/10
                    }
                    Image{
                        id: secondBusIcon
                        anchors{
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                        }
                        width: Theme.itemSizeExtraSmall/2.7
                        height: width
                        source: "image://theme/icon-s-duration"
                    }
                    Label{
                        anchors{
                            left: secondBusIcon.right
                            leftMargin: Theme.itemSizeExtraSmall/20
                            verticalCenter: parent.verticalCenter
                        }
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: Theme.secondaryColor
                        text: second_bus_time+qsTr(" minutes")+", "+second_bus_distance+qsTr(" meters")
                    }
                    Rectangle{
                        visible: testing_rectangles
                        color: "transparent"
                        border.color: "yellow"
                        anchors.fill: parent
                    }
                }
                Rectangle{
                    visible: testing_rectangles
                    color: "transparent"
                    border.color: "red"
                    anchors.fill: parent
                }
                Separator{
                    height: Theme.itemSizeExtraSmall/40
                    width: parent.width*2/3
                    color: Theme.secondaryColor
                }
            }
        }
    }
    Component.onCompleted: {
        rootPage.current_page = ['StopPage',current_stop]
    }

}
