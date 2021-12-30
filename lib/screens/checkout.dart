import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkLocale.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/data_model/address_response.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/payment_gateway_helper.dart';
import 'package:marekat/helpers/shared_value_helper.dart';
import 'package:marekat/helpers/shimmer_helper.dart';
import 'package:marekat/helpers/string_helper.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/cart_repository.dart';
import 'package:marekat/repositories/coupon_repository.dart';
import 'package:marekat/repositories/payment_repository.dart';
import 'package:marekat/screens/order_list.dart';
import 'package:marekat/ui_sections/loader.dart';
import 'package:path_provider/path_provider.dart';

class Checkout extends StatefulWidget {
  int owner_id;
  final Address address;

  Checkout(
    this.address, {
    Key key,
    this.owner_id,
  }) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  var _selected_payment_method = "";
  var _selected_payment_method_key = "";

  ScrollController _mainScrollController = ScrollController();
  TextEditingController _couponController = TextEditingController();
  var _paymentTypeList = [];
  bool _isInitial = true;
  var _totalString = ". . .";
  var _grandTotalValue = 0.00;
  var _subTotalString = ". . .";
  var _taxString = ". . .";
  var _shippingCostString = ". . .";
  var _discountString = ". . .";
  var _used_coupon_code = "";
  var _coupon_applied = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchAll();
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchAll() {
    fetchList();

    if (is_logged_in.$ == true) {
      fetchSummary();
    }
  }

  fetchList() async {
    _paymentTypeList.clear();
    var paymentTypeResponseList =
        await PaymentRepository().getPaymentResponseList();
    _paymentTypeList.addAll(paymentTypeResponseList);
    if (_paymentTypeList.length > 0) {
      _selected_payment_method = _paymentTypeList[0].payment_type;
      _selected_payment_method_key = _paymentTypeList[0].payment_type_key;
    }
    _isInitial = false;
    setState(() {});
  }

  fetchSummary() async {
    //Loader.showLoaderDialog(context);
    var cartSummaryResponse;
    try {
      cartSummaryResponse =
          await CartRepository().getCartSummaryResponse(widget.owner_id);
      Loader.dismissDialog(context);
    } catch (e) {
      //Loader.dismissDialog(context);
    }

    if (cartSummaryResponse != null) {
      _subTotalString = cartSummaryResponse.sub_total;
      _taxString = cartSummaryResponse.tax;
      _shippingCostString = cartSummaryResponse.shipping_cost;
      _discountString = cartSummaryResponse.discount;
      _totalString = cartSummaryResponse.grand_total;
      _grandTotalValue = cartSummaryResponse.grand_total_value;
      _used_coupon_code = cartSummaryResponse.coupon_code;
      _couponController.text = _used_coupon_code;
      _coupon_applied = cartSummaryResponse.coupon_applied;
      setState(() {});
    }
  }

  reset() {
    _paymentTypeList.clear();
    _isInitial = true;
    _selected_payment_method = "";
    _selected_payment_method_key = "";
    setState(() {});

    reset_summary();
  }

  reset_summary() {
    _totalString = ". . .";
    _grandTotalValue = 0.00;
    _subTotalString = ". . .";
    _taxString = ". . .";
    _shippingCostString = ". . .";
    _discountString = ". . .";
    _used_coupon_code = "";
    _couponController.text = _used_coupon_code;
    _coupon_applied = false;

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  onPopped(value) {
    reset();
    fetchAll();
  }

  onCouponApply() async {
    var coupon_code = _couponController.text.toString();
    if (coupon_code == "") {
      ToastComponent.showDialog(
        S.of(context).enterCouponCode,
      );
      return;
    }

    var couponApplyResponse = await CouponRepository()
        .getCouponApplyResponse(widget.owner_id, coupon_code);
    if (couponApplyResponse.result == false) {
      ToastComponent.showDialog(
        couponApplyResponse.message,
      );
      return;
    }

    reset_summary();
    fetchSummary();
  }

  onCouponRemove() async {
    var couponRemoveResponse =
        await CouponRepository().getCouponRemoveResponse(widget.owner_id);

    if (couponRemoveResponse.result == false) {
      ToastComponent.showDialog(
        couponRemoveResponse.message,
      );
      return;
    }

    reset_summary();
    fetchSummary();
  }

  Future<PaymentSdkConfigurationDetails> generateConfig() async {
    var billingDetails = BillingDetails(
      user_name.$,
      user_email.$,
      widget.address.phone,
      widget.address.address,
      widget.address.country,
      widget.address.city,
      "",
      widget.address.postal_code,
    );
    var shippingDetails = ShippingDetails(
      user_name.$,
      user_email.$,
      widget.address.phone,
      widget.address.address,
      widget.address.country,
      widget.address.city,
      "",
      widget.address.postal_code,
    );
    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.STC_PAY);
    var configuration = PaymentSdkConfigurationDetails(
      profileId: PaymentGatewayHelper.profileId,
      serverKey: PaymentGatewayHelper.serverKey,
      clientKey: PaymentGatewayHelper.clientKey,
      cartId: widget.owner_id.toString(),
      cartDescription: "Cart description",
      merchantName: PaymentGatewayHelper.merchantName,
      screentTitle: "Pay with Card",
      amount:
          double.parse(StringHelper.getRealPrice(_grandTotalValue.toString())),
      showBillingInfo: true,
      showShippingInfo: true,
      forceShippingInfo: false,
      currencyCode: "SAR",
      merchantCountryCode: "SA",
      billingDetails: billingDetails,
      shippingDetails: shippingDetails,
      alternativePaymentMethods: apms,
      locale: langCode.$ == "ar" ? PaymentSdkLocale.AR : PaymentSdkLocale.EN,
    );

    var theme = IOSThemeConfigurations();
    if(Platform.isAndroid){
      theme.logoImage = "assets/logo.png";
      configuration.iOSThemeConfigurations = theme;
    }

    /*if(Platform.isIOS){
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      await PlatformAssetBundle().load('assets/logo.png').then((value) {
        theme.logoImage = value.toString();
        print(value);
      });
    }*/
    /*
    theme.logoImage = "assets/logo.png";
    configuration.iOSThemeConfigurations = theme;*/

    return configuration;
  }

