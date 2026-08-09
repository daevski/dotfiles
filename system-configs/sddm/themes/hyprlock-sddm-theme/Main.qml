import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 1920
    height: 1080

    property string textColor: "#c6d0f5"
    property string lavenderColor: "#babbf1"
    property string baseColor: "#303446"
    property string crustColor: "#232634"
    property string redColor: "#e78284"

    // Prefer lastUser; fall back to first user in model
    property string initialUser: {
        if (userModel.lastUser !== "") return userModel.lastUser
        if (userModel.rowCount() > 0) return userModel.data(userModel.index(0, 0), Qt.UserRole)
        return ""
    }

    function doLogin() {
        sddm.login(usernameField.text, passwordField.text, sessionCombo.currentIndex)
    }

    // Background
    Image {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        asynchronous: false
        cache: false
        smooth: true
    }

    // Dark overlay (simulates hyprlock blur/darken)
    Rectangle {
        anchors.fill: parent
        color: crustColor
        opacity: 0.45
    }

    // Clock
    Text {
        id: timeText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -300

        text: Qt.formatTime(new Date(), "hh:mm")
        color: textColor
        font.family: "AudioLink Mono"
        font.pixelSize: 120
        font.weight: Font.Light

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: timeText.text = Qt.formatTime(new Date(), "hh:mm")
        }
    }

    // Date
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: timeText.bottom
        anchors.topMargin: -10

        text: Qt.formatDate(new Date(), "dddd, MMMM d")
        color: textColor
        font.family: "AudioLink Mono"
        font.pixelSize: 24
    }

    // Password field (below center, matching hyprlock position -120)
    Rectangle {
        id: passwordBg
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 120
        width: 300
        height: 50
        color: baseColor
        border.color: passwordField.activeFocus ? lavenderColor : Qt.darker(lavenderColor, 1.5)
        border.width: 2

        TextField {
            id: passwordField
            anchors.fill: parent
            anchors.margins: 10

            placeholderText: "Enter Password..."
            placeholderTextColor: "#80c6d0f5"
            echoMode: TextInput.Password
            color: textColor
            selectionColor: lavenderColor
            selectedTextColor: baseColor
            font.family: "AudioLink Mono"
            font.pixelSize: 14

            background: Rectangle { color: "transparent" }

            Keys.onReturnPressed: doLogin()
            Keys.onEnterPressed: doLogin()
            Keys.onTabPressed: usernameField.forceActiveFocus()
        }
    }

    // Auth failure message
    Text {
        id: statusText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: passwordBg.bottom
        anchors.topMargin: 10

        text: ""
        color: redColor
        font.family: "AudioLink Mono"
        font.pixelSize: 13

        Connections {
            target: sddm
            function onLoginFailed() {
                statusText.text = "Authentication Failed"
                passwordField.clear()
                passwordField.forceActiveFocus()
            }
            function onLoginSucceeded() {
                statusText.text = ""
            }
        }
    }

    // Username field (below password, matching hyprlock position -200)
    // Styled as a label; gets a subtle border when focused so you know it's editable.
    // Tab from password field lands here; Enter/Return returns focus to password.
    Rectangle {
        id: usernameBg
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 200
        width: 300
        height: 34
        color: "transparent"
        border.color: usernameField.activeFocus ? "#66babbf1" : "transparent"
        border.width: 1

        TextField {
            id: usernameField
            anchors.fill: parent
            anchors.margins: 4

            text: root.initialUser
            color: lavenderColor
            selectionColor: lavenderColor
            selectedTextColor: baseColor
            horizontalAlignment: Text.AlignHCenter
            font.family: "AudioLink Mono"
            font.pixelSize: 18

            background: Rectangle { color: "transparent" }

            Keys.onReturnPressed: passwordField.forceActiveFocus()
            Keys.onEnterPressed: passwordField.forceActiveFocus()
            Keys.onTabPressed: passwordField.forceActiveFocus()
        }
    }

    // Session selector (bottom left)
    ComboBox {
        id: sessionCombo
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 40
        width: 240
        height: 36

        model: sessionModel
        currentIndex: Math.max(0, sessionModel.lastIndex)
        textRole: "name"

        background: Rectangle {
            color: baseColor
            border.color: Qt.darker(lavenderColor, 1.5)
            border.width: 1
        }

        contentItem: Text {
            leftPadding: 10
            rightPadding: 26
            text: sessionCombo.displayText
            color: textColor
            font.family: "AudioLink Mono"
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        indicator: Text {
            x: sessionCombo.width - width - 8
            anchors.verticalCenter: parent.verticalCenter
            text: "▼"
            color: lavenderColor
            font.pixelSize: 9
        }

        delegate: ItemDelegate {
            id: sessionDelegate
            width: sessionCombo.width
            height: 32
            highlighted: sessionCombo.highlightedIndex === index

            contentItem: Text {
                text: model.name
                color: sessionDelegate.highlighted ? baseColor : textColor
                font.family: "AudioLink Mono"
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
                leftPadding: 10
            }

            background: Rectangle {
                color: sessionDelegate.highlighted ? lavenderColor : baseColor
            }
        }

        popup: Popup {
            y: -height
            x: 0
            width: sessionCombo.width
            padding: 0

            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: sessionCombo.popup.visible ? sessionCombo.delegateModel : null
                currentIndex: sessionCombo.highlightedIndex
            }

            background: Rectangle {
                color: baseColor
                border.color: Qt.darker(lavenderColor, 1.5)
                border.width: 1
            }
        }
    }

    // Power buttons (bottom right)
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 40
        spacing: 14

        Rectangle {
            width: 36
            height: 36
            color: baseColor
            border.color: Qt.darker(lavenderColor, 1.5)
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "⟳"
                color: textColor
                font.pixelSize: 20
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: sddm.reboot()
            }
        }

        Rectangle {
            width: 36
            height: 36
            color: baseColor
            border.color: Qt.darker(lavenderColor, 1.5)
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "⏻"
                color: textColor
                font.pixelSize: 20
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: sddm.powerOff()
            }
        }
    }

    Component.onCompleted: {
        passwordField.forceActiveFocus()
    }
}
