import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
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
  String _instructions = 'Tap on "Pay" Button to try PayTabs plugin';
  @override
  void initState() {
    print(
        "${AppConfig.BASE_URL}/paytabs?payment_type=${widget.paymentType}&order_id=$_orderId&amount=${widget.amount}&user_id=${user_id.$}");
    super.initState();
  }

  Future<PaymentSdkConfigurationDetails> generateConfig() async {
    var billingDetails = BillingDetails("John Smith", "email@domain.com",
        "+97311111111", "st. 12", "ae", "dubai", "dubai", "12345");
    var shippingDetails = ShippingDetails("John Smith", "email@domain.com",
        "+97311111111", "st. 12", "ae", "dubai", "dubai", "12345");
    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.STC_PAY);
    var configuration = PaymentSdkConfigurationDetails(
        profileId: "*profile id*",
        serverKey: "*server key*",
        clientKey: "*client key*",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        screentTitle: "Pay with Card",
        amount: 20.0,
        showBillingInfo: true,
        forceShippingInfo: false,
        currencyCode: "SAR",
        merchantCountryCode: "SA",
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        alternativePaymentMethods: apms);

    var theme = IOSThemeConfigurations();

    theme.logoImage = "assets/logo.png";

    configuration.iOSThemeConfigurations = theme;

    return configuration;
  }

  Future<void> payPressed() async {
    FlutterPaytabsBridge.startCardPayment(await generateConfig(), (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Future<void> apmsPayPressed() async {
    FlutterPaytabsBridge.startAlternativePaymentMethod(await generateConfig(),
        (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Future<void> applePayPressed() async {
    var configuration = PaymentSdkConfigurationDetails(
        profileId: "*Profile id*",
        serverKey: "*server key*",
        clientKey: "*client key*",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        amount: 20.0,
        currencyCode: "AED",
        merchantCountryCode: "ae",
        merchantApplePayIndentifier: "merchant.com.bunldeId",
        simplifyApplePayValidation: true);
    FlutterPaytabsBridge.startApplePayPayment(configuration, (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Widget applePayButton() {
    return TextButton(
      onPressed: () {
        applePayPressed();
      },
      child: Text('Pay with Apple Pay'),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
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
                onWebViewCreated: (controller) {
                  Loader.showLoaderDialog(context);
                },
                onPageStarted: (value) {
                  Loader.dismissDialog(context);
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
              child: CircularProgressIndicator(
                color: MyTheme.accent_color,
              ),
            );
          }
        },
      ),
    );*/
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayTabs Plugin Example App'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Text('$_instructions'),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                payPressed();
              },
              child: Text('Pay with Card'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                apmsPayPressed();
              },
              child: Text('Pay with Alternative payment methods'),
            ),
            SizedBox(height: 16),
            applePayButton()
          ])),
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

      return res;
    } catch (e) {
      return Future.error(e);
    }
  }
}
