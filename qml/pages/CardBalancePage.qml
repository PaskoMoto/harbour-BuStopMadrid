import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
/*    property bool testing_rectangles: false
    property bool cardBalanceInfo: if (rootPage.var_card_balance.length > 1 && rootPage.var_card_balance[0] !== -1){
                                       console.log("There is something")
                                       loading = false
                                       return true
                                   }
                                   else{
                                       console.log("There is nothing")
                                       return false
                                   }
    property bool loading: false
    property string current_code: ""

    function pushAskButton(){
        current_code = cardCode.text;
        pythonMain.askCardBalance(cardCode.text);
        console.log(rootPage.var_card_balance);
    }
    SilicaFlickable {
        anchors.fill: parent
        PageHeader {
            id: header
            title: qsTr("Card Balance")
        }
        Item{
        id: resultsContainer
        width: parent.width*0.95
        height: 0
        clip: true
        states: [
            State {
                name: "open"
                PropertyChanges { target: resultsContainer; height: Theme.itemSizeHuge }
            }
        ]
        transitions: Transition {
                PropertyAnimation { duration: 150; properties: "height"; easing.type: Easing.InOutQuad }
        }
        anchors{
            top: header.bottom
            horizontalCenter: parent.horizontalCenter
        }
        Rectangle{
            visible: testing_rectangles
            anchors.fill: parent
            color: "transparent"
            border.color: "#ffffff"
        }
        BusyIndicator {
            anchors{
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            size: BusyIndicatorSize.Medium
            running: if (!cardBalanceInfo && loading){
                         return true
                     }
                     else{
                         return false
                     }
        }
        Label{
            id: cardCodeLabel
            visible: cardBalanceInfo
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
            anchors{
                left: parent.left
                leftMargin: Theme.itemSizeExtraSmall/10
                top: parent.top
            }
            text: qsTr("Nº")
        }
        Label{
            id: cardCodeLabelContent
            visible: cardBalanceInfo
            font.pixelSize: Theme.fontSizeSmall
            anchors{
                left: cardCodeLabel.right
                leftMargin: Theme.itemSizeExtraSmall/20
                verticalCenter: cardCodeLabel.verticalCenter
            }
//            text: ((cardBalanceInfo) ? rootPage.var_card_balance[0].substring(0,4)+" "+rootPage.var_card_balance[0].substring(4,8)+" "+rootPage.var_card_balance[0].substring(8,12) : "")
            text: ((cardBalanceInfo) ? current_code.substring(0,4)+" "+current_code.substring(4,8)+" "+current_code.substring(8,12) : "")
        }
        Label{
            id: cardTypeLabel
            visible: cardBalanceInfo
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
            anchors{
                left: parent.left
                leftMargin: Theme.itemSizeExtraSmall/10
                top: cardCodeLabel.bottom
            }
            text: qsTr("Card type: ")
        }
        Label{
            id: cardTypeLabelContent
            visible: cardBalanceInfo
            font.pixelSize: Theme.fontSizeSmall
            anchors{
                left: cardTypeLabel.right
                leftMargin: Theme.itemSizeExtraSmall/20
                verticalCenter: cardTypeLabel.verticalCenter
            }
            text: ((cardBalanceInfo) ? rootPage.var_card_balance[1] : "")
        }
        Label{
            id: cardExpirationLabel
            visible: cardBalanceInfo
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
            anchors{
                left: parent.left
                leftMargin: Theme.itemSizeExtraSmall/10
                top: cardTypeLabel.bottom
            }
            text: qsTr("Expiration: ")
        }
        Label{
            id: cardExpirationLabelContent
            visible: cardBalanceInfo
            font.pixelSize: Theme.fontSizeSmall
            anchors{
                left: cardExpirationLabel.right
                leftMargin: Theme.itemSizeExtraSmall/20
                verticalCenter: cardExpirationLabel.verticalCenter
            }
            text: ((cardBalanceInfo) ? rootPage.var_card_balance[2] : "")
        }
        Label{
            id: cardBalanceLabel
            visible: cardBalanceInfo
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
            anchors{
                left: parent.left
                leftMargin: Theme.itemSizeExtraSmall/10
                top: cardExpirationLabel.bottom
            }
            text: qsTr("Balance: ")
        }
        Label{
            id: cardBalanceLabelContent
            visible: cardBalanceInfo
            font.pixelSize: Theme.fontSizeSmall
            anchors{
                left: cardBalanceLabel.right
                leftMargin: Theme.itemSizeExtraSmall/20
                verticalCenter: cardBalanceLabel.verticalCenter
            }
            text: ((cardBalanceInfo) ? String(parseInt(rootPage.var_card_balance[3])/1000)+" €" : "")
        }
        Label{
            id: cardTripsLabel
            visible: cardBalanceInfo
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
            anchors{
                right: parent.right
                rightMargin: Theme.itemSizeSmall
                top: cardExpirationLabel.bottom
            }
            text: qsTr("Remaining trips: ")
        }
        Label{
            id: cardTripsLabelContent
            visible: cardBalanceInfo
            font.pixelSize: Theme.fontSizeSmall
            anchors{
                left: cardTripsLabel.right
                leftMargin: Theme.itemSizeExtraSmall/20
                verticalCenter: cardTripsLabel.verticalCenter
            }
            text: ((cardBalanceInfo) ? rootPage.var_card_balance[4] : "")
        }
        }
        Item{
            id: textFieldContainer
            width: parent.width*0.95
            height: Theme.itemSizeMedium
            anchors{
                top: resultsContainer.bottom
                topMargin: Theme.itemSizeExtraSmall/2
                horizontalCenter: parent.horizontalCenter
            }
            TextField{
                id:cardCode
                width: Theme.itemSizeHuge*2.75
                anchors{
                    top: parent.top
                    topMargin: Theme.itemSizeExtraSmall/3.3
                    left: parent.left
                    leftMargin: Theme.itemSizeExtraSmall/20
                }
                placeholderText: qsTr("Enter your card code")
                focus: true
                label:qsTr("The card code is 12 digits long")
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.onClicked: pushAskButton();
                validator: RegExpValidator { regExp: /[0-9]{12,12}/ }
                Rectangle{
                    visible: testing_rectangles
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "yellow"
                }
            }
            BackgroundItem{
                width: Theme.itemSizeExtraSmall
                height: width
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: Theme.itemSizeExtraSmall/10
                }
                Image{
                    anchors.centerIn: parent
                    source: "image://theme/icon-m-clear"
                }
                onClicked: {
                    cardCode.text = ''
                    rootPage.var_card_balance = []
                    resultsContainer.state = ""
                }
                Rectangle{
                    visible: testing_rectangles
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "blue"
                }
            }
            Rectangle{
                visible: testing_rectangles
                anchors.fill: parent
                color: "transparent"
                border.color: "#ffffff"
            }
        }
        Button{
            id: askButton
            anchors{
                horizontalCenter: textFieldContainer.horizontalCenter
                top: textFieldContainer.bottom
                topMargin: Theme.itemSizeExtraSmall/2
            }
            width: Theme.itemSizeExtraLarge*1.2
            text: qsTr("Ask!")
            enabled: {
                if (cardCode.text.length === 12){
                    return true
                }
                else{
                    return false
                }
            }

            onClicked: {
                loading = true
                resultsContainer.state = "open"
                pushAskButton();
            }
        }
    }
    Component.onCompleted: {
        rootPage.current_page = ['CardBalancePage']
        rootPage.var_card_balance = []
        console.log("var_card_balance"+rootPage.var_card_balance+".")
    }*/
}
