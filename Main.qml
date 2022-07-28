/***************************************************************************
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com
* Copyright (c) 2015-2018 Lubuntu Artwork Team
* Copyright (c) 2022 Jurriaan H. Spaaks
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0
import QtGraphicalEffects 1.12

Rectangle {

    property int sessionIndex: config.sessionIndex || sessionModel.lastIndex || 0

    width: 1024
    height: 768

    TextConstants {
        id: textConstants
    }

    FontLoader {
        id: font
        name: config.fontName
    }    

    Connections {
        target: sddm
        function onLoginSucceeded() {
        }

        function onLoginFailed() {
            usernameInput.text = ""
            usernameInput.focus = true
            usernameInput.enabled = true
            passwordInput.text = ""
            passwordInput.enabled = true
            message.text = textConstants.loginFailed            
        }
    }

    Text {
        property int em: parent.height / 50
        id: basefont
        visible: false
    }

    Rectangle {

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top;
        color: config.backgroundColor || "black"
        height: parent.height
        id: fullscreenRect
        width: parent.width

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            color: config.backgroundColor || "black"
            height: parent.height / 6
            id: topSpacer
            width: parent.width
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: topSpacer.bottom
            color: config.backgroundColor || "black"
            height: parent.height / 6
            id: clockRow
            width: parent.width

            Clock {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: config.clockColor || "white"
                dateFont.family: font.name
                dateFont.pixelSize: 1.1 * basefont.em
                id: clock
                timeFont.bold: true
                timeFont.family: font.name
                timeFont.pixelSize: 3 * basefont.em
            }
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            border.color: "transparent"
            color: config.backgroundColor || "black"
            height: parent.height / 3
            id: userdataRow
            radius: 4
            width: parent.width / 3

            Rectangle {
                anchors.right: usernameInput.left
                color: "transparent"
                height: parent.height
                id: hSpacer
                width: 0.5 * basefont.em
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"
                height: 0.5 * basefont.em
                id: vSpacer
                width: parent.width
            }

            Text {
                anchors.right: hSpacer.left
                anchors.verticalCenter: usernameInput.verticalCenter
                color: config.textColor || "white"
                font.family: font.name
                font.pixelSize: 1 * basefont.em 
                id: usernameText
                text: "username:"
            }
            
            PasswordBox {
                anchors.bottom: vSpacer.top
                anchors.horizontalCenter: parent.horizontalCenter
                borderColor: config.textboxBorderColor || "black"
                echoMode: TextInput.Password
                focus: true
                font.family: font.name
                font.pixelSize: 1 * basefont.em
                color: config.textboxBgColor || "white"
                height: 2 * basefont.em 
                id: usernameInput
                KeyNavigation.tab: passwordInput
                radius: 5
                textColor: config.textboxTextColor || "black"
                width: 15 * basefont.em
                onTextChanged: {
                    if (message.text != "") {
                        message.text = ""
                    }
                }
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        passwordInput.disabled = true
                        usernameInput.disabled = true
                        sddm.login(usernameInput.text, passwordInput.text, sessionIndex)
                        event.accepted = true
                    }
                }
            }
            
            Text {
                anchors.right: hSpacer.left
                anchors.verticalCenter: passwordInput.verticalCenter
                color: config.textColor || "white"
                font.family: font.name
                font.pixelSize: usernameText.font.pixelSize
                id: passwordText
                text: "password:"
            }
            
            PasswordBox {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: vSpacer.bottom
                borderColor: config.textboxBorderColor || "black"
                color: config.textboxBgColor || "white"
                font.family: font.name
                font.pixelSize: 1 * basefont.em
                height: usernameInput.height
                id: passwordInput
                KeyNavigation.backtab: usernameInput
                KeyNavigation.tab: submit
                radius: 5
                textColor: config.textboxTextColor || "black"
                width: 15 * basefont.em
                onTextChanged: {
                    if (message.text != "") {
                        message.text = ""
                    }
                }
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        passwordInput.enabled = false
                        usernameInput.enabled = false
                        sddm.login(usernameInput.text, passwordInput.text, sessionIndex)
                        event.accepted = true
                    }
                }
            }

            Rectangle {
                anchors.left: passwordInput.right
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"
                height: parent.height
                id: hSpacer2
                width: 0.5 * basefont.em
            }

            Button {
                activeColor: config.submitBgColorActive || "transparent"
                anchors.left: hSpacer2.right
                anchors.verticalCenter: passwordInput.verticalCenter
                antialiasing: true
                border.color: config.submitBorderColor || "white"
                color: config.submitBgColor || "transparent"
                font.family: font.name
                font.pixelSize: usernameText.font.pixelSize
                height: passwordInput.height
                id: submit
                KeyNavigation.backtab: passwordInput
                KeyNavigation.tab: btnSuspend
                onClicked: {
                    passwordInput.enabled = false
                    usernameInput.enabled = false
                    sddm.login(usernameInput.text, passwordInput.text, sessionIndex)
                }
                radius: 4
                textColor: config.submitTextColor || "white"
                text: "Log in"
                width: 5 * basefont.em
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: passwordInput.bottom
                color: "transparent"
                height: 1.0 * basefont.em
                id: vSpacer2
                width: parent.width
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: vSpacer2.bottom
                color: config.textColor || "white"
                font.family: font.name
                font.pixelSize: 1 * basefont.em
                id: message
                text: ""
            }

        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: userdataRow.bottom
            color: config.backgroundColor || "black"
            height: parent.height / 6
            id: buttonRow
            width: parent.width

            ImageButton {
                anchors.right: buttonSpacer1.left
                anchors.verticalCenter: parent.verticalCenter
                antialiasing: true
                height: 2 * basefont.em
                id: btnSuspend
                KeyNavigation.backtab: submit
                KeyNavigation.tab: btnReboot
                onClicked: sddm.suspend()
                opacity: 1.0
                source: "suspend.svg"
                visible: true //sddm.canSuspend
                width: 2 * basefont.em
            }

            Rectangle {
                anchors.top: btnSuspend.bottom
                anchors.horizontalCenter: btnSuspend.horizontalCenter
                anchors.margins: 0.5 * basefont.em
                radius: 4
                height: 0.1 * basefont.em
                color: btnSuspend.activeFocus ? config.buttonColor : "transparent"
                width: btnSuspend.width + 0.5 * basefont.em
            }

            Rectangle {
                anchors.right: btnReboot.left
                id: buttonSpacer1
                height: parent.height
                color: "transparent"
                width: 4 * basefont.em
            }

            ImageButton {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                antialiasing: true
                height: 2 * basefont.em
                id: btnReboot
                KeyNavigation.backtab: btnSuspend
                KeyNavigation.tab: btnShutdown
                onClicked: sddm.reboot()
                opacity: 1.0
                source: "reboot.svg"
                visible: true //sddm.canReboot
                width: 2 * basefont.em
            }

            Rectangle {
                anchors.top: btnReboot.bottom
                anchors.horizontalCenter: btnReboot.horizontalCenter
                anchors.margins: 0.5 * basefont.em
                radius: 4
                height: 0.1 * basefont.em
                color: btnReboot.activeFocus ? config.buttonColor : "transparent"
                width: btnReboot.width + 0.5 * basefont.em
            }
            
            Rectangle {
                anchors.left: btnReboot.right
                id: buttonSpacer2
                height: parent.height
                color: "transparent"
                width: 4 * basefont.em
            }

            ImageButton {
                anchors.left: buttonSpacer2.right
                anchors.verticalCenter: parent.verticalCenter
                antialiasing: true
                height: 3 * basefont.em
                id: btnShutdown
                KeyNavigation.backtab: btnReboot
                onClicked: sddm.powerOff()
                opacity: 1.0
                source: "shutdown.svg"
                visible: true //sddm.canPowerOff
                width: 2 * basefont.em
            }

            Rectangle {
                anchors.top: btnShutdown.bottom
                anchors.horizontalCenter: btnShutdown.horizontalCenter
                anchors.margins: 0.5 * basefont.em
                radius: 4
                height: 0.1 * basefont.em
                color: btnShutdown.activeFocus ? config.buttonColor : "transparent"
                width: btnShutdown.width + 0.5 * basefont.em
            }

        }
    }
}
