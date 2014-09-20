import QtQuick 2.3
import QtQuick.Controls 1.2
import "../utils.js" as Utils
import "../undo.js" as Undo

Item {
    property alias newAction: newAction
    property alias openAction: openAction
    property alias saveAction: saveAction
    property alias saveAsAction: saveAsAction
    property alias exportAction: exportAction
    property alias quitAction: quitAction

    property alias undoAction: undoAction
    property alias redoAction: redoAction
    property alias clearAction: clearAction

    property alias newLayerAction: newLayerAction
    property alias deleteLayerAction: deleteLayerAction
    property alias mergeLayerAction: mergeLayerAction
    property alias duplicateLayerAction: duplicateLayerAction
    property alias upLayerAction: upLayerAction
    property alias downLayerAction: downLayerAction

    property alias zoomInAction: zoomInAction
    property alias zoomOutAction: zoomOutAction
    property alias rotationAction: rotationAction
    property alias mirrorAction: mirrorAction
    property alias resetAction: resetAction

    Action {
        id: newAction
        text: qsTr("New")
        shortcut: "Ctrl+N"
        onTriggered: {
            layerModel.clear()
            layerManager.addBackground()
            layerManager.addLayer()
            undoManager.clear()
            canvasArea.resetTransform() // after adding new tab on runnging application
            mainRoot.onWidthChanged.connect(function resTransform() {
                canvasArea.resetTransform() // after adding new tab on start application
                canvasArea.onWidthChanged.disconnect(resTransform)
            })
        }
        tooltip: qsTr("New an Image")
    }

    Action {
        id: openAction
        text: qsTr("Open...")
        shortcut: "Ctrl+O"
        tooltip: qsTr("Open an Image")
        onTriggered: {
            fileDialog.mode = 0
            fileDialog.open()
        }
    }

    Action {
        id: saveAction
        text: qsTr("Save")
        shortcut: "Ctrl+S"
        tooltip: qsTr("Save an Image")
        onTriggered: {
            if (oraPath === "") {
                fileDialog.mode = 1; // Save mode
                fileDialog.open()
            } else {
                Utils.saveOra()
            }
        }
    }

    Action {
        id: saveAsAction
        text: qsTr("Save As...")
        shortcut: "Ctrl+Shift+S"
        tooltip: qsTr("Save as an Image")
        onTriggered: {
            fileDialog.mode = 1
            fileDialog.open()
        }
    }

    Action {
        id: exportAction
        text: qsTr("Export...")
        shortcut: "Ctrl+E"
        tooltip: qsTr("Export an Image to PNG")
        onTriggered: {
            fileDialog.mode = 2
            fileDialog.open()
        }
        enabled: layerModel && layerModel.count > 0
    }

    Action {
        id: quitAction
        text: qsTr("Quit")
        shortcut: "Ctrl+Q"
        onTriggered: mainRoot.close()
        tooltip: text
    }

    Action {
        id: undoAction
        text: qsTr("Undo")
        shortcut: "Ctrl+Z"
        onTriggered: {
            undoManager.undoView.decrementCurrentIndex()
            undoManager.run(undoManager.undoView.currentIndex)
        }
        enabled: undoManager.undoView.currentIndex > 0
    }

    Action {
        id: redoAction
        text: qsTr("Redo")
        shortcut: "Ctrl+Shift+Z"
        onTriggered: {
            undoManager.undoView.incrementCurrentIndex()
            undoManager.run(undoManager.undoView.currentIndex)
        }
        enabled: undoModel ? undoManager.undoView.currentIndex < undoModel.count - 1 : false
    }

    Action {
        id: clearAction
        text: qsTr("Clear")
        shortcut: "Delete"
        onTriggered: undoManager.add(Undo.clearLayer())
        enabled: currentLayerIndex >= 0
    }

    // layer management

    Action {
        id: newLayerAction
        text: qsTr("New")
        shortcut: "Shift+Ctrl+N"
        onTriggered: layerManager.addLayer()
        tooltip: qsTr("New Layer")
    }

    Action {
        id: deleteLayerAction
        text: qsTr("Delete")
        onTriggered: undoManager.add(Undo.deleteLayer())
        tooltip: qsTr("Delete Layer")
        enabled: layerManager.layerView.count > 1
    }

    Action {
        id: mergeLayerAction
        text: qsTr("Merge Down")
        enabled: currentLayerIndex < layerManager.layerView.count - 2
        onTriggered: undoManager.add(Undo.mergeLayer())
    }

    Action {
        id: duplicateLayerAction
        text: qsTr("Duplicate")
        onTriggered: undoManager.add(Undo.duplicateLayer())
        enabled: layerManager.layerView.count > 1
    }

    Action {
        id: upLayerAction
        text: qsTr("Up")
        enabled: currentLayerIndex > 0
        onTriggered: undoManager.add(Undo.raiseLayer())
    }

    Action {
        id: downLayerAction
        text: qsTr("Down")
        enabled: currentLayerIndex < layerManager.layerView.count - 2
        onTriggered: undoManager.add(Undo.lowerLayer())
    }

    // canvas transform

    Action {
        id: zoomInAction
        text: qsTr("Zoom In")
        shortcut: "+"
        onTriggered: if (zoom < 30) zoom *= 1.5
    }

    Action {
        id: zoomOutAction
        text: qsTr("Zoom Out")
        shortcut: "-"
        onTriggered: if (zoom > 0.01) zoom /= 1.5
    }

    Action {
        id: rotationAction
        text: qsTr("Rotation")
        shortcut: "R"
        onTriggered: rotation += 90
    }

    Action {
        id: mirrorAction
        text: qsTr("Mirror")
        shortcut: "M"
        onTriggered: mirror *= -1
    }

    Action {
        id: resetAction
        text: qsTr("Reset")
        shortcut: "0"
        onTriggered: canvasArea.resetTransform()
    }
}

