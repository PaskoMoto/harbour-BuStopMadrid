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
    property bool testing_rectangles: false
    id:pageUsualStops
    PageHeader{
        id: header
        title: qsTr("Your usual stops")
    }

    SilicaListView{
        id: stopsListView
        clip: true
        anchors{
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: header.bottom
        }
        spacing: 0
        model: ListModel{
            id: stopDataModel
        }
        delegate: ListItem {
            width: ListView.view.width
            contentHeight: Theme.itemSizeMedium
            Label{
                id: codeLabel
                anchors{
                    left: parent.left
                    leftMargin: Theme.itemSizeExtraSmall/4
                    bottom: separator.top
                    bottomMargin: separator.height
                }
                horizontalAlignment: Text.AlignHCenter
                width: Theme.itemSizeExtraSmall
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: code
            }
            Rectangle{
                id: separator
                anchors{
                    horizontalCenter: codeLabel.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                width: Theme.itemSizeExtraSmall/1.1
                height: Theme.itemSizeExtraSmall/12
                color: Theme.highlightColor
            }
            Label{
                anchors{
                    top: parent.top
                    topMargin: Theme.itemSizeExtraSmall/10
                    right: parent.right
                    rightMargin: Theme.itemSizeExtraSmall/8
                }
                width: parent.width - Theme.itemSizeMedium
                truncationMode: TruncationMode.Fade
                horizontalAlignment: Text.AlignLeft
                //text: custom_label // This is the real field here; needs Usual Stop Dialog TBD first
                text: name
            }
            Label{
                visible: false // This will make sense once the Usual Stop Dialog is done
                anchors{
                    bottom: parent.bottom
                    bottomMargin: Theme.itemSizeExtraSmall/4
                    right: parent.right
                    rightMargin: Theme.itemSizeExtraSmall/8
                }
                width: parent.width - Theme.itemSizeExtraLarge
                truncationMode: TruncationMode.Fade
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                text: name
            }
            Rectangle{
                visible: testing_rectangles
                anchors.fill: parent
                color: "transparent"
                border.color: "green"
            }
            onClicked: MyUtils.pushAskButton(code);
            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Remove")
                    onClicked: MyUtils.removeUsual(entry_id)
                }
            }
        }
    }
    Component.onCompleted: {
        rootPage.current_page = ['UsualStopsPage']
        MyUtils.getUsualStopsData();
    }
}
