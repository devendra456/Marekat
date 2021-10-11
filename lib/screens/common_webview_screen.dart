import 'package:Daemmart/custom/toast_component.dart';
import 'package:Daemmart/my_theme.dart';
import 'package:Daemmart/ui_sections/loader.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebviewScreen extends StatefulWidget {
  String url;
  String page_name;

  CommonWebviewScreen({Key key, this.url = "", this.page_name = ""})
      : super(key: key);

  @override
  _CommonWebviewScreenState createState() => _CommonWebviewScreenState();
}

class _CommonWebviewScreenState extends State<CommonWebviewScreen> {
  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  buildBody() {
    return SizedBox.expand(
      child: Container(
        child: WebView(
          debuggingEnabled: false,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            Loader.showLoaderDialog(context);
            _webViewController = controller;
            _webViewController.loadUrl(widget.url).whenComplete(() {
              Loader.dismissDialog(context);
            }).onError((error, stackTrace) {
              Loader.dismissDialog(context);
              ToastComponent.showDialog(error);
            });
          },
          onWebResourceError: (error) {
            Loader.dismissDialog(context);
            ToastComponent.showDialog(error.toString());
          },
          onPageFinished: (page) {
            Loader.dismissDialog(context);
            //ToastComponent.showDialog(page);
          },
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.accent_color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "${widget.page_name}",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
