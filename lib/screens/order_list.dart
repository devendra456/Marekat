import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marekat/custom/data_not_found.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/shared_value_helper.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/order_repository.dart';
import 'package:marekat/screens/main_screen.dart';
import 'package:marekat/screens/order_details.dart';
import 'package:shimmer/shimmer.dart';

class PaymentStatus {
  String option_key;
  String name;

  PaymentStatus(this.option_key, this.name);

  static List<PaymentStatus> getPaymentStatusList() {
    return <PaymentStatus>[
      PaymentStatus('', langCode.$ == "en" ? 'All' : "الجميع"),
      PaymentStatus('paid', langCode.$ == "en" ? 'Paid' : "مدفوع"),
      PaymentStatus('unpaid', langCode.$ == "en" ? 'Unpaid' : "غير مدفوعة"),
    ];
  }
}

class DeliveryStatus {
  String option_key;
  String name;

  DeliveryStatus(this.option_key, this.name);

  static List<DeliveryStatus> getDeliveryStatusList() {
    return <DeliveryStatus>[
      DeliveryStatus('', langCode.$ == "en" ? 'All' : "الجميع"),
      DeliveryStatus('confirmed', langCode.$ == "en" ? 'Confirmed' : "مؤكد"),
      DeliveryStatus(
          'on_delivery', langCode.$ == "en" ? 'On Delivery' : "عند التسليم"),
      DeliveryStatus(
          'delivered', langCode.$ == "en" ? 'Delivered' : "تم التوصيل"),
    ];
  }
}

class OrderList extends StatefulWidget {
  OrderList({Key key, this.from_checkout = false}) : super(key: key);
  final bool from_checkout;

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();

  List<PaymentStatus> _paymentStatusList = PaymentStatus.getPaymentStatusList();
  List<DeliveryStatus> _deliveryStatusList =
      DeliveryStatus.getDeliveryStatusList();

  PaymentStatus _selectedPaymentStatus;
  DeliveryStatus _selectedDeliveryStatus;

  List<DropdownMenuItem<PaymentStatus>> _dropdownPaymentStatusItems;
  List<DropdownMenuItem<DeliveryStatus>> _dropdownDeliveryStatusItems;

  int _user_id;

  //------------------------------------
  List<dynamic> _orderList = [];
  bool _isInitial = true;
  int _page = 1;
  int _totalData = 0;
  bool _showLoadingContainer = false;
  String _defaultPaymentStatusKey = '';
  String _defaultDeliveryStatusKey = '';

