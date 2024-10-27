import QtQuick
import QtQuick.Window
import QtWebEngine

QtObject {
    id: root

    // 默认模式 存储名称为default
    property QtObject defaultProfile: WebEngineProfile {
        storageName: "default"
    }

    // 无痕模式 存储名称为incognito
    property QtObject otrProfile: WebEngineProfile {
        storageName: "incognito"
        offTheRecord: true
    }

    // 导入BrowserDialog
    property Component browserDialogComponent: BrowserDialog {
        onClosing: destroy()
    }


    // 创建对话框
    function createDialog(profile) {
        const newDialog = browserDialogComponent.createObject(root);
        newDialog.currentWebView.profile = profile
        return newDialog
    }

    // 加载网页
    function load(url) {
        const browserWindow = createDialog(defaultProfile);
        browserWindow.currentWebView.url = url
    }
}