import QtQuick 2.2
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

SilicaListView{
    property int workingMode: 1
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
            onClicked: {
                console.log("Tapped on line code "+code)
                if (workingMode == 1){
                    // Regular working mode. Full page moves to the new page
                    pageStack.push("../pages/StopsPage.qml", {theLine: code, theColor: lineColor})
                }
                else if (workingMode == 2){
                    if (code != -1){
                        tappedData = [lineNumber, lineName, lineColor, lineType, code]
                        // Does nothing. Just make use of theLine and theColor parameters.
                    }
                    else{
                        console.log("Looking for near stops")
                    }
                }
            }
        }
    }
