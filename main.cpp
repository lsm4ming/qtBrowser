#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWebEngineView>
#include <QQmlContext>
#include <QDir>
#include <QResource>
#include "browserController.h"

static QUrl startupUrl()
{
    return QStringLiteral("https://www.baidu.com/index.html");
}

int main(int argc, char *argv[])
{
    QGuiApplication::setOrganizationName("lsm1998");
    QGuiApplication::setOrganizationDomain("https://www.lsm1998.com");

    QGuiApplication app(argc, argv);

    // 设置图标
    QGuiApplication::setWindowIcon(QIcon("qtBrowser/icons/logo.png"));

    QQmlApplicationEngine engine;

    BrowserController controller;
    auto context = engine.rootContext();
    context->setContextProperty("controller", &controller);

    const QUrl url("qrc:/qtBrowser/qml/Main.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []()
                     { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);
    engine.load(url);

    // 加载首页
    QMetaObject::invokeMethod(engine.rootObjects().first(), "load", Q_ARG(QVariant, startupUrl()));

    return QGuiApplication::exec();
}
