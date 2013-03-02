TARGET = AprilBrush
QT += quick

SOURCES += \
    main.cpp \
    cpp/paintspace.cpp \
    cpp/brushengine.cpp \

HEADERS += \
    cpp/paintspace.h \
    cpp/brushengine.h \

OTHER_FILES += \
    qml/main.qml \
    qml/PagePanel.qml \
    qml/FilePanel.qml \
    qml/ColorPicker.qml \
    qml/BrushSettings.qml \
    qml/Slider.qml \
    qml/utils.js \
    qml/components/Window.qml

QMAKE_POST_LINK += $$QMAKE_COPY_DIR $$PWD/qml $(DESTDIR) $$escape_expand(\\n\\t)
QMAKE_POST_LINK += $$QMAKE_COPY_DIR $$PWD/svg $(DESTDIR) $$escape_expand(\\n\\t)