  @override
  void initState() {
    _user_id = user_id.$;

    init();
    super.initState();

    fetchData();

    _xcrollController.addListener(() {
      if (_xcrollController.position.pixels ==
          _xcrollController.position.maxScrollExtent) {
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _xcrollController.dispose();
    super.dispose();
  }

  init() {
    _dropdownPaymentStatusItems =
        buildDropdownPaymentStatusItems(_paymentStatusList);

    _dropdownDeliveryStatusItems =
        buildDropdownDeliveryStatusItems(_deliveryStatusList);

    for (int x = 0; x < _dropdownPaymentStatusItems.length; x++) {
      if (_dropdownPaymentStatusItems[x].value.option_key ==
          _defaultPaymentStatusKey) {
        _selectedPaymentStatus = _dropdownPaymentStatusItems[x].value;
      }
    }

    for (int x = 0; x < _dropdownDeliveryStatusItems.length; x++) {
      if (_dropdownDeliveryStatusItems[x].value.option_key ==
          _defaultDeliveryStatusKey) {
        _selectedDeliveryStatus = _dropdownDeliveryStatusItems[x].value;
      }
    }
  }

  reset() {
    _orderList.clear();
    _isInitial = true;
    _page = 1;
    _totalData = 0;
    _showLoadingContainer = false;
  }

  resetFilterKeys() {
    _defaultPaymentStatusKey = '';
    _defaultDeliveryStatusKey = '';

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    resetFilterKeys();
    for (int x = 0; x < _dropdownPaymentStatusItems.length; x++) {
      if (_dropdownPaymentStatusItems[x].value.option_key ==
          _defaultPaymentStatusKey) {
        _selectedPaymentStatus = _dropdownPaymentStatusItems[x].value;
      }
    }

    for (int x = 0; x < _dropdownDeliveryStatusItems.length; x++) {
      if (_dropdownDeliveryStatusItems[x].value.option_key ==
          _defaultDeliveryStatusKey) {
        _selectedDeliveryStatus = _dropdownDeliveryStatusItems[x].value;
      }
    }
    setState(() {});
    fetchData();
  }

  fetchData() async {
    var orderResponse = await OrderRepository().getOrderList(
        user_id: _user_id,
        page: _page,
        payment_status: _selectedPaymentStatus.option_key,
        delivery_status: _selectedDeliveryStatus.option_key);
    _orderList.addAll(orderResponse.orders);
    _isInitial = false;
    _totalData = orderResponse.meta.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  List<DropdownMenuItem<PaymentStatus>> buildDropdownPaymentStatusItems(
      List _paymentStatusList) {
    List<DropdownMenuItem<PaymentStatus>> items = List();
    for (PaymentStatus item in _paymentStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<DeliveryStatus>> buildDropdownDeliveryStatusItems(
      List _deliveryStatusList) {
    List<DropdownMenuItem<DeliveryStatus>> items = List();
    for (DeliveryStatus item in _deliveryStatusList) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.name),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (widget.from_checkout) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MainScreen();
            }));
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: buildAppBar(context),
            body: Stack(
              children: [
                buildOrderListList(),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: buildLoadingContainer())
              ],
            )));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _orderList.length
            ? S.of(context).noMoreOrders
            : S.of(context).loadingMoreOrder),
      ),
    );
  }

  buildBottomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 36,
            width: MediaQuery.of(context).size.width * .33,
            child: new DropdownButton<PaymentStatus>(
              isExpanded: true,
              icon: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Icon(Icons.expand_more, color: Colors.black54),
              ),
              hint: Text(
                S.of(context).allPayments,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              iconSize: 14,
              underline: SizedBox(),
              value: _selectedPaymentStatus,
              items: _dropdownPaymentStatusItems,
              onChanged: (PaymentStatus selectedFilter) {
                setState(() {
                  _selectedPaymentStatus = selectedFilter;
                });
                reset();
                fetchData();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Icon(
              Icons.credit_card,
              color: MyTheme.font_grey,
              size: 16,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8),
            child: Icon(
              Icons.local_shipping_outlined,
              color: MyTheme.font_grey,
              size: 16,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 36,
            width: MediaQuery.of(context).size.width * .33,
            child: new DropdownButton<DeliveryStatus>(
              isExpanded: true,
              icon: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Icon(Icons.expand_more, color: Colors.black54),
              ),
              hint: Text(
                S.of(context).allDeliveries,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              iconSize: 14,
              underline: SizedBox(),
              value: _selectedDeliveryStatus,
              items: _dropdownDeliveryStatusItems,
              onChanged: (DeliveryStatus selectedFilter) {
                setState(() {
                  _selectedDeliveryStatus = selectedFilter;
                });
                reset();
                fetchData();
              },
            ),
          ),
        ],
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(104.0),
      child: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [
            new Container(),
          ],
          elevation: 0.0,
          titleSpacing: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: Column(
              children: [
                Padding(
                  padding: MediaQuery.of(context).viewPadding.top >
                          30 //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                      ? const EdgeInsets.only(top: 36.0)
                      : const EdgeInsets.only(top: 14.0),
                  child: buildTopAppBarContainer(),
                ),
                buildBottomAppBar(context)
              ],
            ),
          )),
    );
  }

  Container buildTopAppBarContainer() {
    return Container(
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.arrow_back, color: MyTheme.accent_color),
              onPressed: () {
                if (widget.from_checkout) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MainScreen();
                  }));
                } else {
                  return Navigator.of(context).pop();
                }
              },
            ),
          ),
          Text(
            S.of(context).purchaseHistory,
            style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
          ),
        ],
      ),
    );
  }

  buildOrderListList() {
    if (_isInitial && _orderList.length == 0) {
      return SingleChildScrollView(
          child: ListView.builder(
        controller: _scrollController,
        itemCount: 10,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Shimmer.fromColors(
              baseColor: MyTheme.shimmer_base,
              highlightColor: MyTheme.shimmer_highlighted,
              child: Container(
                height: 75,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
          );
        },
      ));
    } else if (_orderList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _xcrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: _orderList.length,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return OrderDetails(
                          id: _orderList[index].id,
                        );
                      }));
                    },
                    child: buildOrderListItemCard(index),
                  ));
            },
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(
          child: /*Text(S.of(context).noDataIsAvailable)
      */
              DataNotFound());
    } else {
      return Container(); // should never be happening
    }
  }

  Card buildOrderListItemCard(int index) {
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
                _orderList[index].code,
                style: TextStyle(
                    color: MyTheme.accent_color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: MyTheme.font_grey,
                    ),
                  ),
                  Text(_orderList[index].date,
                      style: TextStyle(color: MyTheme.font_grey, fontSize: 13)),
                  Spacer(),
                  Text(
                    _orderList[index].grand_total,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.credit_card,
                      size: 16,
                      color: MyTheme.font_grey,
                    ),
                  ),
                  Text(
                    S.of(context).paymentStatus,
                    style: TextStyle(color: MyTheme.font_grey, fontSize: 13),
                  ),
                  Text(
                    _orderList[index].payment_status_string,
                    style: TextStyle(color: MyTheme.font_grey, fontSize: 13),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: buildPaymentStatusCheckContainer(
                        _orderList[index].payment_status),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                  ),
                  child: Icon(
                    Icons.local_shipping_outlined,
                    size: 16,
                    color: MyTheme.font_grey,
                  ),
                ),
                Text(
                  S.of(context).deliveryStatus,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 13),
                ),
                Text(
                  _orderList[index].delivery_status_string,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 13),
                ),
              ],
            )
          ],
        ),
      ),
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
}
