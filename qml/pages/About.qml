import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    SilicaFlickable{
        anchors.fill: parent
        VerticalScrollDecorator { }
        contentHeight: column.height
        Column {
            id: column
            anchors.horizontalCenter: parent.horizontalCenter
            width: page.width*0.95
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("About")
            }
            Image {
                id: logoImg
                source:"qrc:///res/icon.png"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label{
                text: qsTr("Description")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label{
                width: parent.width
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text:qsTr("BuStopMadrid is an unofficial app to get arrival times from EMT bus service in Madrid. Arrival times are just an estimation and depends on EMT servers. \nThis app depends on pyemtmad libs for easy use of SOAP web services.")
            }
            Label{
                text: qsTr("Author")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label{
                width: parent.width
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text:"Pasko based on an app from J. Pablo Navarro"
            }
            Label{
                text: qsTr("Icon")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label{
                width: parent.width
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text:"Carmen Fernández"
            }
            Label{
                text: qsTr("License")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label{
                width: parent.width
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text:"GPL v3.0"
            }
            Label{
                text: qsTr("Source code")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Button{
                text: qsTr("See it in Github")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    Qt.openUrlExternally("https://github.com/PaskoMoto/harbour-BuStopMadrid")
                }
            }
            Label{
                text: qsTr("Support this work")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label{
                width: parent.width
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text:qsTr("You can support this app if you want. Ideally I'd feel my work supported just with you coding other native apps for SailfishOS so I can enjoy them myself. If you can't code or just don't want to do it, you can make a donation.")
            }
            Button{
                text:qsTr("Develop an app")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    Qt.openUrlExternally("https://sailfishos.org/wiki/SailfishOS")
                }
            }
            Button{
                text:qsTr("Make a donation")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    Qt.openUrlExternally("https://www.paypal.me/PaskoMoto")
                }
            }
            Item{
                height: Theme.itemSizeExtraSmall/8
                width: parent.width
            }
        }
    }
    Component.onCompleted: {
        rootPage.current_page = ['About']
    }
}

