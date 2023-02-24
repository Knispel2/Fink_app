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
    QSqlDatabase main_handler;
    QString file = QStandardPaths::standardLocations(QStandardPaths::HomeLocation)[0] + "data";
public:
    explicit base_connector(QObject *parent = nullptr);
    Q_INVOKABLE QString last_updatetime();
    Q_INVOKABLE bool status()
    {
        return main_handler.open();
    };
    Q_INVOKABLE QVector <QString> base_update();
    Q_INVOKABLE void close_handler()
    {
        main_handler.close();
    }
    Q_INVOKABLE void delete_obj(QString name);

signals:

};

#endif // BASE_CONNECTOR_H
