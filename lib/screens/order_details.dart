import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/shared_value_helper.dart';
import 'package:marekat/helpers/shimmer_helper.dart';
import 'package:marekat/repositories/order_repository.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../addon_config.dart';
import '../my_theme.dart';

class OrderDetails extends StatefulWidget {
  int id;

  OrderDetails({Key key, this.id}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  ScrollController _mainScrollController = ScrollController();
  var _steps = ['pending', 'confirmed', 'picked_up', 'on_the_way', 'delivered'];

  //init
  int _stepIndex = 0;
  var _orderDetails = null;
  List<dynamic> _orderedItemList = [];
  bool _orderItemsInit = false;

  @override
  void initState() {
    fetchAll();
    super.initState();

    print(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchAll() {
    fetchOrderDetails();
    fetchOrderedItems();
  }

  fetchOrderDetails() async {
    var orderDetailsResponse =
        await OrderRepository().getOrderDetails(id: widget.id);

    if (orderDetailsResponse.detailed_orders.length > 0) {
      _orderDetails = orderDetailsResponse.detailed_orders[0];
      setStepIndex(_orderDetails.delivery_status);
    }

    setState(() {});
  }

  setStepIndex(key) {
    _stepIndex = _steps.indexOf(key);
    setState(() {});
  }

  fetchOrderedItems() async {
    var orderItemResponse =
        await OrderRepository().getOrderItems(id: widget.id);
    _orderedItemList.addAll(orderItemResponse.ordered_items);
    _orderItemsInit = true;

    setState(() {});
  }

  reset() {
    _stepIndex = 0;
    _orderDetails = null;
    _orderedItemList.clear();
    _orderItemsInit = false;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        onRefresh: _onPageRefresh,
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _orderDetails != null
                      ? buildTimeLineTiles()
                      : buildTimeLineShimmer()),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _orderDetails != null
                    ? buildOrderDetailsTopCard()
                    : ShimmerHelper().buildBasicShimmer(height: 150.0),
              ),
            ])),
            SliverList(
                delegate: SliverChildListDelegate([
              Center(
                child: Text(
                  S.of(context).orderedProduct,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _orderedItemList.length == 0 && _orderItemsInit
                      ? ShimmerHelper().buildBasicShimmer(height: 100.0)
                      : (_orderedItemList.length > 0
                          ? buildOrderdProductList()
                          : Container(
                              height: 100,
                              child: Text(
                                S.of(context).noItemsAreOrdered,
                                style: TextStyle(color: MyTheme.font_grey),
                              ),
                            )))
            ])),
            SliverList(
                delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 75,
                    ),
                    buildBottomSection()
                  ],
                ),
              )
            ]))
          ],
        ),
      ),
    );
  }

  buildBottomSection() {
    return Expanded(
      child: _orderDetails != null
          ? Column(
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
                          _orderDetails.subtotal,
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
                          _orderDetails.tax,
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
                          _orderDetails.shipping_cost,
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
                          _orderDetails.coupon_discount,
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
                          _orderDetails.grand_total,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            )
          : ShimmerHelper().buildBasicShimmer(height: 100.0),
    );
  }

  buildTimeLineShimmer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 20, width: 250.0),
        )
      ],
    );
  }

  buildTimeLineTiles() {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TimelineTile(
            axis: TimelineAxis.horizontal,
            alignment: TimelineAlign.end,
            isFirst: langCode.$ == 'en' ? true : false,
            startChild: Container(
              width: (MediaQuery.of(context).size.width - 32) / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.redAccent, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.list_alt,
                      color: Colors.redAccent,
                      size: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      S.of(context).orderPlaced,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 0 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 0
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            afterLineStyle: langCode.$ == 'en'
                ? (_stepIndex >= 1
                    ? LineStyle(
                        color: Colors.green,
                        thickness: 5,
                      )
                    : LineStyle(
                        color: MyTheme.medium_grey,
                        thickness: 4,
                      ))
                : LineStyle(color: MyTheme.white),
            beforeLineStyle: langCode.$ == 'ar'
                ? (_stepIndex >= 1
                    ? LineStyle(
                        color: Colors.green,
                        thickness: 5,
                      )
                    : LineStyle(
                        color: MyTheme.medium_grey,
                        thickness: 4,
                      ))
                : LineStyle(color: MyTheme.white),
          ),
          TimelineTile(
            axis: TimelineAxis.horizontal,
            alignment: TimelineAlign.end,
            startChild: Container(
              width: (MediaQuery.of(context).size.width - 32) / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.thumb_up_sharp,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      S.of(context).confirmed,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 1 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 1
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: langCode.$ == "en"
                ? (_stepIndex >= 1
                    ? LineStyle(
                        color: Colors.green,
                        thickness: 5,
                      )
                    : LineStyle(
                        color: MyTheme.medium_grey,
                        thickness: 4,
                      ))
                : (_stepIndex >= 2
                    ? LineStyle(
                        color: Colors.green,
                        thickness: 5,
                      )
                    : LineStyle(
                        color: MyTheme.medium_grey,
                        thickness: 4,
                      )),
            afterLineStyle: langCode.$ == "en"
                ? (_stepIndex >= 2
                    ? LineStyle(
                        color: Colors.green,
                        thickness: 5,
                      )
                    : LineStyle(
                        color: MyTheme.medium_grey,
                        thickness: 4,
                      ))
                : (_stepIndex >= 1
                    ? LineStyle(
                        color: Colors.green,
                        thickness: 5,
                      )
                    : LineStyle(
                        color: MyTheme.medium_grey,
                        thickness: 4,
                      )),
          ),
          TimelineTile(
            axis: TimelineAxis.horizontal,
            alignment: TimelineAlign.end,
            startChild: Container(
              width: (MediaQuery.of(context).size.width - 32) / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.amber, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.amber,
                      size: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      S.of(context).onDelivery,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 2 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 2
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: langCode.$ == "en"
                ? (_stepIndex >= 2
                    ? LineStyle(
                        color: Colors.green,
                        thickness: 5,
                      )
                    : LineStyle(
                        color: MyTheme.medium_grey,
                        thickness: 4,
                      ))
                : (_stepIndex >= 3
                    ? LineStyle(
                        color: Colors.green,
                        thickness: 5,
                      )
                    : LineStyle(
                        color: MyTheme.medium_grey,
                        thickness: 4,
                      )),
            afterLineStyle: langCode.$ == "en"
                ? (_stepIndex >= 3
                    ? LineStyle(
                        color: Colors.green,
                        thickness: 5,
                      )
                    : LineStyle(
                        color: MyTheme.medium_grey,
                        thickness: 4,
                      ))
                : (_stepIndex >= 2
                    ? LineStyle(
                        color: Colors.green,
                        thickness: 5,
                      )
                    : LineStyle(
                        color: MyTheme.medium_grey,
                        thickness: 4,
                      )),
          ),
          TimelineTile(
            axis: TimelineAxis.horizontal,
            alignment: TimelineAlign.end,
            isLast: langCode.$ == 'en' ? true : false,
            startChild: Container(
              width: (MediaQuery.of(context).size.width - 32) / 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.purple, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.done_all,
                      color: Colors.purple,
                      size: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      S.of(context).delivered,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey),
                    ),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 4 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.all(0),
              iconStyle: _stepIndex >= 4
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: langCode.$ == "en"
                ? (_stepIndex >= 4
                    ? LineStyle(
                        color: Colors.green,
                        thickness: 5,
                      )
                    : LineStyle(
                        color: MyTheme.medium_grey,
                        thickness: 4,
                      ))
                : LineStyle(color: MyTheme.white),
            afterLineStyle: langCode.$ == "ar"
                ? (_stepIndex >= 4
                    ? LineStyle(
                        color: Colors.green,
                        thickness: 5,
                      )
                    : LineStyle(
                        color: MyTheme.medium_grey,
                        thickness: 4,
                      ))
                : LineStyle(color: MyTheme.white),
          ),
        ],
      ),
    );
  }

  Card buildOrderDetailsTopCard() {
    return Card(
      shape: RoundedRectangleBorder(
        //side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  S.of(context).orderCode,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  S.of(context).shippingMethod,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderDetails.code,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails.shipping_type_string,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  S.of(context).orderDate,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  S.of(context).paymentMethod,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderDetails.date,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails.payment_type,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  S.of(context).paymentStatus,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  S.of(context).deliveryStatus,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      _orderDetails.payment_status_string,
                      style: TextStyle(
                        color: MyTheme.grey_153,
                      ),
                    ),
                  ),
                  buildPaymentStatusCheckContainer(
                      _orderDetails.payment_status),
                  Spacer(),
                  Text(
                    _orderDetails.delivery_status_string,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  S.of(context).shippingAddress,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  S.of(context).totalAmount,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _orderDetails.shipping_address.name != null
                            ? Text(
                                S.of(context).name +
                                    ": " +
                                    _orderDetails.shipping_address.name,
                                maxLines: 1,
                                style: TextStyle(
                                  color: MyTheme.grey_153,
                                ),
                              )
                            : Container(),
                        _orderDetails.shipping_address.email != null
                            ? Text(
                                S.of(context).email +
                                    ": " +
                                    _orderDetails.shipping_address.email,
                                maxLines: 3,
                                style: TextStyle(
                                  color: MyTheme.grey_153,
                                ),
                              )
                            : Container(),
                        Text(
                          S.of(context).address +
                              ": " +
                              _orderDetails.shipping_address.address,
                          maxLines: 2,
                          style: TextStyle(
                            color: MyTheme.grey_153,
                          ),
                        ),
                        Text(
                          S.of(context).city +
                              ": " +
                              _orderDetails.shipping_address.city,
                          maxLines: 1,
                          style: TextStyle(
                            color: MyTheme.grey_153,
                          ),
                        ),
                        Text(
                          S.of(context).country +
                              ": " +
                              _orderDetails.shipping_address.country,
                          maxLines: 1,
                          style: TextStyle(
                            color: MyTheme.grey_153,
                          ),
                        ),
                        Text(
                          S.of(context).phone +
                              ": " +
                              _orderDetails.shipping_address.phone,
                          maxLines: 1,
                          style: TextStyle(
                            color: MyTheme.grey_153,
                          ),
                        ),
                        Text(
                          S.of(context).postalCode +
                              ": " +
                              _orderDetails.shipping_address.postal_code,
                          maxLines: 1,
                          style: TextStyle(
                            color: MyTheme.grey_153,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Column(
                    children: [
                      Text(
                        _orderDetails.grand_total,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      _orderDetails.delivery_status == "delivered"
                          ? SizedBox()
                          : (_orderDetails.cancel_status < 2
                              ? MaterialButton(
                                  onPressed: () {
                                    _orderDetails.cancel_status == 0
                                        ? _showConfirmationDialog()
                                        : null;
                                  },
                                  child: Text(_orderDetails.cancel_status == 0
                                      ? "Order Cancel"
                                      : "Cancel Requested"),
                                  color: Colors.red,
                                  textColor: MyTheme.white,
                                )
                              : SizedBox())
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildOrderedProductItemsCard(index) {
    return Card(
      shape: RoundedRectangleBorder(
        //side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _orderedItemList[index].product_name,
                maxLines: 2,
                style: TextStyle(
                  color: MyTheme.font_grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderedItemList[index].quantity.toString() + " x ",
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  _orderedItemList[index].variation != "" &&
                          _orderedItemList[index].variation != null
                      ? Text(
                          _orderedItemList[index].variation,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          S.of(context).item,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                  Spacer(),
                  Text(
                    _orderedItemList[index].price,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            AddonConfig.refund_addon_installed
                ? InkWell(
                    onTap: () {
                      ToastComponent.showDialog(
                        S.of(context).comingSoon,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            S.of(context).askForRefund,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Icon(
                              FontAwesome.rotate_left,
                              color: MyTheme.accent_color,
                              size: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  buildOrderdProductList() {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: _orderedItemList.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: buildOrderedProductItemsCard(index),
          );
        },
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
        S.of(context).orderDetails,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Container buildPaymentStatusCheckContainer(String payment_status) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: payment_status == "paid" ? Colors.green : Colors.red),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(
            payment_status == "paid" ? FontAwesome.check : FontAwesome.times,
            color: Colors.white,
            size: 10),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 0),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                //Icon(Icons.logout),
                Text(S.of(context).areYouSureToCancel),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).confirm),
              onPressed: () async {
                _orderCancel(context);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _orderCancel(BuildContext context) async {
    final response = await OrderRepository().cancelOrder(widget.id);
    print(response.body);
    if (response.statusCode == HttpStatus.ok) {
      final json = jsonDecode(response.body);
      if (json["result"]) {
        ToastComponent.showDialog(json["message"]);
      }
    } else {
      ToastComponent.showDialog(S.of(context).somethingWentWrong);
    }
    await _onPageRefresh();
    setState(() {});
  }
}
