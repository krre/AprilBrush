#include "CanvasItem.h"
#include <QtGui>

namespace AprilBrush {

CanvasItem::CanvasItem() {
//    setRenderTarget(QQuickPaintedItem::FramebufferObject);
}

CanvasItem::~CanvasItem() {

}

void CanvasItem::paint(QPainter* painter) {
    painter->drawPixmap(0, 0, *m_pixmap);
}

void CanvasItem::clear() {
    m_pixmap->fill(Qt::transparent);
    update();
}

void CanvasItem::drawImage(const QByteArray& image) {
    QPixmap pixmap;
    pixmap.loadFromData(image);
    QPainter painter(m_pixmap.data());
    painter.drawPixmap(0, 0, pixmap);
    update();
}

QByteArray CanvasItem::image(QPoint topleft, QPoint bottomright) {
    QByteArray ba;
    QBuffer buffer(&ba);
    buffer.open(QIODevice::WriteOnly);
    if (topleft.isNull()) {
        m_pixmap->save(&buffer, "TIFF");
    } else {
        m_pixmap->copy(QRect(topleft, bottomright)).save(&buffer, "TIFF");
    }
    buffer.close();
    return ba;
}

void CanvasItem::setImage(const QByteArray& image, QPoint topleft) {
    if (topleft.isNull()) {
        m_pixmap->loadFromData(image);
    } else {
        QPixmap pixmap;
        pixmap.loadFromData(image);

        QPainter painter(m_pixmap.data());
        painter.setCompositionMode(QPainter::CompositionMode_Source);
        painter.fillRect(QRect(topleft, pixmap.size()), Qt::transparent);
        painter.setCompositionMode(QPainter::CompositionMode_SourceOver);
        painter.drawPixmap(topleft, pixmap);
    }
    update();
}

void CanvasItem::setSize(QSize size) {
    if (m_size == size) return;
    m_size = size;
    if (size.width() && size.height()) {
        m_pixmap.reset(new QPixmap(size));
        m_pixmap->fill(Qt::transparent);
    }

    emit sizeChanged(size);
}

} // AprilBrush
