import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    Label{
        anchors.centerIn: parent
        text: qsTr("To be implemented!")
    }
    Component.onCompleted: {
        rootPage.current_page = ['TBDPage']
    }
}

