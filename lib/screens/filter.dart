import 'package:flutter/material.dart';
import 'package:marekat/custom/data_not_found.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/reg_ex_inpur_formatter.dart';
import 'package:marekat/helpers/shared_value_helper.dart';
import 'package:marekat/helpers/shimmer_helper.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/brand_repository.dart';
import 'package:marekat/repositories/category_repository.dart';
import 'package:marekat/repositories/product_repository.dart';
import 'package:marekat/repositories/shop_repository.dart';
import 'package:marekat/screens/seller_details.dart';
import 'package:marekat/ui_elements/brand_square_card.dart';
import 'package:marekat/ui_elements/product_card.dart';
import 'package:marekat/ui_elements/shop_square_card.dart';

class WhichFilter {
  String option_key;
  String name;

  WhichFilter(this.option_key, this.name);

  static List<WhichFilter> getWhichFilterList() {
    return <WhichFilter>[
      WhichFilter('product', langCode.$ == "en" ? "Products" : "منتجات"),
      WhichFilter('sellers', langCode.$ == "en" ? 'Sellers' : "الباعة"),
      WhichFilter(
          'brands', langCode.$ == "en" ? 'Brands' : "العلامات التجارية"),
    ];
  }
}

class Filter extends StatefulWidget {
  Filter({
    Key key,
    this.selected_filter = "product",
  }) : super(key: key);

  final String selected_filter;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final _amountValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  ScrollController _productScrollController = ScrollController();
  ScrollController _brandScrollController = ScrollController();
  ScrollController _shopScrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController _scrollController;
  WhichFilter _selectedFilter;
  String _givenSelectedFilterOptionKey; // may be it can come from another page
  var _selectedSort = "";
  List<WhichFilter> _which_filter_list = WhichFilter.getWhichFilterList();
  List<DropdownMenuItem<WhichFilter>> _dropdownWhichFilterItems;
  List<dynamic> _selectedCategories = [];
  List<dynamic> _selectedBrands = [];

  final TextEditingController _searchController = new TextEditingController();
  final TextEditingController _minPriceController = new TextEditingController();
  final TextEditingController _maxPriceController = new TextEditingController();

  //--------------------
  List<dynamic> _filterBrandList = List();
  bool _filteredBrandsCalled = false;
  List<dynamic> _filterCategoryList = List();
  bool _filteredCategoriesCalled = false;

  //----------------------------------------
  String _searchKey = "";

  List<dynamic> _productList = [];
  bool _isProductInitial = true;
  int _productPage = 1;
  int _totalProductData = 0;
  bool _showProductLoadingContainer = false;

  List<dynamic> _brandList = [];
  bool _isBrandInitial = true;
  int _brandPage = 1;
  int _totalBrandData = 0;
  bool _showBrandLoadingContainer = false;

  List<dynamic> _shopList = [];
  bool _isShopInitial = true;
  int _shopPage = 1;
  int _totalShopData = 0;
  bool _showShopLoadingContainer = false;

  //----------------------------------------

  fetchFilteredBrands() async {
    var filteredBrandResponse = await BrandRepository().getFilterPageBrands();
    _filterBrandList.addAll(filteredBrandResponse.brands);
    _filteredBrandsCalled = true;
    setState(() {});
  }

  fetchFilteredCategories() async {
    var filteredCategoriesResponse =
        await CategoryRepository().getFilterPageCategories();
    _filterCategoryList.addAll(filteredCategoriesResponse.categories);
    _filteredCategoriesCalled = true;
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _productScrollController.dispose();
    _brandScrollController.dispose();
    _shopScrollController.dispose();
    super.dispose();
  }

