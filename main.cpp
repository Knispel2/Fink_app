#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "base_connector.h"
#include <QtWebView>
#include <QSslSocket>


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QtWebView::initialize();
    QGuiApplication app(argc, argv);

    app.setOrganizationName("MSU_FSR");
    app.setOrganizationDomain("msu.ru");
    app.setApplicationName("Fink_app");
    qmlRegisterType <base_connector> ("Main_handler_plus", 1, 0, "SQL_handler");
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    qDebug() << "Device supports OpenSSL: " << QSslSocket::supportsSsl();
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
