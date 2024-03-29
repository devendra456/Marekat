import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/shimmer_helper.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/payment_repository.dart';

class RechargeWallet extends StatefulWidget {
  double amount;

  RechargeWallet({Key key, this.amount}) : super(key: key);

  @override
  _RechargeWalletState createState() => _RechargeWalletState();
}

class _RechargeWalletState extends State<RechargeWallet> {
  var _selected_payment_method = "";
  var _selected_payment_method_key = "";

  ScrollController _mainScrollController = ScrollController();
  var _paymentTypeList = [];
  bool _isInitial = true;

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
  }

  fetchList() async {
    var paymentTypeResponseList =
        await PaymentRepository().getPaymentResponseList(mode: "wallet");
    _paymentTypeList.addAll(paymentTypeResponseList);
    if (_paymentTypeList.length > 0) {
      _selected_payment_method = _paymentTypeList[0].payment_type;
      _selected_payment_method_key = _paymentTypeList[0].payment_type_key;
    }
    _isInitial = false;
    setState(() {});
  }

  reset() {
    _paymentTypeList.clear();
    _isInitial = true;
    _selected_payment_method = "";
    _selected_payment_method_key = "";
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  onPressRechargeWallet() {
    if (_selected_payment_method == "") {
      ToastComponent.showDialog(
        S.of(context).pleaseChooseOneOptionToPay,
      );
      return;
    }

    /*if (_selected_payment_method == "stripe_payment") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(
          S.of(context).nothingToPay,
        );
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StripeScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "paypal_payment") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(
          S.of(context).nothingToPay,
        );
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PaypalScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    } else if (_selected_payment_method == "razorpay") {
      if (widget.amount == 0.00) {
        ToastComponent.showDialog(
          S.of(context).nothingToPay,
        );
        return;
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RazorpayScreen(
          amount: widget.amount,
          payment_type: "wallet_payment",
          payment_method_key: _selected_payment_method_key,
        );
      }));
    }*/
  }

  onPaymentMethodItemTap(index) {
    if (_selected_payment_method != _paymentTypeList[index].payment_type) {
      setState(() {
        _selected_payment_method = _paymentTypeList[index].payment_type;
        _selected_payment_method_key = _paymentTypeList[index].payment_type_key;
      });
    }
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
                    ]),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        S.of(context).rechargeWallet,
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
                      child: FadeInImage.assetNetwork(
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
                S.of(context).rechargeWallet,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                onPressRechargeWallet();
              },
            )
          ],
        ),
      ),
    );
  }
}