  init() {
    _givenSelectedFilterOptionKey = widget.selected_filter;

    _dropdownWhichFilterItems =
        buildDropdownWhichFilterItems(_which_filter_list);
    _selectedFilter = _dropdownWhichFilterItems[0].value;

    for (int x = 0; x < _dropdownWhichFilterItems.length; x++) {
      if (_dropdownWhichFilterItems[x].value.option_key ==
          _givenSelectedFilterOptionKey) {
        _selectedFilter = _dropdownWhichFilterItems[x].value;
      }
    }

    fetchFilteredCategories();
    fetchFilteredBrands();

    if (_selectedFilter.option_key == "sellers") {
      fetchShopData();
    } else if (_selectedFilter.option_key == "brands") {
      fetchBrandData();
    } else {
      fetchProductData();
    }

    //set scroll listeners

    _productScrollController.addListener(() {
      if (_productScrollController.position.pixels ==
          _productScrollController.position.maxScrollExtent) {
        setState(() {
          _productPage++;
        });
        _showProductLoadingContainer = true;
        fetchProductData();
      }
    });

    _brandScrollController.addListener(() {
      if (_brandScrollController.position.pixels ==
          _brandScrollController.position.maxScrollExtent) {
        setState(() {
          _brandPage++;
        });
        _showBrandLoadingContainer = true;
        fetchBrandData();
      }
    });

    _shopScrollController.addListener(() {
      if (_shopScrollController.position.pixels ==
          _shopScrollController.position.maxScrollExtent) {
        setState(() {
          _shopPage++;
        });
        _showShopLoadingContainer = true;
        fetchShopData();
      }
    });
  }

