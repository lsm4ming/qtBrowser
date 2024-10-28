import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebEngine

TabButton {
    id: control

    property var webview

    contentItem: RowLayout {
        Image {
            id: faviconImage
            width: height; height: control.height / 2
            sourceSize: Qt.size(width, height)
            visible: source !== "" && !busyIndicator.running
            source: webview && webview.icon
        }
        BusyIndicator {
            id: busyIndicator
            visible: running
            running: webview && webview.loading
        }
        Text {
            id: pageTitle
            Layout.fillWidth: true
            text: webview && webview.title ? webview.title : qsTr("Untitled")
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideMiddle
        }
        ToolButton {
            text: "X"
            font.pixelSize: 30
            onClicked: webview.triggerWebAction(WebEngineView.RequestClose)
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton
        onClicked: {
            webview.triggerWebAction(WebEngineView.RequestClose)
        }
    }
}
