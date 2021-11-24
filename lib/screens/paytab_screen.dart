import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marekat/app_config.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/shared_value_helper.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/screens/order_list.dart';
import 'package:marekat/screens/wallet.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayTabScreen extends StatefulWidget {
  final int ownerId;
  final double amount;
  final String paymentType;
  final String paymentMethodKey;

  const PayTabScreen(
      {this.ownerId = 0,
      this.amount = 0.00,
      this.paymentType = "",
      this.paymentMethodKey = "",
      Key key})
      : super(key: key);

  @override
  _PayTabScreenState createState() => _PayTabScreenState();
}

class _PayTabScreenState extends State<PayTabScreen> {
  int _orderId = 0;

  WebViewController _webViewController;

  @override
  void initState() {
    print(
        "${AppConfig.BASE_URL}/paytabs?payment_type=${widget.paymentType}&order_id=$_orderId&amount=${widget.amount}&user_id=${user_id.$}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: FutureBuilder(
        future: _getUrl(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Something went Wrong",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          } else if (snapshot.hasData) {
            http.Response res = snapshot.data;
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: WebView(
                debuggingEnabled: true,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: res.body.toString(),
                onWebResourceError: (error) {
                  print(error);
                },
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
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
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
        if (widget.paymentType == "cart_payment") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OrderList(from_checkout: true);
          }));
        } else if (widget.paymentType == "wallet_payment") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Wallet(from_recharge: true);
          }));
        }
      }
    });
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
        S.of(context).payWithPaytab,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Future<http.Response> _getUrl() async {
    try {
      final res = await http.post(
          Uri.parse(
            "${AppConfig.BASE_URL}/paytabs?payment_type=${widget.paymentType}&order_id=$_orderId&amount=${widget.amount}&user_id=${user_id.$}",
          ),
          headers: {"Authorization": "Bearer ${access_token.$}"});

      /*  if (await canLaunch(res.body.toString())) {
        await launch(res.body.toString());
      }*/
      return res;
    } catch (e) {
      return Future.error(e);
    }
  }
}
