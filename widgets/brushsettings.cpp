#include "brushsettings.h"

BrushSettings::BrushSettings(BrushEngine *brushEngine)
{
    brush = brushEngine;
    setWindowTitle(tr("Brush Settings"));
    setWindowFlags(Qt::WindowStaysOnTopHint | Qt::Tool);
    resize(400, -1);

    gridLayout = new QGridLayout;
    signalMapper = new QSignalMapper(this);

    addSlider(tr("Size"), 1, 20, 150, SLOT(setSizeBrush(int)), 0);
    addSlider(tr("Opacity"), 0, 50, 100, SLOT(setAlpha(int)), 1);
    addSlider(tr("Spacing"), 1, 25, 500, SLOT(setSpacingBrush(int)), 3);

    connect(signalMapper, SIGNAL(mapped(const QString &)), this, SLOT(resetSlider(const QString &)));

    setLayout(gridLayout);
}

void BrushSettings::resetSlider(const QString &sliderName)
{
    QSlider *slider = findChild<QSlider*>(sliderName);
    slider->setValue(defaultSlider[sliderName]);
}

void BrushSettings::addSlider(QString name, int minValue, int defaultValue, int maxValue, const char *slot, int row)
{
    QLabel *label = new QLabel(name);
    gridLayout->addWidget(label, row, 0);

    QSlider *slider = new QSlider(Qt::Horizontal);
    slider->setRange(minValue, maxValue);
    slider->setValue(defaultValue);
    defaultSlider[name] = defaultValue;
    slider->setObjectName(name);
    gridLayout->addWidget(slider, row, 1);

    QSpinBox *spinBox = new QSpinBox();
    spinBox->setMaximum(maxValue);
    spinBox->setValue(defaultValue);
    gridLayout->addWidget(spinBox, row, 3);

    QPushButton *button = new QPushButton(tr("R"));
    button->setMaximumWidth(30);
    gridLayout->addWidget(button, row, 4);

    connect(slider, SIGNAL(valueChanged(int)), spinBox, SLOT(setValue(int)));
    connect(slider, SIGNAL(valueChanged(int)), brush, slot);
    connect(spinBox, SIGNAL(valueChanged(int)), slider, SLOT(setValue(int)));
    connect(button, SIGNAL(clicked()), signalMapper, SLOT(map()));
    signalMapper->setMapping(button, name);
}
