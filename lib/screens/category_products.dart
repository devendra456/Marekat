import 'package:flutter/material.dart';
import 'package:marekat/custom/data_not_found.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/shimmer_helper.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/product_repository.dart';
import 'package:marekat/ui_elements/product_card.dart';

class CategoryProducts extends StatefulWidget {
  CategoryProducts({Key key, this.category_name, this.category_id})
      : super(key: key);
  final String category_name;
  final int category_id;

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  ScrollController _scrollController = ScrollController();
  ScrollController _xcrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  List<dynamic> _productList = [];
  bool _isInitial = true;
  int _page = 1;
  String _searchKey = "";
  int _totalData = 0;
  bool _showLoadingContainer = false;

  @override
  void initState() {
    // TODO: implement initState
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

  fetchData() async {
    var productResponse = await ProductRepository().getCategoryProducts(
        id: widget.category_id, page: _page, name: _searchKey);
    _productList.addAll(productResponse.products);
    _isInitial = false;
    _totalData = productResponse.meta.total;
    _showLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _productList.clear();
    _isInitial = true;
    _totalData = 0;
    _page = 1;
    _showLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            buildProductList(),
            Align(
                alignment: Alignment.bottomCenter,
                child: buildLoadingContainer())
          ],
        ));
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _productList.length
            ? S.of(context).noMoreProducts
            : S.of(context).loadingMoreProducts),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 75,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.accent_color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
          width: 250,
          child: TextField(
            controller: _searchController,
            onTap: () {},
            onChanged: (txt) {
              /*_searchKey = txt;
              reset();
              fetchData();*/
            },
            onSubmitted: (txt) {
              _searchKey = txt;
              reset();
              fetchData();
            },
            autofocus: false,
            decoration: InputDecoration(
                hintText:
                    S.of(context).searchProductsFrom + widget.category_name,
                hintStyle:
                    TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyTheme.white, width: 0.0),
                ),
                contentPadding: EdgeInsets.all(0.0)),
          )),
      elevation: 0.0,
      titleSpacing: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: IconButton(
            icon: Icon(Icons.search, color: MyTheme.accent_color),
            onPressed: () {
              _searchKey = _searchController.text.toString();
              reset();
              fetchData();
            },
          ),
        ),
      ],
    );
  }

  buildProductList() {
    if (_isInitial && _productList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildProductGridShimmer(scontroller: _scrollController));
    } else if (_productList.length > 0) {
      return RefreshIndicator(
        color: MyTheme.accent_color,
        backgroundColor: Colors.white,
        displacement: 0,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: _xcrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: GridView.builder(
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
            //physics: NeverScrollableScrollPhysics(),
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
          ),
        ),
      );
    } else if (_totalData == 0) {
      return Center(child: DataNotFound());
    } else {
      return Container(); // should never be happening
    }
  }
}
