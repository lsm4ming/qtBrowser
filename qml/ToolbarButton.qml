import QtQuick
import QtQuick.Controls

ToolButton {
    id: control
    hoverEnabled: true
    padding: width * .25

    property alias iconSource: icon.source
    property string tooltip

    signal rightClicked(int modifiers)

    contentItem: Image {
        id: icon
        fillMode: Image.PreserveAspectCrop
        width: control.availableWidth
        height: control.availableHeight
        sourceSize: Qt.size(width, height)
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        opacity: control.enabled ? 1.0 : 0.5

        ToolTip.visible: control.hovered && control.tooltip !== ""
        ToolTip.timeout: 750
        ToolTip.text: control.tooltip
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: {
            if (mouse.button === Qt.RightButton) {
                control.rightClicked(mouse.modifiers)
            }
        }
    }
}
