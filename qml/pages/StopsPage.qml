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

import QtQuick 2.2
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "utils.js" as MyUtils

Page{
    id:pageStops
    property var theLine
    property bool testing_rectangles: false
    Item{
        id: headerItem
        width: parent.width
        height: Theme.itemSizeMedium
        Label{
            id: lineName
            anchors{
                left: parent.left
                leftMargin: Theme.itemSizeExtraSmall/2
                right: lineIcon.left
                rightMargin: Theme.itemSizeExtraSmall/6
                verticalCenter: parent.verticalCenter
            }
            width: parent.width - lineIcon.width - lineIcon.anchors.rightMargin - anchors.rightMargin - anchors.leftMargin
            truncationMode: TruncationMode.Fade
        }
        Rectangle{
            id: lineIcon
            anchors.right: parent.right
            anchors.rightMargin: Theme.itemSizeExtraSmall/6
            anchors.verticalCenter: parent.verticalCenter
            color: 'transparent'
            height: Theme.itemSizeSmall
            width: height
            radius: width*0.5
            border{
                width: parent.width/100
            }
            Label {
                id: lineLabel
                anchors.centerIn: parent
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                font.bold: true
            }
        }
            }
    StopsList{
        anchors.top: headerItem.bottom
        model: ListModel{
            id: mymodel
        }
    }

    Component.onCompleted: {
        rootPage.current_page = ['StopsPage']
        var output = MyUtils.getStopsData(theLine, mymodel)
        lineName.text = output[0]
        lineLabel.text = output[1]
        lineIcon.border.color = output[2]
    }
}
