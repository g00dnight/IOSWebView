#include "ioswebview.h"

#include <QtGui/QGuiApplication>
#include <QtGui/qpa/qplatformnativeinterface.h>

#include <UIKit/UIKit.h>

IOSWebView::IOSWebView(QQuickItem *parent) :
    QQuickItem(parent)
{
    setFlag(QQuickItem::ItemHasContents);
    pWebView = NULL;

    connect(this, SIGNAL(updateWebViewSize()), this, SLOT(onUpdateWebViewSize()));
    connect(this, SIGNAL(urlChanged(QString)), this, SLOT(onUrlChanged(QString)));
}

IOSWebView::~IOSWebView()
{
    if (pWebView) {
        [(UIWebView*)pWebView removeFromSuperview];
        [(UIWebView*)pWebView release];
        pWebView = NULL;
    }
}

void IOSWebView::componentComplete()
{
    QQuickItem::componentComplete();
    if (pWebView == NULL) {
        UIView *pMainView = static_cast<UIView*>(QGuiApplication::platformNativeInterface()->nativeResourceForWindow("uiview", (QWindow*)window()));
        pWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [pMainView addSubview:(UIWebView*)pWebView];
        ((UIWebView*)pWebView).scalesPageToFit = YES;
        onUrlChanged(url);
    }
}

void IOSWebView::itemChange(ItemChange change, const ItemChangeData & value)
{
    if (change == QQuickItem::ItemVisibleHasChanged && pWebView)
        ((UIWebView*)pWebView).hidden = !value.boolValue;
    QQuickItem::itemChange(change, value);
}


QSGNode* IOSWebView::updatePaintNode(QSGNode *pNode, UpdatePaintNodeData*)
{
    qmlRect = QRectF(absoluteQMLPosition(), QSizeF(width(), height()));
    emit updateWebViewSize();
    return pNode;
}

void IOSWebView::onUpdateWebViewSize()
{
    if (pWebView)
        ((UIWebView*)pWebView).frame = CGRectMake(qmlRect.x(), qmlRect.y(), qmlRect.width(), qmlRect.height());
}

void IOSWebView::onUrlChanged(QString newUrl)
{
    if (pWebView) {
        NSURL *url = [NSURL URLWithString:newUrl.toNSString()];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [(UIWebView*)pWebView loadRequest:requestObj];
    }
}


QPointF IOSWebView::absoluteQMLPosition() {
    QPointF p(0, 0);
    QQuickItem* pItem = this;
    while (pItem != NULL) { // absolute position relative to rootItem
        p += pItem->position();
        pItem = pItem->parentItem();
    }
    return p;
}
