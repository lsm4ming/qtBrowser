#ifndef QTBROWSER_BROWSERCONTROLLER_H
#define QTBROWSER_BROWSERCONTROLLER_H

#include <QObject>

class BrowserController : public QObject
{
Q_OBJECT

    Q_PROPERTY(int myValue READ myValue WRITE setMyValue NOTIFY myValueChanged)

public:
    explicit BrowserController(QObject *parent = nullptr);

    [[nodiscard]] int myValue() const;

    void setMyValue(int value);

signals:
    void myValueChanged();

private:
    int myValue_;
};

#endif //QTBROWSER_BROWSERCONTROLLER_H
