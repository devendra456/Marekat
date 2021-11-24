import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marekat/app_config.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/shared_value_helper.dart';
import 'package:marekat/helpers/shimmer_helper.dart';
import 'package:marekat/helpers/string_helper.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/cart_repository.dart';
import 'package:marekat/screens/main_screen.dart';
import 'package:marekat/screens/shipping_info.dart';
import 'package:marekat/ui_sections/main_drawer.dart';

import 'login.dart';

class Cart extends StatefulWidget {
  Cart({Key key, this.has_bottomnav}) : super(key: key);
  final bool has_bottomnav;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _mainScrollController = ScrollController();
  var _chosenOwnerId = 0;
  var _shopList = [];
  bool _isInitial = true;
  var _cartTotal = 0.00;
  var _cartTotalString = ". . .";

  @override
  void initState() {
    super.initState();
    if (is_logged_in.$ == true) {
      fetchData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  fetchData() async {
    var cartResponseList =
        await CartRepository().getCartResponseList(user_id.$);

    if (cartResponseList != null && cartResponseList.length > 0) {
      _shopList = cartResponseList;
      _chosenOwnerId = cartResponseList[0].owner_id;
    }
    _isInitial = false;
    getSetCartTotal();
    setState(() {});
  }

  getSetCartTotal() {
    _cartTotal = 0.00;
    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cart_items.length > 0) {
          shop.cart_items.forEach((cart_item) {
            _cartTotal +=
                (cart_item.price + cart_item.tax) * cart_item.quantity;
            _cartTotalString = "${cart_item.currency_symbol} " +
                StringHelper.getRealPrice(_cartTotal.toString());
          });
        }
      });
    }

    setState(() {});
  }

  partialTotalString(index) {
    var partialTotal = 0.00;
    var partialTotalString = "";
    if (_shopList[index].cart_items.length > 0) {
      _shopList[index].cart_items.forEach((cart_item) {
        partialTotal += (cart_item.price + cart_item.tax) * cart_item.quantity;
        partialTotalString = "${cart_item.currency_symbol} " +
            StringHelper.getRealPrice(partialTotal.toString());
        //partialTotalString = StringHelper.getRealPrice(partialTotalString);
      });
    }

    return partialTotalString;
  }

  onQuantityIncrease(seller_index, item_index) {
    if (_shopList[seller_index].cart_items[item_index].quantity <
        _shopList[seller_index].cart_items[item_index].upper_limit) {
      _shopList[seller_index].cart_items[item_index].quantity++;
      getSetCartTotal();
      setState(() {});
    } else {
      ToastComponent.showDialog(S.of(context).cannotOrderMoreThan +
          _shopList[seller_index].cart_items[item_index].upper_limit +
          S.of(context).itemsOfThis);
    }
  }

  onQuantityDecrease(seller_index, item_index) {
    if (_shopList[seller_index].cart_items[item_index].quantity >
        _shopList[seller_index].cart_items[item_index].lower_limit) {
      _shopList[seller_index].cart_items[item_index].quantity--;
      getSetCartTotal();
      setState(() {});
    } else {
      onPressDelete(_shopList[seller_index].cart_items[item_index].id);
    }
  }

  onPressDelete(cart_id) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  S.of(context).areYouSureToRemoveThisItem,
                  maxLines: 3,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
                ),
              ),
              actions: [
                MaterialButton(
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(color: MyTheme.medium_grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                MaterialButton(
                  color: MyTheme.soft_accent_color,
                  child: Text(
                    S.of(context).confirm,
                    style: TextStyle(color: MyTheme.dark_grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    confirmDelete(cart_id);
                  },
                ),
              ],
            ));
  }

  confirmDelete(cart_id) async {
    var cartDeleteResponse =
        await CartRepository().getCartDeleteResponse(cart_id);

    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(cartDeleteResponse.message);

      reset();
      fetchData();
    } else {
      ToastComponent.showDialog(cartDeleteResponse.message);
    }
  }

  onPressUpdate() {
    process(mode: "update");
  }

  onPressProceedToShipping() {
    process(mode: "proceed_to_shipping");
  }

  process({mode}) async {
    var cart_ids = [];
    var cart_quantities = [];
    if (_shopList.length > 0) {
      _shopList.forEach((shop) {
        if (shop.cart_items.length > 0) {
          shop.cart_items.forEach((cart_item) {
            cart_ids.add(cart_item.id);
            cart_quantities.add(cart_item.quantity);
          });
        }
      });
    }

    if (cart_ids.length == 0) {
      ToastComponent.showDialog(S.of(context).cartIsEmpty);
      return;
    }

    var cart_ids_string = cart_ids.join(',').toString();
    var cart_quantities_string = cart_quantities.join(',').toString();

    print(cart_ids_string);
    print(cart_quantities_string);

    var cartProcessResponse = await CartRepository()
        .getCartProcessResponse(cart_ids_string, cart_quantities_string);

    if (cartProcessResponse.result == false) {
      ToastComponent.showDialog(cartProcessResponse.message);
    } else {
      ToastComponent.showDialog(cartProcessResponse.message);

      if (mode == "update") {
        reset();
        fetchData();
      } else if (mode == "proceed_to_shipping") {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ShippingInfo(
            owner_id: _chosenOwnerId,
          );
        })).then((value) {
          onPopped(value);
        });
      }
    }
  }

  reset() {
    _chosenOwnerId = 0;
    _shopList = [];
    _isInitial = true;
    _cartTotal = 0.00;
    _cartTotalString = ". . .";

    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  onPopped(value) async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
    //print(widget.has_bottomnav);
    return Scaffold(
        key: _scaffoldKey,
        drawer: widget.has_bottomnav ? MainDrawer() : null,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(context),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 100, bottom: 20),
              child: Image(
                image: AssetImage("assets/foreground.png"),
                colorBlendMode: BlendMode.modulate,
                color: const Color.fromRGBO(255, 255, 255, 0.5),
              ),
            ),
            buildCartSellerList(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: isRTL
                    ? const EdgeInsets.only(bottom: 8.0)
                    : const EdgeInsets.only(bottom: 0.0),
                child: is_logged_in.$ == false || _shopList.length == 0
                    ? Container()
                    : buildBottomContainer(),
              ),
            )
          ],
        ));
  }

  Container buildBottomContainer() {
    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        /*border: Border(
                  top: BorderSide(color: MyTheme.light_grey,width: 1.0),
                )*/
      ),

      height: widget.has_bottomnav ? 180 : 120,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Text(
                        S.of(context).totalAmount,
                        style: TextStyle(
                            color: Color.fromARGB(255, 59, 59, 59),
                            fontSize: 14),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 16),
                      child: Text("$_cartTotalString",
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 32) * (2 / 5),
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: MyTheme.textfield_grey, width: 1),
                        borderRadius: isRTL
                            ? const BorderRadius.only(
                                topLeft: const Radius.circular(0.0),
                                bottomLeft: const Radius.circular(0.0),
                                topRight: const Radius.circular(8.0),
                                bottomRight: const Radius.circular(8.0),
                              )
                            : const BorderRadius.only(
                                topLeft: const Radius.circular(8.0),
                                bottomLeft: const Radius.circular(8.0),
                                topRight: const Radius.circular(0.0),
                                bottomRight: const Radius.circular(0.0),
                              )),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 40,
                      color: MyTheme.light_grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: isRTL
                              ? const BorderRadius.only(
                                  topLeft: const Radius.circular(0.0),
                                  bottomLeft: const Radius.circular(0.0),
                                  topRight: const Radius.circular(8.0),
                                  bottomRight: const Radius.circular(8.0),
                                )
                              : const BorderRadius.only(
                                  topLeft: const Radius.circular(8.0),
                                  bottomLeft: const Radius.circular(8.0),
                                  topRight: const Radius.circular(0.0),
                                  bottomRight: const Radius.circular(0.0),
                                )),
                      child: Text(
                        S.of(context).updateCart,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: MyTheme.medium_grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        onPressUpdate();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 32) * (3 / 5),
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: isRTL
                            ? const BorderRadius.only(
                                topLeft: const Radius.circular(8.0),
                                bottomLeft: const Radius.circular(8.0),
                                topRight: const Radius.circular(0.0),
                                bottomRight: const Radius.circular(0.0),
                              )
                            : const BorderRadius.only(
                                topLeft: const Radius.circular(0.0),
                                bottomLeft: const Radius.circular(0.0),
                                topRight: const Radius.circular(8.0),
                                bottomRight: const Radius.circular(8.0),
                              )),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 40,
                      color: MyTheme.accent_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: isRTL
                              ? const BorderRadius.only(
                                  topLeft: const Radius.circular(8.0),
                                  bottomLeft: const Radius.circular(8.0),
                                  topRight: const Radius.circular(0.0),
                                  bottomRight: const Radius.circular(0.0),
                                )
                              : const BorderRadius.only(
                                  topLeft: const Radius.circular(0.0),
                                  bottomLeft: const Radius.circular(0.0),
                                  topRight: const Radius.circular(8.0),
                                  bottomRight: const Radius.circular(8.0),
                                )),
                      child: Text(
                        S.of(context).proceedToShipping,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        onPressProceedToShipping();
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: widget.has_bottomnav
          ? GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.openDrawer();
              },
              child: Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 0.0),
                  child: Container(
                    child: Image.asset(
                      'assets/hamburger.png',
                      height: 16,
                      color: MyTheme.accent_color,
                    ),
                  ),
                ),
              ),
            )
          : Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.arrow_back, color: MyTheme.accent_color),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
      title: Text(
        S.of(context).shoppingCart,
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  void _handleSellerRadioValueChange(value) {
    setState(() {
      _chosenOwnerId = value;
    });
  }

  buildCartSellerList() {
    if (is_logged_in.$ == false) {
      return Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .4,
                  width: MediaQuery.of(context).size.width * .5,
                  child: SvgPicture.asset("assets/empty_cart.svg"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    S.of(context).pleaseLogInToSeeTheCartItems,
                    style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: MaterialButton(
                    color: MyTheme.accent_color,
                    textColor: MyTheme.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Login();
                          },
                        ),
                      );
                    },
                    child: Text(S.of(context).login),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else if (_isInitial && _shopList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shopList.length > 0) {
      return RefreshIndicator(
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
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        itemCount: _shopList.length,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 0.0, top: 16.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: SizedBox(
                                          height: 36,
                                          width: 36,
                                          child: Transform.scale(
                                            scale: .75,
                                            child: Radio(
                                              value: _shopList[index].owner_id,
                                              groupValue: _chosenOwnerId,
                                              activeColor: MyTheme.accent_color,
                                              onChanged:
                                                  _handleSellerRadioValueChange,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        //_shopList[index].name,
                                        "Marekat",
                                        style:
                                            TextStyle(color: MyTheme.font_grey),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          partialTotalString(index),
                                          style: TextStyle(
                                              color: MyTheme.accent_color,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                buildCartSellerItemList(index),
                              ],
                            ),
                          );
                        },
                      ),
                    )),
                Container(
                  height: widget.has_bottomnav ? 140 : 100,
                )
              ]),
            )
          ],
        ),
      );
    } else if (!_isInitial && _shopList.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 0.0, bottom: 60),
        child: Container(
          height: double.infinity,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .4,
                  child: SvgPicture.asset("assets/empty_cart.svg"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    S.of(context).yourCartIsEmptyAddItemsInYourCart,
                    style: TextStyle(color: MyTheme.font_grey),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (dialogContex) => MainScreen()),
                            ModalRoute.withName("/Main"));
                      },
                      child: Text(S.of(context).addNow),
                      color: MyTheme.accent_color,
                      textColor: MyTheme.white,
                    ))
              ],
            ),
          ),
        ),
      );
    }
  }

  SingleChildScrollView buildCartSellerItemList(seller_index) {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: _shopList[seller_index].cart_items.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: buildCartSellerItemCard(seller_index, index),
          );
        },
      ),
    );
  }

  buildCartSellerItemCard(seller_index, item_index) {
    return Card(
      shape: RoundedRectangleBorder(
        //side: BorderSide(color: MyTheme.light_grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
            width: 100,
            height: 100,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: AppConfig.BASE_PATH +
                      _shopList[seller_index]
                          .cart_items[item_index]
                          .product_thumbnail_image,
                  fit: BoxFit.fitWidth,
                  imageErrorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Image.asset(
                      "assets/placeholder.png",
                      fit: BoxFit.cover,
                    );
                  },
                ))),
        Container(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _shopList[seller_index]
                          .cart_items[item_index]
                          .product_name,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w400),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _shopList[seller_index]
                                    .cart_items[item_index]
                                    .currency_symbol +
                                " " +
                                StringHelper.getRealPrice(
                                    (_shopList[seller_index]
                                                .cart_items[item_index]
                                                .price *
                                            _shopList[seller_index]
                                                .cart_items[item_index]
                                                .quantity)
                                        .toString()),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: MaterialButton(
                  padding: EdgeInsets.all(0),
                  child: Icon(
                    Icons.add,
                    color: MyTheme.accent_color,
                    size: 18,
                  ),
                  shape: CircleBorder(
                    side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    onQuantityIncrease(seller_index, item_index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  _shopList[seller_index]
                      .cart_items[item_index]
                      .quantity
                      .toString(),
                  style: TextStyle(color: MyTheme.accent_color, fontSize: 16),
                ),
              ),
              SizedBox(
                width: 28,
                height: 28,
                child: MaterialButton(
                  padding: EdgeInsets.all(0),
                  child: Icon(
                    Icons.remove,
                    color: MyTheme.accent_color,
                    size: 18,
                  ),
                  height: 30,
                  shape: CircleBorder(
                    side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    onQuantityDecrease(seller_index, item_index);
                  },
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
