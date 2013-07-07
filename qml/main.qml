/* AprilBrush - Digital Painting Software
 * Copyright (C) 2012-2013 Vladimir Zarypov <krre@mail.ru>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation;
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

import QtQuick 2.1
import QtQuick.Dialogs 1.0
import AprilBrushLib 1.0
import "components"
import "settings.js" as Settings
import "utils.js" as Utils
import "undo.js" as Undo

Rectangle {
    id: main

    property string version: "AprilBrush 0.1.1"

    property var settings
    // Settings property don't works for Layer Manager and Undo Manager
    property vector3d layerManagerPos
    property size layerManagerSize
    property bool layerManagerVisible
    property vector3d undoManagerPos
    property size undoManagerSize
    property bool undoManagerVisible

    property size imageSize: coreLib.screenSize()
    property bool eraserMode: false
    property variant currentPageItem: pageManager.pagesView.currentItem
    property int currentPageIndex: pageManager.pagesView.currentIndex
    property int layerIdCounter: 0
    property string currentLayerId

    property bool dockMode: false

    Component.onCompleted: {
        Settings.loadSettings()
        main.width = settings.mainWindow.width
        main.height = settings.mainWindow.height

        layerManagerPos.x = settings.layerManager.position.x
        layerManagerPos.y = settings.layerManager.position.y
        layerManagerPos.z = settings.layerManager.position.z
        layerManagerSize.width = settings.layerManager.size.width
        layerManagerSize.height = settings.layerManager.size.height
        layerManagerVisible = settings.layerManager.visible

        undoManagerPos.x = settings.undoManager.position.x
        undoManagerPos.y = settings.undoManager.position.y
        undoManagerPos.z = settings.undoManager.position.z
        undoManagerSize.width = settings.undoManager.size.width
        undoManagerSize.height = settings.undoManager.size.height
        undoManagerVisible = settings.undoManager.visible
    }
    Component.onDestruction: Settings.saveSettings()

    color: "lightgray"

    BrushEngine {
        id: brushEngine
        color: colorPicker.color
        size: brushSettings.size.value
        spacing: brushSettings.spacing.value
        hardness: brushSettings.hardness.value
        opacity: brushSettings.opaque.value
        roundness: brushSettings.roundness.value
        angle: brushSettings.angle.value
        jitter: brushSettings.jitter.value
        eraser: eraserMode
        layerId: currentLayerId
        imageProcessor: imgProcessor
        onPaintDone: currentPageItem.canvasArea.pathView.currentItem.update()
    }

    ImageProcessor {
        id: imgProcessor
        layerId: currentLayerId
    }

    OpenRaster {
        id: openRaster
        imageProcessor: imgProcessor
    }

    CoreLib {
        id: coreLib
    }

    ListModel {
        id: pageModel
    }

    Item {
        id: workArea
        anchors.fill: parent

        PageManager {
            id: pageManager
            z: 1
            anchors.horizontalCenter: parent.horizontalCenter
        }

        BrushSettings {
            id: brushSettings
            x: settings.brushSettings.position.x
            y: settings.brushSettings.position.y
            z: settings.brushSettings.position.z
            width: settings.brushSettings.size.width
            height: settings.brushSettings.size.height
            visible: settings.brushSettings.visible
        }

        ColorPicker {
            id: colorPicker
            x: settings.colorPicker.position.x
            y: settings.colorPicker.position.y
            z: settings.colorPicker.position.z
            width: settings.colorPicker.size.width
            height: settings.colorPicker.size.height
            color: Utils.hsvToHsl(settings.colorPicker.color.h,
                                  settings.colorPicker.color.s,
                                  settings.colorPicker.color.v)
            visible: settings.colorPicker.visible

            defaultHeight: 220
        }

        BrushLibrary {
            id: brushLibrary
            x: settings.brushLibrary.position.x
            y: settings.brushLibrary.position.y
            z: settings.brushLibrary.position.z
            width: settings.brushLibrary.size.width
            height: settings.brushLibrary.size.height
            visible: settings.brushLibrary.visible
        }

        FileDialog {
            id: fileDialog

            property int mode: 0 // 0 - open, 1 - save, 2 - export, 3 - folder

            selectExisting: mode == 0 ? true : false
            selectFolder: mode == 3 ? true : false
            nameFilters: mode == 2 ? "Images (*.png)" : "OpenRaster (*.ora)"
            onAccepted: {
                switch (mode) {
                    case 0: Utils.openOra(fileDialog.fileUrl); break
                    case 1: Utils.saveAsOra(fileDialog.fileUrl); break
                    case 2: Utils.exportPng(fileDialog.fileUrl); break
                }
            }
        }
    }

    About {
        id: aboutWindow
        visible: false
    }

    Dock {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: dockMode
    }
}

