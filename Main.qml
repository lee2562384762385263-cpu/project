import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Notification App")

    ScrollView {
        anchors.fill: parent
        anchors.margins: 20

        ColumnLayout {
            width: parent.width
            spacing: 20

            // Header
            Text {
                text: qsTr("Notification App")
                font.pixelSize: 28
                font.bold: true
                color: "#333333"
                Layout.alignment: Qt.AlignHCenter
            }

            // Permission section
            GroupBox {
                title: qsTr("Permissions")
                Layout.fillWidth: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    Text {
                        text: qsTr("Request notification permission to receive notifications")
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    Button {
                        text: qsTr("Request Permission")
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: {
                            notificationManager.requestNotificationPermission()
                        }
                    }
                }
            }

            // Notification content section
            GroupBox {
                title: qsTr("Last Notification")
                Layout.fillWidth: true
                visible: notificationManager.hasNotificationData

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    Text {
                        text: qsTr("Title:")
                        font.bold: true
                    }

                    Text {
                        text: notificationManager.lastNotificationTitle
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        color: "#0066cc"
                    }

                    Text {
                        text: qsTr("Body:")
                        font.bold: true
                    }

                    Text {
                        text: notificationManager.lastNotificationBody
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        color: "#333333"
                    }

                    Text {
                        text: qsTr("Additional Data:")
                        font.bold: true
                        visible: Object.keys(notificationManager.lastNotificationData).length > 0
                    }

                    Text {
                        text: JSON.stringify(notificationManager.lastNotificationData, null, 2)
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        color: "#666666"
                        font.family: "monospace"
                        visible: Object.keys(notificationManager.lastNotificationData).length > 0
                    }

                    Button {
                        text: qsTr("Clear Notification Data")
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: {
                            notificationManager.clearNotificationData()
                        }
                    }
                }
            }

            // Status section
            GroupBox {
                title: qsTr("Status")
                Layout.fillWidth: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    Text {
                        id: statusText
                        text: notificationManager.hasNotificationData ? 
                              qsTr("App opened from notification!") : 
                              qsTr("App ready - waiting for notifications")
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        color: notificationManager.hasNotificationData ? "#00aa00" : "#666666"
                    }

                    Text {
                        text: qsTr("To test: Send a notification to this device, close the app completely, then tap the notification to reopen it.")
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        font.pixelSize: 12
                        color: "#888888"
                    }
                }
            }

            // Test section (for development)
            GroupBox {
                title: qsTr("Development Testing")
                Layout.fillWidth: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    Text {
                        text: qsTr("Simulate notification data for testing:")
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    Button {
                        text: qsTr("Simulate Test Notification")
                        Layout.alignment: Qt.AlignHCenter
                        onClicked: {
                            var testData = {
                                "custom_key": "custom_value",
                                "timestamp": new Date().toISOString(),
                                "source": "test"
                            }
                            notificationManager.handleNotificationReceived(
                                "Test Notification",
                                "This is a test notification to verify the UI works correctly.",
                                testData
                            )
                        }
                    }
                }
            }
        }
    }

    // Connection to handle permission results
    Connections {
        target: notificationManager
        function onNotificationPermissionResult(granted) {
            if (granted) {
                statusText.text = qsTr("Notification permission granted!")
                statusText.color = "#00aa00"
            } else {
                statusText.text = qsTr("Notification permission denied.")
                statusText.color = "#aa0000"
            }
        }

        function onNotificationReceived(title, body) {
            statusText.text = qsTr("New notification received: ") + title
            statusText.color = "#0066cc"
        }
    }
}