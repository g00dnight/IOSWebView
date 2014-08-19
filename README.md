What is it?
===========
The original idea was taken from qt-project.org [forum](http://qt-project.org/forums/viewthread/43920). This component uses native Apple UIWebView to draw a webpage in QML. You can change coordinates and size of the component as well as it's anchors.

How to use
==========
Just add `ioswebview.h` and `ioswebview.mm` files to your Qt project and don't forget to add this line to your `main.cpp`:
`qmlRegisterType<IOSWebView>("com.companyname", 1, 0, "IOSWebView");`
