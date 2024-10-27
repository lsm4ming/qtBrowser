import QtQuick
import QtQuick.Window
import QtWebEngine

Window {
    property alias currentWebView: webView
    flags: Qt.Dialog
    width: 800
    height: 600
    visible: true
    title: qsTr("qt浏览器")

    onClosing: destroy()

    WebEngineView {
        id: webView
        anchors.fill: parent
    }

}
