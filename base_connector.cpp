#include "base_connector.h"
#include "qvariant.h"
#include <QSqlQuery>
#include <QSqlRecord>
#include <QFileInfo>

base_connector::base_connector(QObject *parent)
    : QObject{parent}
{
    main_handler.setHostName("mouse.db.elephantsql.com");
    main_handler.setDatabaseName("fcohpgef");
    main_handler.setUserName("fcohpgef");
    main_handler.setPassword("rg1S1vdZW5PeHnFvC9QSeqyS5qy3jEl6");
}

QString base_connector::last_updatetime() //если true, то обновлять не нужно
{
    QFileInfo check_file(file);
    if (!(check_file.exists() && check_file.isFile()))
        return "";
    QSqlQuery query(main_handler);
    QString buf_result;
    if (query.exec("SELECT * FROM service limit 1;"))
    {
        while (query.next())
        {
            QSqlRecord row = query.record();
            for (int i = 0; i < row.count(); ++i)
            {
                buf_result = row.value(i).toString();
            }
        }
    }
    return buf_result;
}

QVector<QVector<QString> > base_connector::base_update()
{
    QSqlQuery query(main_handler);
    QVector <QString> buf;
    QVector <QVector<QString>> result;
    if (query.exec("SELECT * FROM data;")) //TODO: добавить встраиваемые условия фильтрации
    {
        while (query.next())
        {
            QSqlRecord row = query.record();
            buf.clear();
            for (int i = 0; i < row.count(); ++i)
                buf << QString(row.value(i).toString());
            result.append(buf);
        }
    }
    return result;
}
