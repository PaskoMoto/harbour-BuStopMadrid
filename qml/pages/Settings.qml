import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

Page {
    id: page
    property var last_db_update: qsTr("Unknown")
    backNavigation: !var_updatingdb && !var_wipeupdatingdb
    SilicaFlickable{
        anchors.fill: parent
        VerticalScrollDecorator { }
        contentHeight: column.height
        RemorsePopup { id: remorse }
        Column {
            id: column
            anchors{
                horizontalCenter: parent.horizontalCenter
            }
            width: page.width*0.95
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Settings")
            }
            Rectangle{
                id: testrectangle
                width: parent.width
                height: 100
                visible: false
                color: "red"
            }

            SectionHeader { text: qsTr("Database") }
            Label{
                width: parent.width
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text: qsTr("Lines and stops are stored in an internal database for faster use of the app. This way data is saved, less interaction with the server is required and some information is available without a proper internet conection. The main drawback of this approach is at some point the database goes outdated.")
            }
            Label{
                width: parent.width
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
                text: qsTr("Last update: ")+last_db_update
            }
            SectionHeader {
                id: sectionUpdate
                text: qsTr("Update database")
            }
            Label{
                width: parent.width
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text: qsTr("Use this option to update database and add missing data (i.e. missing lines). This may take a while.")
            }
            Button{
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Update")
                BusyIndicator {
                    anchors.centerIn: parent
                    id: biUpdate
                    size: BusyIndicatorSize.Medium
                    running: var_updatingdb
                    visible: var_updatingdb
                    onVisibleChanged: if (!visible){
                                          get_last_update();
                                      }
                }
                enabled: !var_updatingdb && !var_wipeupdatingdb
                onClicked: {
                    console.log("Clic on update")
                    remorse.execute(qsTr("Updating"), function() {pythonMain.update_database()})
                }
            }
            SectionHeader {
                id: sectionWipeUpdate
                text: qsTr("Wipe and update database")
            }
            Label{
                width: parent.width
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeExtraSmall
                text: qsTr("Use this option to wipe and populate database from scratch. Notice you will only get the current available lines by the time of the day and the database should be manually updated -not wiped- when the other lines are available. This may usually take up to 15 minutes.")
            }
            Button{
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Wipe & update")
                BusyIndicator {
                    anchors.centerIn: parent
                    id: biWipeUpdate
                    size: BusyIndicatorSize.Medium
                    running: var_wipeupdatingdb
                    visible: var_wipeupdatingdb
                    onVisibleChanged: if (!visible){
                                          get_last_update();
                                      }
                }
                enabled: !var_updatingdb && !var_wipeupdatingdb
                onClicked: {
                    console.log("Clic on wipe and update")
                    remorse.execute(qsTr("Wiping and updating"), function() {pythonMain.wipe_update_database()})
                }
            }
            Item{
                width: parent.width
                height: Theme.itemSizeMedium
            }
        }
    }
    function get_last_update(){
        console.log("Getting last DB update date.")
        var db = LocalStorage.openDatabaseSync("bustopmadridDB","1.0","Internal data for hitmemap! app.",1000000)
        db.transaction(
                    function(tx){
                        var r1 = tx.executeSql("SELECT data FROM metadata WHERE field='last_db_update' ")
                        last_db_update = r1.rows.item(0).data
                    }
                    )
    }
    Component.onCompleted: {
        rootPage.current_page = ['Settings']
        get_last_update();
    }
}

