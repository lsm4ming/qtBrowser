cmake_minimum_required(VERSION 3.16)

project(qtBrowser VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick WebEngineWidgets)

qt_standard_project_setup()

qt_add_executable(appqtBrowser
        main.cpp
        browserController.cpp
        browserController.h
        res.qrc
)

# 包含 Qt QML 模块
qt_add_qml_module(appqtBrowser
        URI qtBrowser
        VERSION 1.0
        QML_FILES
        qml/Main.qml
        qml/AddressBar.qml
        qml/BrowserDialog.qml
        qml/BrowserWebView.qml
        qml/BrowserWindow.qml
        qml/BrowserTab.qml
        qml/ToolbarButton.qml
        icons/collect.png
        icons/home.png
        icons/login.png
        icons/logo.png
        icons/new.png
        icons/next.png
        icons/plugins.png
        icons/previous.png
        icons/reload.png
        icons/setting.png
        icons/stop.png
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appqtBrowser PROPERTIES
        #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appqtBrowser
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
)

target_link_libraries(appqtBrowser
        PRIVATE Qt6::Quick
        PRIVATE Qt6::WebEngineWidgets
)

include(GNUInstallDirs)
install(TARGETS appqtBrowser
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
