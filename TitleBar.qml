import QtQuick 2.5

Rectangle    {
    id: titleBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: parent.height*0.11
    width:parent.width
    color: "#202227"

    property var __titles: ["Settings", "Main", "Fav", "Browser"]
    property int currentIndex: 1

    signal titleClicked(int index)

    Repeater {
        model: 4
        Text {
            width: titleBar.width / 4
            height: titleBar.height
            x: index * width
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: __titles[index]
            font.pixelSize: 20
            color: "white"
           // color: titleBar.currentIndex === index ? GameSettings.textColor : GameSettings.disabledTextColor

            MouseArea {
                anchors.fill: parent
                onClicked: titleClicked(index)
            }
        }
    }


    Item {
        anchors.bottom: parent.bottom
        width: parent.width / 4
        height: parent.height
        x: currentIndex * width

        BottomLine{}

        Behavior on x { NumberAnimation { duration: 200 } }
    }

}
