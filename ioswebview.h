#ifndef IOSWEBVIEW_H
#define IOSWEBVIEW_H

#include <QQuickItem>

class IOSWebView : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString url MEMBER url NOTIFY urlChanged)
public:
    explicit IOSWebView(QQuickItem *parent = 0);
    ~IOSWebView();

protected:
    QSGNode* updatePaintNode(QSGNode *pNode, UpdatePaintNodeData*);
    virtual void componentComplete();
    virtual void itemChange(ItemChange change, const ItemChangeData & value);

private:
    QPointF absoluteQMLPosition();

    void* pWebView;

    QString url;
    QRectF qmlRect;


signals:
    void updateWebViewSize();
    void urlChanged(QString newUrl);

private slots:
    void onUpdateWebViewSize();
    void onUrlChanged(QString newUrl);

};
#endif // IOSWEBVIEW_H