  Future<void> payPressed() async {
    FlutterPaytabsBridge.startCardPayment(await generateConfig(), (event) {
      if (event["status"] == "success") {
        var transactionDetails = event["data"];
        print(transactionDetails);
        ToastComponent.showDialog("Payment Successful");
        paymentSuccessful();
      } else if (event["status"] == "error") {
        paymentError();
      } else if (event["status"] == "event") {
        print("errror");
      } else {
        print("elase");
      }
    });
  }

  onPressPlaceOrder() {
    if (_selected_payment_method == "") {
      ToastComponent.showDialog(
        S.of(context).pleaseChooseOneOptionToPay,
      );
      return;
    }

    if (_selected_payment_method == "paytab") {
      if (_grandTotalValue == 0.00) {
        ToastComponent.showDialog(
          S.of(context).nothingToPay,
        );
        return;
      }
      payPressed();
    } else if (_selected_payment_method == "wallet_system") {
      pay_by_wallet();
    } else if (_selected_payment_method == "cash_payment") {
      pay_by_cod();
    }
  }

  pay_by_wallet() async {
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromWallet(
            widget.owner_id, _selected_payment_method_key, _grandTotalValue);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message);
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderList(from_checkout: true);
    }));
  }

  pay_by_cod() async {
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromCod(
            widget.owner_id, _selected_payment_method_key);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message);
      Navigator.of(context).pop();
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return OrderList(from_checkout: true);
    }));
  }

  onPaymentMethodItemTap(index) {
    if (_selected_payment_method != _paymentTypeList[index].payment_type) {
      setState(() {
        _selected_payment_method = _paymentTypeList[index].payment_type;
        _selected_payment_method_key = _paymentTypeList[index].payment_type_key;
      });
    }
  }

  onPressDetails() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                child: Container(
                  height: 150,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                child: Text(
                                  S.of(context).subTotal,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: MyTheme.font_grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Spacer(),
                              Text(
                                _subTotalString,
                                style: TextStyle(
                                    color: MyTheme.font_grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                child: Text(
                                  S.of(context).tax,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: MyTheme.font_grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Spacer(),
                              Text(
                                _taxString,
                                style: TextStyle(
                                    color: MyTheme.font_grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                child: Text(
                                  S.of(context).shippingCost,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: MyTheme.font_grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Spacer(),
                              Text(
                                _shippingCostString,
                                style: TextStyle(
                                    color: MyTheme.font_grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                child: Text(
                                  S.of(context).discount,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: MyTheme.font_grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Spacer(),
                              Text(
                                _discountString,
                                style: TextStyle(
                                    color: MyTheme.font_grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                      Divider(),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                child: Text(
                                  S.of(context).grandTotal,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: MyTheme.font_grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Spacer(),
                              Text(
                                _totalString,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              actions: [
                MaterialButton(
                  child: Text(
                    S.of(context).close,
                    style: TextStyle(color: MyTheme.medium_grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        bottomNavigationBar: buildBottomAppBar(context),
        body: Stack(
          children: [
            RefreshIndicator(
              color: MyTheme.accent_color,
              backgroundColor: Colors.white,
              onRefresh: _onRefresh,
              displacement: 0,
              child: CustomScrollView(
                controller: _mainScrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: buildPaymentMethodList(),
                      ),
                      Container(
                        height: 140,
                      )
                    ]),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  /*border: Border(
                    top: BorderSide(color: MyTheme.light_grey,width: 1.0),
                  )*/
                ),
                height: 140,
                //color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: buildApplyCouponRow(context),
                      ),
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: MyTheme.soft_accent_color),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  S.of(context).totalAmount,
                                  style: TextStyle(
                                      color: MyTheme.font_grey, fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    onPressDetails();
                                  },
                                  child: Text(
                                    S.of(context).seeDetails,
                                    style: TextStyle(
                                      color: MyTheme.font_grey,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text(_totalString,
                                    style: TextStyle(
                                        color: MyTheme.accent_color,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Row buildApplyCouponRow(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 42,
          width: (MediaQuery.of(context).size.width - 32) * (2 / 3),
          child: TextFormField(
            controller: _couponController,
            readOnly: _coupon_applied,
            autofocus: false,
            decoration: InputDecoration(
                hintText: S.of(context).couponCode,
                hintStyle:
                    TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyTheme.textfield_grey, width: 0.5),
                  borderRadius: BorderRadius.only(
                    topLeft: langCode.$ == "en"
                        ? const Radius.circular(8.0)
                        : Radius.circular(0),
                    bottomLeft: langCode.$ == "en"
                        ? Radius.circular(8.0)
                        : Radius.circular(0),
                    topRight: langCode.$ == "ar"
                        ? Radius.circular(8.0)
                        : Radius.circular(0),
                    bottomRight: langCode.$ == "ar"
                        ? Radius.circular(8.0)
                        : Radius.circular(0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.medium_grey, width: 1),
                  borderRadius: BorderRadius.only(
                    topLeft: langCode.$ == "en"
                        ? const Radius.circular(8.0)
                        : Radius.circular(0),
                    bottomLeft: langCode.$ == "en"
                        ? Radius.circular(8.0)
                        : Radius.circular(0),
                    topRight: langCode.$ == "ar"
                        ? Radius.circular(8.0)
                        : Radius.circular(0),
                    bottomRight: langCode.$ == "ar"
                        ? Radius.circular(8.0)
                        : Radius.circular(0),
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 16.0, right: 16)),
          ),
        ),
        !_coupon_applied
            ? Container(
                width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
                height: 42,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  //height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topRight: langCode.$ == "en"
                        ? Radius.circular(8.0)
                        : Radius.circular(0),
                    bottomRight: langCode.$ == "en"
                        ? Radius.circular(8.0)
                        : Radius.circular(0),
                    topLeft: langCode.$ == "ar"
                        ? Radius.circular(8.0)
                        : Radius.circular(0),
                    bottomLeft: langCode.$ == "ar"
                        ? Radius.circular(8.0)
                        : Radius.circular(0),
                  )),
                  child: Text(
                    S.of(context).applyCoupon,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    onCouponApply();
                  },
                ),
              )
            : Container(
                width: (MediaQuery.of(context).size.width - 32) * (1 / 3),
                height: 42,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  //height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topRight: langCode.$ == "en"
                        ? Radius.circular(8.0)
                        : Radius.circular(0),
                    bottomRight: langCode.$ == "en"
                        ? Radius.circular(8.0)
                        : Radius.circular(0),
                  )),
                  child: Text(
                    S.of(context).remove,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    onCouponRemove();
                  },
                ),
              )
      ],
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
        S.of(context).checkout,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildPaymentMethodList() {
    if (_isInitial && _paymentTypeList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_paymentTypeList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _paymentTypeList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildPaymentMethodItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _paymentTypeList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            S.of(context).noPaymentMethodIsAdded,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  GestureDetector buildPaymentMethodItemCard(index) {
    return GestureDetector(
      onTap: () {
        onPaymentMethodItemTap(index);
      },
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              side: _selected_payment_method ==
                      _paymentTypeList[index].payment_type
                  ? BorderSide(color: MyTheme.accent_color, width: 2.0)
                  : BorderSide(color: MyTheme.light_grey, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                          /*Image.asset(
                          _paymentTypeList[index].image,
                          fit: BoxFit.fitWidth,
                        ),*/
                          FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: _paymentTypeList[index].image,
                        fit: BoxFit.fitWidth,
                        imageErrorBuilder: (BuildContext context,
                            Object exception, StackTrace stackTrace) {
                          return Image.asset(
                            "assets/placeholder.png",
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            _paymentTypeList[index].title,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: buildPaymentMethodCheckContainer(_selected_payment_method ==
                _paymentTypeList[index].payment_type),
          )
        ],
      ),
    );
  }

  Container buildPaymentMethodCheckContainer(bool check) {
    return check
        ? Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), color: Colors.green),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(FontAwesome.check, color: Colors.white, size: 10),
            ),
          )
        : Container();
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: MyTheme.accent_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Text(
                S.of(context).placeMyOrder,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                onPressPlaceOrder();
              },
            )
          ],
        ),
      ),
    );
  }

  void paymentSuccessful() async {
    var response;
    Loader.showLoaderDialog(context);
    try {
      response = await PaymentRepository()
          .getOrderCreateResponse(widget.owner_id, "Paytabs", "paid");
      Loader.dismissDialog(context);
    } catch (e) {
      Loader.dismissDialog(context);
    }

    if (response.result) {
      ToastComponent.showDialog(response.message);
      Navigator.push(context, MaterialPageRoute(builder: (builder) {
        return OrderList();
      })).then((value) => fetchAll());
    }
  }

  void paymentError() async {
    ToastComponent.showDialog("Something went wrong! Please try again.");
  }
}
