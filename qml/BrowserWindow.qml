import QtQuick
import QtQml
import QtWebEngine
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import Qt.labs.settings

ApplicationWindow {
    id: browserWindow
    property Item currentWebView: browserViewLayout.children[browserViewLayout.currentIndex]

    width: 1300
    height: 900
    visible: true
    title: currentWebView && currentWebView.title !== " " ? currentWebView.title : "qt浏览器"

    // Is MacOS UI
    readonly property bool platformIsMac: Qt.platform === "osx"

    // FullScreen Button set on OSX
    Component.onCompleted: flags = flags | Qt.WindowFullScreenButtonHint


    Settings {
        id: appSettings
        category: "Browser"
        property alias autoLoadImages: loadImages.checked;
        property alias javascriptEnabled: javaScriptEnabled.checked;
        property alias errorPageEnabled: errorPageEnabled.checked;
        property alias fullScreenSupportEnabled: fullScreenSupportEnabled.checked;
    }


    Shortcut {
        sequence: StandardKey.Close
        onActivated: currentWebView.triggerWebAction(WebEngineView.RequestClose);
    }
    Shortcut { // Ctrl + -
        sequence: StandardKey.ZoomOut
        onActivated: {
            if (currentWebView.zoomFactor > 0.25) {
                currentWebView.zoomFactor -= 0.1;
            }
        }
    }
    Shortcut { // Ctrl + +
        sequence: StandardKey.ZoomIn
        onActivated: {
            if (currentWebView.zoomFactor < 5.0) {
                currentWebView.zoomFactor += 0.1;
            }
        }
    }
    Shortcut { //Ctrl + Z
        sequence: StandardKey.Undo
        onActivated: currentWebView.triggerWebAction(WebEngineView.Undo)
    }
    Shortcut { //Ctrl + Y
        sequence: StandardKey.Redo
        onActivated: currentWebView.triggerWebAction(WebEngineView.Redo)
    }
    Shortcut { //Alt + <-
        sequence: StandardKey.Back
        onActivated: currentWebView.triggerWebAction(WebEngineView.Back)
    }
    Shortcut { //Alt + ->
        sequence: StandardKey.Forward
        onActivated: currentWebView.triggerWebAction(WebEngineView.Forward)
    }
    Shortcut { //Ctrl+Tab
        sequence: "Ctrl+Tab" // StandardKey.NextChild
        onActivated: tabs.currentIndex = Math.min(tabs.currentIndex + 1, tabs.count - 1)
    }
    Shortcut { //Ctrl+Shift+Tab
        sequence: "Ctrl+Shift+Tab" // BUG this doesn't work: StandardKey.PreviousChild
        onActivated: tabs.currentIndex = Math.max(tabs.currentIndex - 1, 0);
    }


    header: ToolBar {
        id: navigationBar
        RowLayout {
            width: parent.width
            ToolbarButton {
                id: backButton
                iconSource: "qrc:/icons/previous.png"
                tooltip: qsTr("Back")
                onClicked: currentWebView.goBack()
                enabled: currentWebView && currentWebView.canGoBack
                activeFocusOnTab: !browserWindow.platformIsMac
                onPressAndHold: backMenu.open()
                onRightClicked: backMenu.open()
                Menu {
                    id: backMenu
                    y: parent.y + parent.height

                    Instantiator {
                        model: currentWebView && currentWebView.navigationHistory.backItems
                        delegate: MenuItem {
                            text: model.title
                            onTriggered: currentWebView.goBackOrForward(model.offset)
                            enabled: model.offset
                            checked: !enabled
                            checkable: !enabled
                        }
                        onObjectAdded: backMenu.insertItem(index, object)
                        onObjectRemoved: backMenu.removeItem(index)
                    }
                }
            }//ToolbarButton
            ToolbarButton {
                id: forwardButton
                iconSource: "qrc:/icons/next.png"
                tooltip: qsTr("Forward")
                onClicked: currentWebView.goForward()
                enabled: currentWebView && currentWebView.canGoForward
                activeFocusOnTab: !browserWindow.platformIsMac
                onPressAndHold: forwardMenu.open()
                onRightClicked: forwardMenu.open()
                Menu {
                    id: forwardMenu
                    y: parent.y + parent.height

                    Instantiator {
                        model: currentWebView && currentWebView.navigationHistory.forwardItems
                        delegate: MenuItem {
                            text: model.title
                            onTriggered: currentWebView.goBackOrForward(model.offset)
                            enabled: model.offset
                            checked: !enabled
                            checkable: !enabled
                        }
                        onObjectAdded: forwardMenu.insertItem(index, object)
                        onObjectRemoved: forwardMenu.removeItem(index)
                    }
                }
            }//ToolbarButton
            ToolbarButton {
                id: reloadButton
                readonly property bool loading: currentWebView && currentWebView.loading
                iconSource: loading ? "qrc:/icons/reload.png" : "qrc:/icons/stop.png"
                tooltip: loading ? qsTr("Stop") : qsTr("Refresh")
                onClicked: loading ? currentWebView.stop() : currentWebView.reload()
                activeFocusOnTab: !browserWindow.platformIsMac
            }//ToolbarButton
            ToolbarButton {
                id: newPageButton
                iconSource: "qtBrowser/icons/new.png"
                tooltip: qsTr("NewPage")
                onClicked: createWindow(defaultProfile)
                activeFocusOnTab: !browserWindow.platformIsMac
            }//ToolbarButton

            AddressBar {
                id: addressBar
                Layout.fillWidth: true
                currentWebView: browserWindow.currentWebView
            }//AddressBar

            ToolbarButton {
                id: settingButton
                iconSource: "qtBrowser/icons/setting.png"
                tooltip: qsTr("Setting")
                onClicked: settingsMenu.open()
                activeFocusOnTab: !browserWindow.platformIsMac
                Menu {
                    id: settingsMenu
                    y: parent.y + parent.height
                    MenuItem {
                        id: loadImages
                        text: "Autoload Images"
                        checkable: true
                        checked: WebEngine.settings.autoLoadImages
                    }
                    MenuItem {
                        id: javaScriptEnabled
                        text: "JavaScript On"
                        checkable: true
                        checked: WebEngine.settings.javascriptEnabled
                    }
                    MenuItem {
                        id: errorPageEnabled
                        text: "ErrorPage On"
                        checkable: true
                        checked: WebEngine.settings.errorPageEnabled
                    }
                    MenuItem {
                        id: fullScreenSupportEnabled
                        text: "FullScreen Support"
                        checkable: true
                        checked: WebEngine.settings.fullScreenSupportEnabled
                    }
                }
            }//ToolbarButton

            ToolbarButton {
                id: homePageButton
                iconSource: "qtBrowser/icons/home.png"
                tooltip: qsTr("HomePage")
                onClicked: currentWebView.url = "https://www.www.baidu.com"
                activeFocusOnTab: !browserWindow.platformIsMac
            }//ToolbarButton


        }//RowLayout

        // ProgressBar
        ProgressBar {
            id: progressBar
            height: 5
            width: parent.width
            anchors {
                left: parent.left
                top: parent.bottom
                right: parent.right
            }
            from:0
            to: 100
            value: (currentWebView && currentWebView.loadProgress < 100) ? currentWebView.loadProgress : 0
        }// ProgressBar

    }//ToolBar

    footer: TabBar {
        id: tabs
        currentIndex: 0
        visible: count > 1

        function createTab(browserView) {
            var component = Qt.createComponent("BrowserTab.qml");
            var tab = component.createObject(tabs, {"webview": browserView});
            tabs.addItem(tab);
        }
    }

    Component {
        id: browserTabComponent
        BrowserWebView {
            onWindowCloseRequested: {

                if (tabs.count == 1) {
                    browserWindow.close()
                } else {
                    var tabCount = browserViewLayout.children.length;

                    for (var i = 0; i < tabCount; i++) {
                        var tab = browserViewLayout.children[i];
                        if (tab === this) {
                            browserViewLayout.children[i].destroy();
                            tabs.removeItem(i);
                            tabs.currentIndex = tabs.count - 1;
                            break;
                        }
                    }
                }

            }

        }
    }

    function createEmptyTab(profile) {
        var browserView = browserTabComponent.createObject(browserViewLayout);

        if (browserView === null) {
            console.error("create tab view error");
            return;
        }

        browserView.profile = profile;
        tabs.createTab(browserView);
        browserViewLayout.children[browserViewLayout.children.length] = browserView;
        return browserView;

    }

    StackLayout {
        id: browserViewLayout
        anchors.fill: parent
        currentIndex: tabs.currentIndex

        Component.onCompleted: {
            createEmptyTab(defaultProfile)
        }
    }


    MouseArea {
        anchors.fill: browserViewLayout
        acceptedButtons: Qt.BackButton | Qt.ForwardButton
        // @disable-check M2
        cursorShape: undefined
        onClicked: {
            if (!currentWebView || currentWebView.url === "")
                return;

            if (mouse.button === Qt.BackButton) {
                currentWebView.triggerWebAction(WebEngineView.Back)
            } else if (mouse.button === Qt.ForwardButton) {
                currentWebView.triggerWebAction(WebEngineView.Forward)
            }
        }
    }

    // url info pane
    Pane {
        id: statusBubble

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        visible: statusText.text !== ""

        Text {
            id: statusText
            anchors.centerIn: parent
            elide: Qt.ElideMiddle

            Timer {
                id: resetStatusText
                interval: 750
                onTriggered: statusText.text = ""
            }
        }
    }


}
