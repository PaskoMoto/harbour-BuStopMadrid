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
    id:detailsPage
    property string line
    property bool testing_rectangles: false
    SilicaFlickable{
        anchors.fill: parent
        ViewPlaceholder {
            id: loadingIndicator
//            enabled: if (var_line_details[0] == undefined){
            enabled: if (lineDetails.count === 0){
                         MyUtils.getLineDetailsData(rootPage.var_line_details, line);
                         return true
                     }
                     else{
                         console.log(var_line_details[0])
                         console.log(var_line_details[1])
                         console.log(var_line_details[2])
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
            id: subTitle
            visible: ! loadingIndicator.enabled
            anchors{
                top: parent.top
                topMargin: Theme.itemSizeExtraSmall/2
                left: parent.left
                right: icon.left
                leftMargin: Theme.itemSizeExtraSmall/3
//                verticalCenter: parent.verticalCenter
            }
            width: detailsPage.width*0.8
            truncationMode: TruncationMode.Fade
            font.pixelSize: Theme.fontSizeMedium
            font.bold: true
            color: Theme.secondaryColor
        }
        Rectangle{
        id: icon
        visible: ! loadingIndicator.enabled
        anchors.right: parent.right
        anchors.rightMargin: Theme.itemSizeExtraSmall/6
        anchors.verticalCenter: subTitle.verticalCenter
        color: 'transparent'
        height: Theme.itemSizeSmall
        width: height
        radius: width*0.5
        border{
            width: parent.width/100
        }
        Label{
            id: title
            visible: ! loadingIndicator.enabled
            anchors{
                verticalCenter: icon.verticalCenter
                horizontalCenter: icon.horizontalCenter
            }
            font.pixelSize: Theme.fontSizeSmall
            font.bold: true
          }
        }
       SilicaListView {
           id: lineDetails
           visible: ! loadingIndicator.enabled
           width: parent.width
           height: detailsPage.height - subTitle.height
           clip: true
           anchors{
               top: parent.top
               topMargin: Theme.itemSizeMedium
               left: parent.left
               right: parent.right
               rightMargin: Theme.itemSizeExtraSmall/3
               leftMargin: Theme.itemSizeExtraSmall/3
           }
           spacing: Theme.itemSizeSmall
           model: ListModel {id: lineDetailsModel}
           delegate: BackgroundItem {
                               Label {
                                   id: typeDay
                                   text: dayType
                                   font.pixelSize: Theme.fontSizeSmall
                                   font.bold: true
                                   anchors.top: parent.top
                                   anchors.topMargin: Theme.itemSizeExtraSmall/5
                               }
                               Item{
                                   id: details
                                   height: Theme.itemSizeSmall/1.5
                                   anchors{
                                       left: typeDay.left
                                       top: typeDay.bottom
                                       bottomMargin: Theme.itemSizeExtraSmall/50
                                   }
                                           Label {
                                               id: forward
                                               text: qsTr("First forward: ")+first_forward+qsTr(". Last forward: ")+last_forward
                                               font.pixelSize: Theme.fontSizeSmall
                                               font.bold: true
                                               anchors.left: parent.left
                                           }
                                           Label {
                                               id: backward
                                               text: qsTr("First backward: ")+first_backward+qsTr(". Last backward: ")+last_backward
                                               font.pixelSize: Theme.fontSizeSmall
                                               font.bold: true
                                               anchors.top: forward.bottom
                                               anchors.left: parent.left
                                           }
                                           Label {
                                               id: startend
                                               text: qsTr("Schedules valid from:\n")+startDate+qsTr(" until ")+endDate
                                               font.pixelSize: Theme.fontSizeSmall
                                               anchors.topMargin: Theme.itemSizeExtraSmall/50
                                               anchors.bottomMargin: Theme.itemSizeExtraSmall/50
                                               anchors.top: backward.bottom
                                               anchors.left: forward.left
                                           }
                             }
                           }
       }
  }
    Component.onCompleted: {
        rootPage.current_page = ['DetailsPage']
    }

}
