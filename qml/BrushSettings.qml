import QtQuick 2.0

Rectangle {
    id: rect
    width: 200
    height: 200
    color: "#eeeeee"
    border.color: "gray"
    opacity: 0.9
    radius: 7
    antialiasing: true

    property int size: sizeCtrl.value
    property int spacing: spacingCtrl.value
    property int hardness: hardnessCtrl.value
    property int opacity_: opacityCtrl.value

    Text {
        text: "Brush Settings"
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 5
    }

    MouseArea {
        anchors.fill: parent
        drag.target: parent
        //onClicked: parent.z = 1
    }

    Item {
        id: closeRect
        width: 20
        height: 20
        anchors.top: parent.top
        anchors.right: parent.right

        MouseArea {
            anchors.fill: parent
            onClicked: rect.visible = false
        }
    }

    Text {
        text: "x"
        font.pointSize: 10
        anchors.centerIn: closeRect
    }

    Column {
        width: parent.width
        y: 30
        Slider {id: sizeCtrl; name: "Size"; min: 1; max: 200; init: 30}
        Slider {id: spacingCtrl; name: "Spacing"; min: 1; max: 100; init: 30}
        Slider {id: opacityCtrl; name: "Opacity"; min: 0; max: 100; init: 50}
        Slider {id: hardnessCtrl; name: "Hardness"; min: 1; max: 100; init: 85}
    }
}