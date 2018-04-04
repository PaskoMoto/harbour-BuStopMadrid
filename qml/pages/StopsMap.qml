import QtQuick 2.0
import QtLocation 5.0
import QtPositioning 5.2
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0
import QtQuick.LocalStorage 2.0
import "../lists"
import "../lists/utils.js" as MyUtils

Page {
    id: stopsMapPage
    backNavigation: myMap.state == "" ? true : false
    allowedOrientations: Orientation.PortraitMask
    property bool testing_rectagles: false
    PositionSource {
        id: src
        updateInterval: 1000
        active: true
    }
    Item{
        id: topSafeZone
        width: parent.width
        height: Theme.itemSizeExtraSmall*0.8
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
        }
        Rectangle{
            color: "transparent"
            border.color: "blue"
            anchors.fill: parent
            visible: testing_rectagles
        }
        Rectangle{
            id: lineIcon
            visible: myLineList.tappedData.length == 0 ? false : true
            anchors.left: parent.left
            anchors.leftMargin: Theme.itemSizeExtraSmall/4
            anchors.verticalCenter: parent.verticalCenter
            color: 'transparent'
            height: parent.height*0.9
            width: height
            radius: width*0.5
            border{
                width: Theme.itemSizeExtraSmall/12
//                color: lineColor
            }
            Label {
                id: lineNumber
                anchors.centerIn: parent
                color: Theme.primaryColor
                text: ""
                font.pixelSize: Theme.fontSizeExtraSmall
                font.bold: true
            }
        }
        Label{
            id: lineName
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: myLineList.tappedData.length == 0 ? parent.left : lineIcon.right
            anchors.leftMargin: Theme.itemSizeExtraSmall/5
            text: myLineList.tappedData.length == 0 ? qsTr("Please, select a line") : ""
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeExtraSmall
            truncationMode: TruncationMode.Fade
            width: parent.width*0.75
        }
    }
    Map{
        id: myMap
        width: parent.width
        height: Theme.itemSizeHuge
        anchors{
            top: topSafeZone.bottom
            left: parent.left
            right: parent.right
        }
        plugin: Plugin {
            name: "here"
            PluginParameter { name: "app_id"; value: "SATvHCI03dfWJGK1AROi" }
            PluginParameter { name: "app_code"; value: "qsU98SUji0bBsaUhiNJapQ" }
            PluginParameter { name: "proxy"; value: "system" }
        }
        states: [
            State {
                name: "map open"
                PropertyChanges { target: myMap; height: stopsMapPage.height - topSafeZone.height }
                PropertyChanges { target: myLineList; height: 0}
            }
        ]
        MapItemView{
            model: myStopList
            delegate: MapQuickItem {
                id: stopIconItem
                sourceItem: BackgroundItem{
                    Rectangle{
                        visible: false
                        anchors.fill: parent
                        border.color: "red"
                        color: "transparent"
                    }
                    width: stopIcon.width
                    height: stopIcon.height
                    Image{
                        id: stopIcon
                        source: "image://theme/icon-m-location"
                        visible: false
                    }
                    ColorOverlay{
                        anchors.fill: stopIcon
                        source: stopIcon
                        color: 'blue'
                    }
                    onClicked: {
                        console.log("You clicked on stop "+ stopName + " with stopNumber: " + stopNumber)
                        pythonMain.ask(stopNumber);
                        pageStack.push("StopPage.qml", {current_stop: stopNumber})
                    }
                }
                coordinate: QtPositioning.coordinate(latitude, longitude)
                anchorPoint.x: stopIconItem.width/2
                anchorPoint.y: stopIconItem.height
            }
        }
        MapQuickItem {
            id:currentPosition
            sourceItem: BackgroundItem{
                width: currentPositionIcon.width
                height: currentPositionIcon.height
                Rectangle{
                    radius: currentPositionIcon.width
                    gradient: Gradient {
                        GradientStop {
                            position: 0.00;
                            color: Theme.highlightDimmerColor;
                        }
                        GradientStop {
                            position: 1.10;
                            color: "transparent";
                        }
                    }
                    visible: true
                    anchors.fill: parent
                }
                Image{
                    id:currentPositionIcon
                    source: "image://theme/icon-m-person"
                    visible: true
                    ColorOverlay{
                        anchors.fill: currentPositionIcon
                        source: currentPositionIcon
                        color: Theme.primaryColor
                    }
                }
                onClicked: {
                    console.log("Showing near stops")
//                    pageStack.push("About.qml")
                    myMap.state == "map open" ? myMap.state = "" : myMap.state = "map open"
                }
            }
            coordinate: src.position.coordinate
            anchorPoint.x: currentPositionIcon.width/2
            anchorPoint.y: currentPositionIcon.height/2
        }
        Component.onCompleted: {
            myMap.center = QtPositioning.coordinate(40.4166173, -3.704439);
            myMap.zoomLevel = 12;
        }
        MouseArea{
            id: myMapMouseArea
            anchors.fill: parent
            propagateComposedEvents: true
            onClicked: {
                console.log("Clic on map")
                if (myMap.state == ""){
                    myMap.state = "map open"
                }
                else{
                    myMap.state = ""
                }
            }
        }
        transitions: Transition {
            PropertyAnimation { duration: 400; properties: "height"; easing.type: Easing.InOutQuad }
        }
    }
    ListModel{
        id: myStopList
    }
    LineList{
        id: myLineList
        width: parent.width
        clip: true
        anchors{
            top: myMap.bottom
        }
        PageHeader{}
        height: stopsMapPage.height - topSafeZone.height - myMap.height
        transitions: Transition {
            PropertyAnimation { duration: 100; properties: "height"; easing.type: Easing.InOutQuad }
        }
        model: ListModel{
            id: listOfLines
        }
        workingMode: 2
        onTappedDataChanged: {
            if (tappedData.length > 0){
                console.log("tappedData lenght: "+tappedData.length)
                console.log("tappedData: "+tappedData)
                MyUtils.getStopsData(tappedData[4], myStopList)
                lineNumber.text = tappedData[0]
                lineIcon.border.color = tappedData[2]
                lineName.text = tappedData[1]

                myMap.state = "map open"
                console.log("Number of stops loaded: "+myStopList.count)
                myMap.center.latitude = 40.4166173
                myMap.center.longitude = -3.704439
                myMap.zoomLevel = 12;
                console.log("Center: "+myMap.center.latitude+ " - "+ myMap.center.longitude + " zoom level: "+ myMap.zoomLevel)
            }
            else{
                console.log("tappedData still empty")
            }
        }
    }
    Component.onCompleted: {
        rootPage.current_page = ['StopsMap']
        MyUtils.getLines(listOfLines)
//        TO BE DONE
//        listOfLines.insert(0, {"lineNumber": "",
//                               "lineName": qsTr("Near stops"),
//                               "lineColor": "",
//                               "lineType": "",
//                               "code": -1
//                           })
    }
}

