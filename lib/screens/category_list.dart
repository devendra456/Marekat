import 'package:flutter/material.dart';
import 'package:marekat/app_config.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/category_repository.dart';
import 'package:marekat/screens/category_products.dart';
import 'package:marekat/ui_sections/main_drawer.dart';
import 'package:shimmer/shimmer.dart';

import 'home_category_products.dart';

class CategoryList extends StatefulWidget {
  CategoryList(
      {Key key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(),
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 100, bottom: 20),
            child: Image(
              image: AssetImage("assets/foreground.png"),
              alignment: Alignment.bottomRight,
              colorBlendMode: BlendMode.modulate,
              color: const Color.fromRGBO(255, 255, 255, 0.5),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                buildCategoryList(),
                Container(
                  height: widget.is_base_category ? 60 : 90,
                )
              ]))
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: widget.is_base_category || widget.is_top_category
                ? Container(
                    height: 0,
                  )
                : buildBottomContainer(),
          )
        ]));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: widget.is_base_category
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
        getAppBarTitle(),
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  String getAppBarTitle() {
    String name = widget.parent_category_name == ""
        ? (widget.is_top_category ? "Top Categories" : "Categories")
        : widget.parent_category_name;

    return name;
  }

  buildCategoryList() {
    var future = widget.is_top_category
        ? CategoryRepository().getTopCategories()
        : CategoryRepository()
            .getCategories(parent_id: widget.parent_category_id);
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              height: 10,
            );
          } else if (snapshot.hasData) {
            //snapshot.hasData
            var categoryResponse = snapshot.data;
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: categoryResponse.categories.length,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 4.0, left: 12.0, right: 12.0),
                    child: buildCategoryItemCard(categoryResponse, index),
                  );
                },
              ),
            );
          } else {
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
                    child: Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: MyTheme.shimmer_base,
                          highlightColor: MyTheme.shimmer_highlighted,
                          child: Container(
                            height: 60,
                            width: 60,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, bottom: 8.0),
                                child: Shimmer.fromColors(
                                  baseColor: MyTheme.shimmer_base,
                                  highlightColor: MyTheme.shimmer_highlighted,
                                  child: Container(
                                    height: 20,
                                    //width: MediaQuery.of(context).size.width * .7,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Shimmer.fromColors(
                                  baseColor: MyTheme.shimmer_base,
                                  highlightColor: MyTheme.shimmer_highlighted,
                                  child: Container(
                                    height: 20,
                                    //width: MediaQuery.of(context).size.width * .5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        });
  }

  buildCategoryItemCard(categoryResponse, index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 1.5,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CategoryList(
              parent_category_id: categoryResponse.categories[index].id,
              parent_category_name: categoryResponse.categories[index].name,
            );
          }));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 116,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16), right: Radius.zero),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: AppConfig.BASE_PATH +
                          categoryResponse.categories[index].banner,
                      fit: BoxFit.cover,
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
              ),
            ),
            Expanded(
              child: Container(
                height: 115,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 8, 0),
                      child: Text(
                        categoryResponse.categories[index].name,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 15, 8, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          categoryResponse
                                      .categories[index].number_of_children >
                                  0
                              ? GestureDetector(
                                  onTap: () {
                                    if (categoryResponse.categories[index]
                                            .number_of_children >
                                        0) {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return CategoryList(
                                          parent_category_id: categoryResponse
                                              .categories[index].id,
                                          parent_category_name: categoryResponse
                                              .categories[index].name,
                                        );
                                      }));
                                    } else {
                                      ToastComponent.showDialog(S
                                          .of(context)
                                          .noSubCategoriesAvailable);
                                    }
                                  },
                                  child: Text(
                                    S.of(context).viewSubcategories,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: categoryResponse.categories[index]
                                                  .number_of_children >
                                              0
                                          ? MyTheme.accent_color
                                          : MyTheme.accent_color,
                                    ),
                                  ),
                                )
                              : Container(
                                  child: Text(
                                    S.of(context).noSubCategoriesAvailable,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return HomeCategoryProducts(
                                      categoryResponse.categories[index]);
                                }));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: MyTheme.accent_color,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                height: 30,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    S.of(context).viewProducts,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),

      height: widget.is_base_category ? 0 : 80,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: (MediaQuery.of(context).size.width - 32),
                height: 40,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  //height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(9.0))),
                  child: Text(
                    S.of(context).allProductsOf + widget.parent_category_name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CategoryProducts(
                        category_id: widget.parent_category_id,
                        category_name: widget.parent_category_name,
                      );
                    }));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
