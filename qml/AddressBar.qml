import QtQuick
import QtQuick.Controls

TextField {
    id: addressBar
    selectByMouse: true
    activeFocusOnPress: true
    activeFocusOnTab: true
    persistentSelection: true
    placeholderText: qsTr("Type URL here...")

    property Item currentWebView

    Image {
        id: faviconImage
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: (parent.height - parent.contentHeight) / -5

        width: height
        height: addressBar.contentHeight
        sourceSize: Qt.size(width, height)
        source: currentWebView && currentWebView.icon
        visible: source !== ""
    }
    leftPadding: faviconImage.source !== "" ? faviconImage.width * 1.5 : 0
    focus: true
    text: currentWebView && currentWebView.url
    onAccepted: currentWebView.url = text
}
