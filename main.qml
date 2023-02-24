import QtQuick 2.2
import QtQuick.Controls.Material 2.12
import QtQuick.Controls 2.3
import Qt.labs.settings 1.0
import Main_handler_plus 1.0
import QtWebView 1.1
import "server_methods.js" as Server_methods

ApplicationWindow {
    id : main
    visible: true
    width: 400
    height: 700
    Material.theme: Material.White
    Material.accent: Material.Purple
    property int debug_flag : 0
    property string datastore: ""
    property string ignore_list: ""
    property string load_data: ""
    Settings
    {
        property alias datastore: main.datastore
        property alias ignore_list: main.ignore_list
    }
    //TODO: сделать игнор-лист для удаленных объектов, сохранять его в Settings
    //TODO: добавить в основной датафрейм дату

    Component
    {
        id:delegate
        Rectangle
        {
            id: element
            border.width: 1
            border.color: "black"
            height: 40
            width: parent.width
            Row
            {
                spacing: 5
                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: '<b>Id:</b>' + ID
                    font.pixelSize: 20
                }
                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: '<b>rb:</b>' + rb
                    font.pixelSize: 20
                }
                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: '<b>anm_score:</b>' + anomaly_score
                    font.pixelSize: 20
                }
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    if (mouse.button === Qt.RightButton)
                        contextMenu.popup()
                }
                onPressAndHold: {
                    if (mouse.source === Qt.MouseEventNotSynthesized)
                        contextMenu.popup()
                }

                Menu {
                    id: contextMenu
                    MenuItem { text: "Remove" } //TODO: удаление теперь можно сделать с удалением из базы через запрос
                    MenuItem
                    {
                        text: "Add to fav"
                        onTriggered:
                        {
                            fav_model.append({"ID": ID, "rb":rb, "anomaly_score":anomaly_score})
                        }
                    }
                    MenuItem
                    {
                        text: "Browse"
                        onTriggered:
                        {
                            var buf = "https://fink-portal.org/" + ID
                            test_browser.url = buf
                            view.currentIndex = 3
                        }
                    }
                }
            }
        }

    }

    onClosing:
    {
        var datamodel = [] //TODO: такой же должен быть механизм добавления объекта через кнопку
        for (var i = 0; i < fav_model.count; ++i) datamodel.push(fav_model.get(i))
        datastore = JSON.stringify(datamodel)
    }



    Component.onCompleted:
    {
//        if (datastore)
//        {
//          fav_model.clear()
//          var datamodel = JSON.parse(datastore)
//          for (var i = 0; i < datamodel.length; ++i)
//              fav_model.append(datamodel[i])
//        }
//        base_update()

        Server_methods.read_operation
        (
         function load_func(obj)
            {
                main.load_data = obj
                var debug_buf = JSON.parse(main.load_data).record.alerts
                for (var i = 0; i < debug_buf.length; ++i)
                    main_model.append(debug_buf[i])
            }
        )
    }

//    SQL_handler{id: plus_handler}

    function in_id(target_id, iter_obj_lmodel)
    {
        for (var i = 0; i < iter_obj_lmodel.length; ++i)
            if (iter_obj_lmodel.get(i).ID === target_id)
                return true;
        return false;
    }

    function base_update() //TODO: надо написать функцию выгрузки базы
    {
        var base_buf = plus_handler.base_update()
        main_model.clear()
        for (var i = 0; i < base_buf.length; ++i)
        {
            //var test = '{"ID":"ZA3213214","rb":1, "anomaly_score":1}'
            var result_buf = JSON.parse(base_buf[i])    //(test) //base_buf[i])
            if (in_id(result_buf.objectId, fav_model)) continue;
            main_model.append(result_buf)
        }
    }


    ListModel
    {
      id : main_model
    }

    ListModel
    {
      id : fav_model
    }

    TitleBar
    {
        id: titleBar
        currentIndex: view.currentIndex
        onTitleClicked:
        {
            view.currentIndex = index
        }
    }

    SwipeView
    {
        id: view
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom

        currentIndex: 1

        Item
        {
            id: firstPage
        }
        ListView
        {
            id: secondPage
            focus: true
            highlight: Rectangle
            { color: "lightsteelblue" }
            spacing: 1
            anchors.fill: view.fill
            model: main_model
            delegate: delegate
        }
        ListView
        {
            id: thirdPage
            focus: true
            highlight: Rectangle
            { color: "lightsteelblue" }
            spacing: 1
            anchors.fill: view.fill
            model: fav_model
            delegate: delegate
        }
        WebView
        {
            id: test_browser
            visible: true
            anchors.fill: view.fill
            url: "https://fink-portal.org/ZTF21abfmbix"
        }
    }
}
