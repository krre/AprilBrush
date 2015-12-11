import QtQuick 2.5
import QtQuick.Controls 1.3
import "../../js/utils.js" as Utils
import "../../js/enums.js" as Enums
import "../../js/undo.js" as Undo

MenuBar {

    Menu {
        title: qsTr("File")

        MenuItem {
            text: qsTr("New")
            shortcut: "Ctrl+N"
            onTriggered: {
                var title = qsTr("Unnamed")
                var tab = tabView.addTab(title)
                tab.setSource("qrc:/qml/main/WorkArea.qml", { title: title })
                tabView.currentIndex = tabView.count - 1
            }
        }

        MenuItem {
            text: qsTr("Open...")
            shortcut: "Ctrl+O"
            onTriggered: Utils.createDynamicObject(mainRoot, "qrc:/qml/components/filedialog/FileDialogBase.qml", { mode: Enums.FileOpen })
        }

        MenuItem {
            text: qsTr("Save")
            shortcut: "Ctrl+S"
            onTriggered: {
                if (oraPath === "") {
                    Utils.createDynamicObject(mainRoot, "qrc:/qml/components/filedialog/FileDialogBase.qml", { mode: Enums.FileSave })
                } else {
                    Utils.saveOra()
                }
            }
            enabled: isDirty
        }

        MenuItem {
            text: qsTr("Save As...")
            shortcut: "Ctrl+Shift+S"
            onTriggered: Utils.createDynamicObject(mainRoot, "qrc:/qml/components/filedialog/FileDialogBase.qml", { mode: Enums.FileSave })
        }

        MenuItem {
            text: qsTr("Export...")
            shortcut: "Ctrl+E"
            onTriggered: Utils.createDynamicObject(mainRoot, "qrc:/qml/components/filedialog/FileDialogBase.qml", { mode: Enums.FileExport })
            enabled: layerModel && layerModel.count > 0
        }

        MenuSeparator {}

        MenuItem {
            text: qsTr("Close")
            shortcut: "Ctrl+W"
            onTriggered: tabView.removeTab(tabView.currentIndex)
            enabled: tabView.count > 0
        }

        MenuItem {
            text: qsTr("Close All")
            shortcut: "Ctrl+Shift+W"
            onTriggered: {
                while (tabView.count > 0) {
                    tabView.removeTab(0)
                }
            }
            enabled: tabView.count > 0
        }

        MenuItem {
            text: qsTr("Close Other")
            enabled: tabView.count > 1
            onTriggered: {
                var i = 0
                while (tabView.count > 1) {
                    if (i !== tabView.currentIndex) {
                        tabView.removeTab(i)
                    } else {
                        i++
                    }
                }
            }
        }

        MenuSeparator {}

        MenuItem {
            text: qsTr("Exit")
            shortcut: "Ctrl+Q"
            onTriggered: mainRoot.close()
        }
    }

    Menu {
        title: qsTr("Edit")

        MenuItem {
            text: qsTr("Undo")
            shortcut: "Ctrl+Z"
            onTriggered: {
                undoManager.undoView.decrementCurrentIndex()
                undoManager.run(undoManager.undoView.currentIndex)
            }
            enabled: undoManager.undoView.currentIndex > 0
        }

        MenuItem {
            text: qsTr("Redo")
            shortcut: "Ctrl+Shift+Z"
            onTriggered: {
                undoManager.undoView.incrementCurrentIndex()
                undoManager.run(undoManager.undoView.currentIndex)
            }
            enabled: undoModel ? undoManager.undoView.currentIndex < undoModel.count - 1 : false
        }

        MenuItem {
            text: qsTr("Clear")
            shortcut: "Delete"
            onTriggered: undoManager.add(Undo.clearLayer())
            enabled: currentLayerIndex >= 0
        }
    }

    Menu {
        title: qsTr("Layer")

        MenuItem { action: actions.newLayerAction }

        MenuItem { action: actions.deleteLayerAction }

        MenuItem { action: actions.mergeLayerAction }

        MenuItem { action: actions.duplicateLayerAction }

        MenuItem { action: actions.upLayerAction }

        MenuItem { action: actions.downLayerAction }
    }

    Menu {
        title: qsTr("View")

        MenuItem {
            text: qsTr("Zoom In")
            shortcut: "."
            onTriggered: canvas3DArea.zoomIn()
        }

        MenuItem {
            text: qsTr("Zoom Out")
            shortcut: ","
            onTriggered: canvas3DArea.zoomOut()
        }

        MenuItem {
            text: qsTr("Rotation")
            shortcut: "R"
            onTriggered: canvas3DArea.rotation += 90
        }

        MenuItem {
            text: qsTr("Mirror")
            shortcut: "M"
            onTriggered: canvas3DArea.mirror *= -1
        }

        MenuItem {
            text: qsTr("Reset")
            shortcut: "F12"
            onTriggered: canvas3DArea.resetTransform()
        }
    }

    Menu {
        title: qsTr("Help")

        MenuItem {
            text: qsTr("About...")
            onTriggered: Utils.createDynamicObject(mainRoot, "qrc:/qml/main/About.qml")
        }
    }
}