  fetchProductData() async {
    var productResponse = await ProductRepository().getFilteredProducts(
        page: _productPage,
        name: _searchKey,
        sort_key: _selectedSort,
        brands: _selectedBrands.join(",").toString(),
        categories: _selectedCategories.join(",").toString(),
        max: _maxPriceController.text.toString(),
        min: _minPriceController.text.toString());

    _productList.addAll(productResponse.products);
    _isProductInitial = false;
    _totalProductData = productResponse.meta.total;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  resetProductList() {
    _productList.clear();
    _isProductInitial = true;
    _totalProductData = 0;
    _productPage = 1;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  fetchBrandData() async {
    var brandResponse =
        await BrandRepository().getBrands(page: _brandPage, name: _searchKey);
    _brandList.addAll(brandResponse.brands);
    _isBrandInitial = false;
    _totalBrandData = brandResponse.meta.total;
    _showBrandLoadingContainer = false;
    setState(() {});
  }

  resetBrandList() {
    _brandList.clear();
    _isBrandInitial = true;
    _totalBrandData = 0;
    _brandPage = 1;
    _showBrandLoadingContainer = false;
    setState(() {});
  }

  fetchShopData() async {
    var shopResponse =
        await ShopRepository().getShops(page: _shopPage, name: _searchKey);
    _shopList.addAll(shopResponse.shops);
    _isShopInitial = false;
    _totalShopData = shopResponse.meta.total;
    _showShopLoadingContainer = false;
    setState(() {});
  }

  resetShopList() {
    _shopList.clear();
    _isShopInitial = true;
    _totalShopData = 0;
    _shopPage = 1;
    _showShopLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onProductListRefresh() async {
    resetProductList();
    fetchProductData();
  }

  Future<void> _onBrandListRefresh() async {
    resetBrandList();
    fetchBrandData();
  }

  Future<void> _onShopListRefresh() async {
    resetShopList();
    fetchShopData();
  }

  _applyProductFilter() {
    resetProductList();
    fetchProductData();
  }

  _onSearchSubmit() {
    if (_selectedFilter.option_key == "sellers") {
      resetShopList();
      fetchShopData();
    } else if (_selectedFilter.option_key == "brands") {
      resetBrandList();
      fetchBrandData();
    } else {
      resetProductList();
      fetchProductData();
    }
  }

  _onSortChange() {
    resetProductList();
    fetchProductData();
  }

  _onWhichFilterChange() {
    if (_selectedFilter.option_key == "sellers") {
      resetShopList();
      fetchShopData();
    } else if (_selectedFilter.option_key == "brands") {
      resetBrandList();
      fetchBrandData();
    } else {
      resetProductList();
      fetchProductData();
    }
  }

  List<DropdownMenuItem<WhichFilter>> buildDropdownWhichFilterItems(
      List which_filter_list) {
    List<DropdownMenuItem<WhichFilter>> items = List();
    for (WhichFilter which_filter_item in which_filter_list) {
      items.add(
        DropdownMenuItem(
          value: which_filter_item,
          child: Text(which_filter_item.name),
        ),
      );
    }
    return items;
  }

  Container buildProductLoadingContainer() {
    return Container(
      height: _showProductLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalProductData == _productList.length
            ? S.of(context).noMoreProducts
            : S.of(context).loadingMoreProducts),
      ),
    );
  }

  Container buildBrandLoadingContainer() {
    return Container(
      height: _showBrandLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalBrandData == _brandList.length
            ? S.of(context).noMoreBrands
            : S.of(context).loadingMoreBrands),
      ),
    );
  }

  Container buildShopLoadingContainer() {
    return Container(
      height: _showShopLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalShopData == _shopList.length
            ? S.of(context).noMoreShops
            : S.of(context).loadingMoreShops),
      ),
    );
  }

  //--------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: buildFilterDrawer(),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(overflow: Overflow.visible, children: [
        _selectedFilter.option_key == 'product'
            ? buildProductList()
            : (_selectedFilter.option_key == 'brands'
                ? buildBrandList()
                : buildShopList()),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: buildAppBar(context),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: _selectedFilter.option_key == 'product'
                ? buildProductLoadingContainer()
                : (_selectedFilter.option_key == 'brands'
                    ? buildBrandLoadingContainer()
                    : buildShopLoadingContainer()))
      ]),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        actions: [Container()],
        backgroundColor: Colors.white.withOpacity(0.95),
        centerTitle: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
          child: Column(
            children: [buildTopAppbar(context)],
          ),
        ));
  }

  Row buildBottomAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(
                  vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                  horizontal: BorderSide(color: MyTheme.light_grey, width: 1))),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 36,
          width: MediaQuery.of(context).size.width * .33,
          child: new DropdownButton<WhichFilter>(
            isExpanded: true,
            icon: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(Icons.expand_more, color: Colors.black54),
            ),
            hint: Text(
              S.of(context).products,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
            iconSize: 14,
            underline: SizedBox(),
            value: _selectedFilter,
            items: _dropdownWhichFilterItems,
            onChanged: (WhichFilter selectedFilter) {
              setState(() {
                _selectedFilter = selectedFilter;
              });

              _onWhichFilterChange();
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            _selectedFilter.option_key == "product"
                ? _scaffoldKey.currentState.openEndDrawer()
                : ToastComponent.showDialog(
                    S.of(context).youCanUseFiltersWhileSearchingForProducts,
                  );
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            height: 36,
            width: MediaQuery.of(context).size.width * .33,
            child: Center(
              child: Container(
                width: 50,
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_alt_outlined,
                      size: 13,
                    ),
                    SizedBox(width: 2),
                    Text(
                      S.of(context).filter,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _selectedFilter.option_key == "product"
                ? showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          contentPadding: EdgeInsets.only(
                              top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
                          content: StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return SingleChildScrollView(
                              reverse: false,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(left: 24.0),
                                      child: Text(
                                        S.of(context).sortProductsBy,
                                      )),
                                  RadioListTile(
                                    dense: true,
                                    value: "",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(S.of(context).default_),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "price_high_to_low",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(S.of(context).priceHighToLow),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "price_low_to_high",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(S.of(context).priceLowToHigh),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "new_arrival",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(S.of(context).newArrival),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "popularity",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(S.of(context).popularity),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  RadioListTile(
                                    dense: true,
                                    value: "top_rated",
                                    groupValue: _selectedSort,
                                    activeColor: MyTheme.font_grey,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(S.of(context).topRated),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSort = value;
                                      });
                                      _onSortChange();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
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
                        ))
                : ToastComponent.showDialog(
                    S.of(context).youCanUseSortingWhileSearchingForProducts,
                  );
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                    vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                    horizontal:
                        BorderSide(color: MyTheme.light_grey, width: 1))),
            height: 36,
            width: MediaQuery.of(context).size.width * .33,
            child: Center(
              child: Container(
                width: 50,
                child: Row(
                  children: [
                    Icon(
                      Icons.swap_vert,
                      size: 13,
                    ),
                    SizedBox(width: 2),
                    Text(
                      S.of(context).sort,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  buildTopAppbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
          Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.accent_color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Expanded(
          child: TextField(
            onTap: () {},
            autofocus: true,
            controller: _searchController,
            onSubmitted: (txt) {
              _searchKey = txt;
              setState(() {});
              _onSearchSubmit();
            },
            decoration: InputDecoration(
                hintText: S.of(context).searchProductHere,
                hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.light_grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                ),
                contentPadding: EdgeInsets.all(0.0)),
          ),
        ),
        IconButton(
            icon: Icon(Icons.search, color: MyTheme.accent_color),
            onPressed: () {
              _searchKey = _searchController.text.toString();
              setState(() {});
              _onSearchSubmit();
            }),
      ]),
    );
  }

  Drawer buildFilterDrawer() {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        S.of(context).priceRange,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            height: 30,
                            width: 100,
                            child: TextField(
                              controller: _minPriceController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [_amountValidator],
                              decoration: InputDecoration(
                                  hintText: S.of(context).minimum,
                                  hintStyle: TextStyle(
                                      fontSize: 12.0,
                                      color: MyTheme.textfield_grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.textfield_grey,
                                        width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.textfield_grey,
                                        width: 2.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(4.0),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(4.0)),
                            ),
                          ),
                        ),
                        Text(" - "),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            height: 30,
                            width: 100,
                            child: TextField(
                              controller: _maxPriceController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [_amountValidator],
                              decoration: InputDecoration(
                                  hintText: S.of(context).maximum,
                                  hintStyle: TextStyle(
                                      fontSize: 12.0,
                                      color: MyTheme.textfield_grey),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.textfield_grey,
                                        width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: MyTheme.textfield_grey,
                                        width: 2.0),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(4.0),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(4.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CustomScrollView(slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Text(
                        S.of(context).categories,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _filterCategoryList.length == 0
                        ? Container(
                            height: 100,
                            child: Center(
                              child: Text(
                                S.of(context).noCategoriesAvailable,
                                style: TextStyle(color: MyTheme.font_grey),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: buildFilterCategoryList(),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Text(
                        S.of(context).brands,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _filterBrandList.length == 0
                        ? Container(
                            height: 100,
                            child: Center(
                              child: Text(
                                S.of(context).noBrandsAvailable,
                                style: TextStyle(color: MyTheme.font_grey),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            child: buildFilterBrandsList(),
                          ),
                  ]),
                )
              ]),
            ),
            Container(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: Color.fromRGBO(234, 67, 53, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      S.of(context).clear,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _minPriceController.clear();
                      _maxPriceController.clear();
                      setState(() {
                        _selectedCategories.clear();
                        _selectedBrands.clear();
                      });
                    },
                  ),
                  MaterialButton(
                    color: Color.fromRGBO(52, 168, 83, 1),
                    child: Text(
                      S.of(context).apply,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      var min = _minPriceController.text.toString();
                      var max = _maxPriceController.text.toString();
                      bool apply = true;
                      if (min != "" && max != "") {
                        if (max.compareTo(min) < 0) {
                          ToastComponent.showDialog(
                            S.of(context).minPriceCannotBeLargerThanMaxPrice,
                          );
                          apply = false;
                        }
                      }

                      if (apply) {
                        Navigator.pop(context);
                        _applyProductFilter();
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildFilterBrandsList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterBrandList
            .map(
              (brand) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(brand.name),
                value: _selectedBrands.contains(brand.id),
                onChanged: (bool value) {
                  if (value) {
                    setState(() {
                      _selectedBrands.add(brand.id);
                    });
                  } else {
                    setState(() {
                      _selectedBrands.remove(brand.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  ListView buildFilterCategoryList() {
    return ListView(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        ..._filterCategoryList
            .map(
              (category) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                title: Text(category.name),
                value: _selectedCategories.contains(category.id),
                onChanged: (bool value) {
                  if (value) {
                    setState(() {
                      _selectedCategories.clear();
                      _selectedCategories.add(category.id);
                    });
                  } else {
                    setState(() {
                      _selectedCategories.remove(category.id);
                    });
                  }
                },
              ),
            )
            .toList()
      ],
    );
  }

  Container buildProductList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildProductScrollableList(),
          )
        ],
      ),
    );
  }

  buildProductScrollableList() {
    if (_isProductInitial && _productList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_productList.length > 0) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.accent_color,
        onRefresh: _onProductListRefresh,
        child: SingleChildScrollView(
          controller: _productScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(height: 88
                  //MediaQuery.of(context).viewPadding.top > 40 ? 180 : 135
                  //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ),
              GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _productList.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.52),
                padding: EdgeInsets.all(16),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return ProductCard(
                    id: _productList[index].id,
                    image: _productList[index].thumbnail_image,
                    name: _productList[index].name,
                    price: _productList[index].stroked_price,
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalProductData == 0) {
      return Center(child: Text(S.of(context).noProductIsAvailable));
    } else {
      return Container(); // should never be happening
    }
  }

  Container buildBrandList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildBrandScrollableList(),
          )
        ],
      ),
    );
  }

  buildBrandScrollableList() {
    if (_isBrandInitial && _brandList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildSquareGridShimmer(scontroller: _scrollController));
    } else if (_brandList.length > 0) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.accent_color,
        onRefresh: _onBrandListRefresh,
        child: SingleChildScrollView(
          controller: _brandScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(height: 116
                  //MediaQuery.of(context).viewPadding.top > 40 ? 180 : 135
                  //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ),
              GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _brandList.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1),
                padding: EdgeInsets.all(8),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return BrandSquareCard(
                    id: _brandList[index].id,
                    image: _brandList[index].logo,
                    name: _brandList[index].name,
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalBrandData == 0) {
      return Center(child: Text(S.of(context).noBrandIsAvailable));
    } else {
      return Container(); // should never be happening
    }
  }

  Container buildShopList() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildShopScrollableList(),
          )
        ],
      ),
    );
  }

  buildShopScrollableList() {
    if (_isShopInitial && _shopList.length == 0) {
      return SingleChildScrollView(
          controller: _scrollController,
          child: ShimmerHelper()
              .buildSquareGridShimmer(scontroller: _scrollController));
    } else if (_shopList.length > 0) {
      return RefreshIndicator(
        color: Colors.white,
        backgroundColor: MyTheme.accent_color,
        onRefresh: _onShopListRefresh,
        child: SingleChildScrollView(
          controller: _shopScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(height: 116
                  // MediaQuery.of(context).viewPadding.top > 40 ? 180 : 135
                  //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
                  ),
              GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: _shopList.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1),
                padding: EdgeInsets.all(8),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SellerDetails();
                      }));
                    },
                    child: ShopSquareCard(
                      id: _shopList[index].id,
                      image: _shopList[index].logo,
                      name: _shopList[index].name == null
                          ? ""
                          : _shopList[index].name,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    } else if (_totalShopData == 0) {
      return Center(child: DataNotFound());
    } else {
      return Container(); // should never be happening
    }
  }
}
