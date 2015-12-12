#include "canvasitem.h"

CanvasItem::CanvasItem()
{
    setFlag(ItemHasContents, true);
    setAcceptedMouseButtons(Qt::AllButtons);
}

void CanvasItem::setSize(QSize size)
{
    if (m_size == size) return;

    m_size = size;
    qDebug() << size;
    emit sizeChanged(size);
}

QSGNode* CanvasItem::updatePaintNode(QSGNode* node, QQuickItem::UpdatePaintNodeData*)
{
    QSGSimpleTextureNode* n = static_cast<QSGSimpleTextureNode*>(node);
    if (!n) {
//        n = new QSGSimpleTextureNode();
//        n->setOwnsTexture(true);
    }
//    n->setTexture(window()->createTextureFromImage(m_buffer));
//    n->setRect(boundingRect());
    return n;
}

void CanvasItem::mouseMoveEvent(QMouseEvent* event)
{
    qDebug() << "move" << event;
}

void CanvasItem::mousePressEvent(QMouseEvent* event)
{
    qDebug() << "press" << event;
}

void CanvasItem::mouseReleaseEvent(QMouseEvent* event)
{
    qDebug() << "release" << event;
}

