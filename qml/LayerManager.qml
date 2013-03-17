import QtQuick 2.0
import "components"
import "utils.js" as Utils

Window {
    id: root
    property alias currentLayer: layersView.currentIndex
    property alias layersView: layersView

    title: "Layers"
    parent: main
    visible: (index == pagesView.currentIndex) && layerManagerVisible
    x: layerManagerPos.x
    y: layerManagerPos.y
    z: 4
    onReleased: layerManagerPos = Qt.point(x, y)

    Column {
        width: parent.width
        spacing: 5

        ListView {
            id: layersView
            model: layerSet
            delegate: layerDelegate
            highlight: layerSelected
            highlightMoveDuration: 1

            width: parent.width
            height: 120

            orientation: ListView.Vertical
            clip: true
            spacing: 4
        }

        Component {
            id: layerDelegate
            ListItem {
                text: name
                color: ListView.isCurrentItem ? "transparent" : "lightgray"
                onClicked: currentLayer = index
                onClosed: {
                    layerSet.remove(index)
                }
            }
        }

        Component {
            id: layerSelected
            ListItemComponent {
                width: layersView.width
            }
        }

        // Buttons
        Row {
            width: parent.width
            height: 20
            spacing: 4

            // New button
            Button {
                width: parent.width / 4 - 4
                height: parent.height
                text: qsTr("New")
                onClicked: {
                    // Calculate next number layer
                    var maxNumLayer = 0;
                    for (var layer = 0; layer < layerSet.count; layer++) {
                        var numLayer = parseInt(layerSet.get(layer).name.substring(6), 10)
                        if (numLayer > maxNumLayer) maxNumLayer = numLayer
                    }
                    maxNumLayer++
                    var numNextLayer = Utils.zeroFill(maxNumLayer, 3)
                    if (currentLayer < 0) currentLayer = 0
                    layerSet.insert(currentLayer, { name: "Layer-" + numNextLayer, colorImage: "transparent", enable: true })
                    layersView.decrementCurrentIndex()
                }
            }
            // Up button
            Button {
                width: parent.width / 4 - 4
                height: parent.height
                text: qsTr("Up")
                onClicked: {
                    if (currentLayer > 0)
                        layerSet.move(currentLayer, currentLayer - 1, 1)
                }
            }
            // Down button
            Button {
                width: parent.width / 4 - 4
                height: parent.height
                text: qsTr("Down")
                onClicked: {
                    if (currentLayer < layersView.count - 1)
                        layerSet.move(currentLayer, currentLayer + 1, 1)
                }
            }
            // Clone button
            Button {
                width: parent.width / 4 - 4
                height: parent.height
                text: qsTr("Clone")
                onClicked: {
                    console.log("Clone layer")
                }
            }
        }
    }
}
