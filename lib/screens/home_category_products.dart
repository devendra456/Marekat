import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/data_model/category_response.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/reg_ex_inpur_formatter.dart';
import 'package:marekat/helpers/shimmer_helper.dart';
import 'package:marekat/repositories/brand_repository.dart';
import 'package:marekat/repositories/category_repository.dart';
import 'package:marekat/repositories/product_repository.dart';
import 'package:marekat/repositories/shop_repository.dart';
import 'package:marekat/ui_elements/product_card.dart';

import '../my_theme.dart';

class HomeCategoryProducts extends StatefulWidget {
  final Category category;

  const HomeCategoryProducts(this.category, {Key key}) : super(key: key);

  @override
  _HomeCategoryProductsState createState() => _HomeCategoryProductsState();
}

class _HomeCategoryProductsState extends State<HomeCategoryProducts> {
  final _amountValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');

  ScrollController _productScrollController = ScrollController();
  ScrollController _scrollController;
  var _selectedSort = "";
  List<dynamic> _selectedCategories = [];
  List<dynamic> _selectedBrands = [];

  final TextEditingController _searchController = new TextEditingController();
  final TextEditingController _minPriceController = new TextEditingController();
  final TextEditingController _maxPriceController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

  List<Category> _categoryList = [];
  var _selectedIndex = 0;

  String selectedCategoryRoute = "";

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
    print(widget.category.id);
    super.initState();
  }

  @override
  void dispose() {
    _productScrollController.dispose();
    super.dispose();
  }

  init() {
    _selectedCategories.add(widget.category.id);
    fetchProductData();
    fetchSubCategory(widget.category.id);
    fetchFilteredBrands();
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
  }

  fetchSubCategory(int id) async {
    _categoryList = [];
    final response = await CategoryRepository().getCategories(parent_id: id);
    _categoryList = response.categories;
    setState(() {});
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

  _applyProductFilter() {
    resetProductList();
    fetchProductData();
  }

  _onSearchSubmit() {
    resetProductList();
    fetchProductData();
  }

  _onSortChange() {
    resetProductList();
    fetchProductData();
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
      body: Stack(clipBehavior: Clip.none, children: [
        buildProductList(),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: buildAppBar(context),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: buildProductLoadingContainer(),
        )
      ]),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      automaticallyImplyLeading: false,
      actions: [Container()],
      backgroundColor: Colors.white.withOpacity(0.95),
      centerTitle: false,
      flexibleSpace: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
        child: Column(
          children: [
            buildTopAppbar(context),
            buildBottomAppBar(context),
            subCategoriesList(context)
          ],
        ),
      ),
    );
  }

  subCategoriesList(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 4),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      _selectedCategories.clear();
                      _selectedCategories.add(index == 0
                          ? widget.category.id
                          : _categoryList[index - 1].id);
                      resetProductList();
                      fetchProductData();
                      print(_categoryList[index - 1].number_of_children);
                      if (index != 0) {
                        if (_categoryList[index - 1].number_of_children > 0) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (builder) {
                            return HomeCategoryProducts(
                                _categoryList[index - 1]);
                          }));
                        }
                      } else if (index == 0) {
                        resetProductList();
                        fetchProductData();
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: index == _selectedIndex
                              ? Color.fromARGB(255, 0, 0, 0)
                              : Colors.white,
                          border: Border.all(
                              color: index == _selectedIndex
                                  ? Color.fromARGB(255, 0, 0, 0)
                                  : Color.fromARGB(255, 182, 182, 182),
                              width: index == _selectedIndex ? 1 : 0.5),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        index == 0 ? "ALL" : _categoryList[index - 1].name,
                        style: TextStyle(
                            color: _selectedIndex == index
                                ? MyTheme.white
                                : MyTheme.black,
                            fontSize: 14),
                      ),
                    ),
                  ),
                );
              },
              itemCount: _categoryList.length + 1,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }

  Row buildBottomAppBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.symmetric(
                  vertical: BorderSide(color: MyTheme.light_grey, width: .5),
                  horizontal: BorderSide(color: MyTheme.light_grey, width: 1),
                ),
              ),
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
        Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(
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
                                    padding: const EdgeInsets.only(left: 24.0),
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
                      ));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.symmetric(
                      vertical:
                          BorderSide(color: MyTheme.light_grey, width: .5),
                      horizontal:
                          BorderSide(color: MyTheme.light_grey, width: 1))),
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
        )
      ],
    );
  }

  buildTopAppbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back, color: MyTheme.accent_color),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: TextField(
                onTap: () {},
                controller: _searchController,
                onSubmitted: (txt) {
                  _searchKey = txt;
                  setState(() {});
                  _onSearchSubmit();
                },
                decoration: InputDecoration(
                    hintText: S.of(context).searchHere,
                    hintStyle: TextStyle(
                        fontSize: 12.0, color: MyTheme.textfield_grey),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              SizedBox(height: 144),
              GridView.builder(
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
}
