/* AprilBrush - Digital Painting Software
 * Copyright (C) 2012-2014 Vladimir Zarypov <krre31@gmail.com>
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

import QtQuick 2.3
import QtQuick.Controls 1.2
import "components"
import "settings.js" as Settings

ToolWindow {
    id: root
    title: qsTr("Brush Settings")
    property alias dab: dab
    property alias diameter: diameter.value
    property alias opaque: opaque.value
    property alias flow: flow.value
    property alias hardness: hardness.value
    property alias spacing: spacing.value
    property alias roundness: roundness.value
    property alias angle: angle.value
    property alias jitter: jitter.value
    property alias eraser: eraser.value

    objectName: "brushSettings"
    storage: {
        var list = defaultStorage()
        list.push("diameter", "opaque", "flow", "hardness", "spacing", "roundness", "angle", "jitter", "eraser")
        return list
    }

    signal settingsChanged()

    onDiameterChanged: coreLib.setCursorShape("Paint", diameter.value)

    ScrollView {
        id: scrollView
        anchors.fill: parent

        ListView {
            clip: true
            spacing: 2

            model: VisualItemModel {
                id: brushModel
                property real sliderWidth: scrollView.width !== scrollView.viewport.width ? scrollView.viewport.width - 5 : scrollView.width
                SliderText { id: diameter; title: qsTr("Diameter"); width: brushModel.sliderWidth; minimumValue: 1; maximumValue: 100; value: 20; onValueChanged: root.settingsChanged() }
                SliderText { id: opaque; title: qsTr("Opaque"); width: brushModel.sliderWidth; value: 85; onValueChanged: root.settingsChanged() }
                SliderText { id: flow; title: qsTr("Flow"); width: brushModel.sliderWidth; value: 50; onValueChanged: root.settingsChanged() }
                SliderText { id: hardness; title: qsTr("Hardness"); width: brushModel.sliderWidth; minimumValue: 1; value: 95; onValueChanged: root.settingsChanged() }
                SliderText { id: spacing; title: qsTr("Spacing"); width: brushModel.sliderWidth; minimumValue: 5; maximumValue: 200; value: 25; onValueChanged: root.settingsChanged() }
                SliderText { id: roundness; title: qsTr("Roundness"); width: brushModel.sliderWidth; minimumValue: 1; maximumValue: 100; value: 100; onValueChanged: root.settingsChanged() }
                SliderText { id: angle; title: qsTr("Angle"); width: brushModel.sliderWidth; minimumValue: 0; maximumValue: 180; value: 0; onValueChanged: root.settingsChanged() }
                SliderText { id: jitter; title: qsTr("Jitter"); width: brushModel.sliderWidth; minimumValue: 0; maximumValue: 500; value: 0; onValueChanged: root.settingsChanged() }
                SliderText { id: eraser; title: qsTr("Eraser"); width: brushModel.sliderWidth; minimumValue: 0; maximumValue: 100; value: 0; onValueChanged: root.settingsChanged() }
            }
        }
    }

    Canvas {
        id: dab
        width: diameter.value
        height: diameter.value
        visible: false
        antialiasing: true

        onPaint: {
            var ctx = dab.getContext("2d")
            ctx.save()
            ctx.clearRect(0, 0, width, height)

            var originX = width / 2
            var originY = width / 2

            ctx.translate(originX, originY)
            ctx.rotate(angle.value / 180 * Math.PI)
            ctx.scale(1.0, roundness.value / 100)
            ctx.translate(-originX, -originY)

            var color = Qt.rgba(colorPicker.color.r, colorPicker.color.g, colorPicker.color.b, flow.value / 100)
            var gradient = ctx.createRadialGradient(width / 2, height / 2, 0, width / 2, height / 2, width / 2)
            gradient.addColorStop(0, color);
            gradient.addColorStop(hardness.value / 100, color);
            gradient.addColorStop(1, Qt.rgba(colorPicker.color.r, colorPicker.color.g, colorPicker.color.b, hardness.value / 100 < 1 ? 0 : flow.value / 100));

            ctx.ellipse(0, 0, width, width)
            ctx.fillStyle = gradient
            ctx.fill()

            ctx.restore();
        }
    }
}

