import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello Qt 6.8.2!")

    Text {
        anchors.centerIn: parent
        text: "Hello World!\nQt 6.8.2 QML App"
        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
    }
}