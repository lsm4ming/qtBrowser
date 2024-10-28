import QtQuick
import QtWebEngine
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import Qt.labs.settings

WebEngineView {
    id: webEngineView
    focus: true

    settings.autoLoadImages: appSettings.autoLoadImages;
    settings.javascriptEnabled: appSettings.javaScriptEnabled;
    settings.errorPageEnabled: appSettings.errorPageEnabled;
    settings.fullScreenSupportEnabled: appSettings.fullScreenSupportedEnabled;


    WebEngineProfile {
        id: webProfile
    }

    onLinkHovered: {
        if (hoveredUrl === "") {
            resetStatusText.start()
        } else {
            resetStatusText.stop()
            statusText.text = hoveredUrl
        }
    }

    onUrlChanged: {

    }

    onCertificateError: {

    }

    // QT6 不支持
    // onNewViewRequested: {
    //     let tab;
    //     if (!request.userInitiated) {
    //         console.log("warning: request.userInitiated ")
    //     } else if (request.destination === WebEngineView.NewViewInTab) {
    //         tab = createEmptyTab(currentWebView.profile);
    //         tabs.currentIndex = tabs.count - 1
    //         request.openIn(tab)
    //     } else if (request.destination === WebEngineView.NewViewInBackgroundTab) {
    //         tab = createEmptyTab(currentWebView.profile);
    //         request.openIn(tab)
    //     } else if (request.destination === WebEngineView.NewViewInDialog) {
    //         const dialog = applicationRoot.createDialog(currentWebView.profile);
    //         request.openIn(dialog.currentWebView)
    //     } else {
    //         const window = applicationRoot.createWindow(currentWebView.profile);
    //         request.openIn(window.currentWebView)
    //     }
    // }

    onFullScreenRequested: {

    }

    onFeaturePermissionRequested: {

    }


    onRenderProcessTerminated: {

    }


}
