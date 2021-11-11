import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marekat/app_config.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/shared_value_helper.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/payment_repository.dart';
import 'package:marekat/screens/order_list.dart';
import 'package:marekat/screens/wallet.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeScreen extends StatefulWidget {
  int owner_id;
  double amount;
  String payment_type;
  String payment_method_key;

  StripeScreen(
      {Key key,
      this.owner_id = 0,
      this.amount = 0.00,
      this.payment_type = "",
      this.payment_method_key = ""})
      : super(key: key);

  @override
  _StripeScreenState createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen> {
  int _order_id = 0;
  bool _order_init = false;

  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    if (widget.payment_type == "cart_payment") {
      createOrder();
    }
  }

  createOrder() async {
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponse(widget.owner_id, widget.payment_method_key);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message);
      Navigator.of(context).pop();
      return;
    }

    _order_id = orderCreateResponse.order_id;
    _order_init = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  void getData() {
    _webViewController
        .evaluateJavascript("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);

      if (responseJSON["result"] == false) {
        ToastComponent.showDialog(responseJSON["message"]);
        Navigator.pop(context);
      } else if (responseJSON["result"] == true) {
        ToastComponent.showDialog(responseJSON["message"]);
        if (widget.payment_type == "cart_payment") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OrderList(from_checkout: true);
          }));
        } else if (widget.payment_type == "wallet_payment") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Wallet(from_recharge: true);
          }));
        }
      }
    });
  }

  buildBody() {
    String initial_url =
        "${AppConfig.BASE_URL}/stripe?payment_type=${widget.payment_type}&order_id=${_order_id}&amount=${widget.amount}&user_id=${user_id.$}";

    if (_order_init == false &&
        _order_id == 0 &&
        widget.payment_type == "cart_payment") {
      return Container(
        child: Center(
          child: Text(S.of(context).creatingOrder),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebView(
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              _webViewController.loadUrl(initial_url);
            },
            onWebResourceError: (error) {},
            onPageFinished: (page) {
              if (page.contains("/stripe/success")) {
                getData();
              } else if (page.contains("/stripe/cancel")) {
                ToastComponent.showDialog(S.of(context).paymentCancelled);
                Navigator.of(context).pop();
                return;
              }
            },
          ),
        ),
      );
    }
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
        S.of(context).payWithStripe,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
