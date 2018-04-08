import QtQuick 2.2
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

SilicaListView{
    property var tappedData: []
        spacing: 0
        header: PageHeader{
            title: qsTr("Lines")
        }
        model: ListModel {
        id:linesListModel}
        section{
            property: "lineType"
            criteria: ViewSection.FullString
            delegate: Column{
                width: parent.width
                Label{
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: section
                    color: Theme.secondaryColor
                }
                Item{
                    width: parent.width
                    height: Theme.itemSizeExtraSmall/10
                }
                Separator {
                    color: Theme.secondaryColor
                    height: Theme.itemSizeExtraSmall/50
                    width: parent.width*0.6
                }
                Item{
                    width: parent.width
                    height: Theme.itemSizeExtraSmall/10
                }
            }
        }
        delegate: ListItem {
            width: ListView.view.width
            height: Theme.itemSizeSmall
            Rectangle{
                id: lineIcon
                anchors.left: parent.left
                anchors.leftMargin: Theme.itemSizeExtraSmall/4
                anchors.verticalCenter: parent.verticalCenter
                color: 'transparent'
                height: parent.height*0.95
                width: height
                radius: width*0.5
                border{
                    width: Theme.itemSizeExtraSmall/12
                    color: lineColor
                }

                Label {
                    anchors.centerIn: parent
                    color: Theme.primaryColor
                    text: lineNumber
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                }
            }

            Label{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: lineIcon.right
                anchors.leftMargin: Theme.itemSizeExtraSmall/5
                text: lineName
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
                truncationMode: TruncationMode.Fade
                width: parent.width*0.75
            }
            onClicked: pageStack.push("StopsPage.qml", {theLine: code, theColor: lineColor})
        }
    }

