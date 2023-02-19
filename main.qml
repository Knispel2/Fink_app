import QtQuick 2.2
import QtQuick.Controls.Material 2.12
import QtQuick.Controls 2.3
import QtQuick.Extras 1.4
import "qrc:/test_data.js" as CDs
import Qt.labs.settings 1.0

ApplicationWindow {
    id : main
    visible: true
    width: 400
    height: 900
    Material.theme: Material.White
    Material.accent: Material.Purple
    property string datastore: ""
    Settings
    {
        property alias datastore: main.datastore
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
                    text: '<b>objectId:</b>' + modelData.objectId
                    font.pixelSize: 20
                }
                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: '<b>rb:</b>' + modelData.rb
                    font.pixelSize: 20
                }
                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: '<b>anomaly_score:</b>' + modelData.anomaly_score
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
                    MenuItem { text: "Remove" }
                    MenuItem { text: "Add to fav" }
                    MenuItem { text: "Browse" }
                }
            }
        }

    }



    onClosing:
    {
        var datamodel = []
        for (var i = 0; i < dataModel.count; ++i) datamodel.push(dataModel.get(i))
        datastore = JSON.stringify(datamodel)
    }

    Component.onCompleted:
    {
        if (datastore)
        {
          dataModel.clear()
          var datamodel = JSON.parse(datastore)
          for (var i = 0; i < datamodel.length; ++i) dataModel.append(datamodel[i])
        }
    }

    Component
    {
        id:delegate_fav


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
                    text: '<b>objectId:</b>' + modelData.objectId
                    font.pixelSize: 20
                }
                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: '<b>rb:</b>' + modelData.rb
                    font.pixelSize: 20
                }
                Text
                {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: '<b>anomaly_score:</b>' + modelData.anomaly_score
                    font.pixelSize: 20
                }
            }
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
            model: main_model //TODO: нужно переделать на ListModel
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
            delegate: delegate_fav
        }
        Item
        {
            id: fourtyPage
        }
    }
}
