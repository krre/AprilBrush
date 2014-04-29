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

function loadSettings(parent) {
    var settings = coreLib.loadSettings()
    if (settings) {
        settings = JSON.parse(settings)
        for (var i = 0; i < settings.length; i++) {
            var objName = settings[i].name
            for (var j = 0; j < parent.data.length; j++) {
                if (objName === parent.data[j].objectName) {
                    var properties = settings[i].properties
                    for (var prop in properties) {
                        if (typeof parent.data[j][prop] !== undefined) {
                            var value = properties[prop]
                            if (value === "true") {
                                parent.data[j][prop] = true
                            } else if (value === "false") {
                                parent.data[j][prop] = false
                            } else {
                                parent.data[j][prop] = value.toString()
                            }
                        }
                    }
                    break
                }
            }
        }
    }
}

function saveSettings(parent) {
    var settings = []
    for (var i = 0; i < parent.data.length; i++) {
        var storage = parent.data[i].storage
        if (storage) {
            var obj = {}
            obj.name = parent.data[i].objectName
            obj.properties = {}
            for (var j = 0; j < storage.length; j++) {
                obj.properties[storage[j]] = parent.data[i][storage[j]].toString()
            }
            settings.push(obj)
        }
    }
    coreLib.saveSettings(JSON.stringify(settings, null, 4))
}

