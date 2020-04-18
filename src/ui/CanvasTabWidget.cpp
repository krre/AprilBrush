#include "CanvasTabWidget.h"
#include "Canvas.h"
#include "core/Utils.h"
#include <QtWidgets>

CanvasTabWidget::CanvasTabWidget() {
    setTabsClosable(true);
    setVisible(false);

    connect(this, &QTabWidget::tabCloseRequested, this, &CanvasTabWidget::closeCanvas);
}

void CanvasTabWidget::addCanvas(const QSize& size) {
    QString tabName = tr("Untitled-%1").arg(m_maxTabCount++);
    QSize canvasSize = size.isEmpty() ? Utils::defaultCanvasSize() : size;
    addTab(new Canvas(canvasSize), tabName);
    setCurrentIndex(count() - 1);
    setVisible(true);
}

void CanvasTabWidget::closeCanvas(int index) {
    QWidget* canvas = widget(index);
    removeTab(index);
    delete canvas;

    if (!count()) {
        setVisible(false);
    }
}