#ifndef BASE_CONNECTOR_H
#define BASE_CONNECTOR_H

#include <QObject>
#include <QString>
#include <QSqlDatabase>
#include <QStandardPaths>

class base_connector : public QObject
{
    Q_OBJECT
private:
    QSqlDatabase main_handler = QSqlDatabase::addDatabase("QPSQL");
    QString file = QStandardPaths::standardLocations(QStandardPaths::HomeLocation)[0] + "data";
public:
    explicit base_connector(QObject *parent = nullptr);
    QString last_updatetime();
    bool status()
    {
        return main_handler.open();
    };
    QVector <QVector <QString>> base_update();
    void close_handler()
    {
        main_handler.close();
    }

signals:

};

#endif // BASE_CONNECTOR_H
