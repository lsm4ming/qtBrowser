#include "browserController.h"

BrowserController::BrowserController(QObject *parent) : QObject(parent)
{

}

int BrowserController::myValue() const
{
    return this->myValue_;
}

void BrowserController::setMyValue(int value)
{
    if (this->myValue_ == value)
        return;
    this->myValue_ = value;
    emit this->myValueChanged();
}
