import QtQuick 2.8

Rectangle {
    default property alias content: content.data
    property string title
    color: sysPalette.window

    Item {
        id: content
        anchors.fill: parent
        anchors.margins: 7
    }
}
