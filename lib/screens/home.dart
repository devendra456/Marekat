import 'dart:async';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marekat/app_config.dart';
import 'package:marekat/data_model/brand_response.dart';
import 'package:marekat/data_model/category_response.dart';
import 'package:marekat/data_model/product_mini_response.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/brand_repository.dart';
import 'package:marekat/repositories/category_repository.dart';
import 'package:marekat/repositories/product_repository.dart';
import 'package:marekat/repositories/sliders_repository.dart';
import 'package:marekat/screens/home_category_products.dart';
import 'package:marekat/screens/main_screen.dart';
import 'package:marekat/ui_elements/product_card.dart';
import 'package:marekat/ui_sections/main_drawer.dart';
import 'package:shimmer/shimmer.dart';

import 'brand_products.dart';
import 'category_products.dart';
import 'filter.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title, this.show_back_button = false}) : super(key: key);

  final String title;
  bool show_back_button;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _current_slider = 0;
  List<Category> categoryList = [];

  GlobalKey globalKey;

  @override
  void initState() {
    super.initState();
    globalKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: buildAppBar(statusBarHeight, context),
        drawer: MainDrawer(),
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: -50,
              child: Image(
                image: AssetImage(
                  "assets/foreground.png",
                ),
                alignment: Alignment.bottomRight,
                height: 250,
                colorBlendMode: BlendMode.modulate,
                color: const Color.fromRGBO(255, 255, 255, 0.5),
              ),
            ),
            RefreshIndicator(
              color: MyTheme.accent_color,
              backgroundColor: Colors.white,
              onRefresh: _onRefresh,
              displacement: 0,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          0.0,
                          4.0,
                          0.0,
                          0.0,
                        ),
                        child: buildHomeCarouselSlider(context),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              16.0,
                              0.0,
                              0.0,
                            ),
                            child: buildHomeCategory(),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (builder) {
                                  return HomeCategoryProducts(categoryList[3]);
                                }));
                              },
                              child: AspectRatio(
                                aspectRatio: 1.5,
                                child: Image.network(
                                  "https://demo.marekat.com/public/uploads/all/mT97RVRjqnv7w0rBMwH4qSxIApL3YhTUy8Gk8eiA.jpg",
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: MyTheme.accent_color,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context,
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
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            S.of(context).mensCollections,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              S
                                  .of(context)
                                  .discoverAWideRangeOfHighqualitynmenCollection,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          buildCategoryProduct(51),
                          divider(),
                        ],
                      ),
                    ]),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 275,
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 1.5,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (builder) {
                                  return HomeCategoryProducts(categoryList[1]);
                                }));
                              },
                              child: Image.network(
                                "https://demo.marekat.com/public/uploads"
                                "/all/ziGlq4gl7xvgUUpGx"
                                "O7ok71DbJx1ZuA4dfJmuWHt.jpg",
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: MyTheme.accent_color,
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (BuildContext context,
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
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          S.of(context).fashionUsa,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            S.of(context).latestAdditionsToOurWomensnstyleUsa,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        buildCategoryProduct(91),
                        divider(),
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 1.5,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (builder) {
                                  return HomeCategoryProducts(categoryList[0]);
                                }));
                              },
                              child: Image.network(
                                "https://demo.marekat.com/public/uploads/all/V9"
                                "jNUWSRI3EEGhPOJojadCShDRV6xwpklN84ph6X.jpg",
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: MyTheme.accent_color,
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (BuildContext context,
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
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          S.of(context).europeFashion,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            S
                                .of(context)
                                .shopTheLatestAndTrendWomensneuropeFashion,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        buildCategoryProduct(126),
                        divider(),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 275,
                              child: AspectRatio(
                                aspectRatio: 1.5,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return HomeCategoryProducts(
                                          categoryList[2]);
                                    }));
                                  },
                                  child: Image.network(
                                    "https://marekat.com/wp-content/uploads/2021/07/kids-fashion-home-page.jpg",
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: MyTheme.accent_color,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Image.asset(
                                        "assets/placeholder.png",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              S.of(context).kidsCollections,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                S
                                    .of(context)
                                    .matchTheDailyJourneyWithOurKidsNessential,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            buildCategoryProduct(83),
                            divider(),
                            SizedBox(
                              height: 275,
                              width: double.infinity,
                              child: AspectRatio(
                                aspectRatio: 1.5,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return CategoryProducts(
                                        category_id: 25,
                                        category_name: "Swimwear & Sportswear",
                                      );
                                    }));
                                  },
                                  child: Image.network(
                                    "https://marekat.com/wp-content/uploads/2021/07/sportwear-banner-HP.jpg",
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: MyTheme.accent_color,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Image.asset(
                                        "assets/placeholder.png",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              S.of(context).womensSportswear,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                S
                                    .of(context)
                                    .pushYourselfFurtherWithOurTrendySportswear,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            buildCategoryProduct(25),
                            divider(),
                            SizedBox(
                              height: 275,
                              width: double.infinity,
                              child: AspectRatio(
                                aspectRatio: 1.5,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return CategoryProducts(
                                        category_id: 26,
                                        category_name: "BAGS",
                                      );
                                    }));
                                  },
                                  child: Image.network(
                                    "https://marekat.com/wp-content/uploads/2021/07/women-bag-home-page-v02.jpg",
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: MyTheme.accent_color,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Image.asset(
                                        "assets/placeholder.png",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              S.of(context).womensBags,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                S
                                    .of(context)
                                    .discoverOurBagsForWomenVibrantDesigns,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            buildCategoryProduct(26),
                            divider(),
                            SizedBox(
                              height: 275,
                              width: double.infinity,
                              child: AspectRatio(
                                aspectRatio: 1.5,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return CategoryProducts(
                                        category_id: 24,
                                        category_name: "SHOES",
                                      );
                                    }));
                                  },
                                  child: Image.network(
                                    "https://marekat.com/wp-content/uploads/2021/07/faxkxkpk-MADEII@29.jpg",
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: MyTheme.accent_color,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Image.asset(
                                        "assets/placeholder.png",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              S.of(context).womensShoes,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                S
                                    .of(context)
                                    .shoesFromTheBestBrandsMustHavenshoesForEvery,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            buildCategoryProduct(24),
                            divider(),
                            SizedBox(
                              width: double.infinity,
                              height: 275,
                              child: AspectRatio(
                                aspectRatio: 1.5,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return HomeCategoryProducts(
                                          categoryList[4]);
                                    }));
                                  },
                                  child: Image.network(
                                    "https://marekat.com/wp-content/uploads/2021/06/perfume-banner-Home-page.jpg",
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: MyTheme.accent_color,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Image.asset(
                                        "assets/placeholder.png",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              S.of(context).perfumes,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                S
                                    .of(context)
                                    .addTheFinishingTouchToYourLookWithnourRange,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            buildCategoryProduct(118),
                            divider(),
                            SizedBox(
                              height: 275,
                              width: double.infinity,
                              child: AspectRatio(
                                aspectRatio: 1.5,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return CategoryProducts(
                                        category_id: 49,
                                        category_name: "Sunglasses",
                                      );
                                    }));
                                  },
                                  child: Image.network(
                                    "https://marekat.com/wp-content/uploads/2021/06/sunglasses-women-em-600x600-1.jpg",
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: MyTheme.accent_color,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Image.asset(
                                        "assets/placeholder.png",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              S.of(context).womensSunglasses,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                S.of(context).bestWomensSunglassesCollections,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            buildCategoryProduct(49),
                            divider(),
                            SizedBox(
                              width: double.infinity,
                              height: 275,
                              child: AspectRatio(
                                aspectRatio: 1.5,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return CategoryProducts(
                                        category_id: 77,
                                        category_name: "Sunglasses",
                                      );
                                    }));
                                  },
                                  child: Image.network(
                                    "https://marekat.com/wp-content/uploads/2021/06/man-with-sunglasses-1.jpg",
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: MyTheme.accent_color,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Image.asset(
                                        "assets/placeholder.png",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              S.of(context).mensSunglasses,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                S.of(context).bestMensSunglassesCollections,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            buildCategoryProduct(77),
                            divider(),
                            SizedBox(
                              height: 275,
                              width: double.infinity,
                              child: AspectRatio(
                                aspectRatio: 1.5,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return CategoryProducts(
                                        category_name: "Watches",
                                        category_id: 50,
                                      );
                                    }));
                                  },
                                  child: Image.network(
                                    "https://marekat.com/wp-content/uploads/2021/06/PORTRA2-scaled-1.jpg",
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: MyTheme.accent_color,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Image.asset(
                                        "assets/placeholder.png",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              S.of(context).womensWatches,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                S.of(context).bestWomensWatchesCollectionss,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            buildCategoryProduct(50),
                            divider(),
                            SizedBox(
                              height: 275,
                              width: double.infinity,
                              child: AspectRatio(
                                aspectRatio: 1.5,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (builder) {
                                      return CategoryProducts(
                                        category_id: 78,
                                        category_name: "Watches",
                                      );
                                    }));
                                  },
                                  child: Image.network(
                                    "https://marekat.com/wp-content/uploads/2021/06/men-watches-scaled-1.jpg",
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: MyTheme.accent_color,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Image.asset(
                                        "assets/placeholder.png",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              S.of(context).mensWatches,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                S.of(context).bestMensWatchesCollections,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            buildCategoryProduct(78),
                            divider(),
                            Text(
                              S.of(context).topBrands,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                S
                                    .of(context)
                                    .exploreTheHottestTrendWithYournfavouriteBrand,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8),
                              child: buildBrandCard(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 104,
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  buildBrandCard() {
    return FutureBuilder(
        future: BrandRepository().getBrands(page: "1", name: ""),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            var brandResponse = snapshot.data as BrandResponse;
            return SizedBox(
              height: 120,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(0),
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BrandProducts(
                              id: brandResponse.brands[index].id,
                              brand_name: brandResponse.brands[index].name,
                            );
                          },
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: BorderSide(width: 2, color: MyTheme.black
                            //color: Color.fromARGB(255, 221, 221, 221),
                            ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: AppConfig.BASE_PATH +
                              brandResponse.brands[index].logo,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (BuildContext context,
                              Object exception, StackTrace stackTrace) {
                            return Image.asset(
                              "assets/placeholder.png",
                              fit: BoxFit.cover,
                              //height: 64,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                itemCount: brandResponse.brands.length,
              ),
            );
          } else {
            return SizedBox(
              height: 80,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Shimmer.fromColors(
                      baseColor: MyTheme.shimmer_base,
                      highlightColor: MyTheme.shimmer_highlighted,
                      child: Container(
                        height: 60,
                        width: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                itemCount: 6,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 16),
              ),
            );
          }
        });
  }

  buildHomeCarouselSlider(context) {
    return FutureBuilder(
        future: SlidersRepository().getSliders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              height: 250,
              child: Center(
                child: Text(
                  S.of(context).pleasePullDownToRefreshnorCheckYourInternetOr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MyTheme.grey_153),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            var sliderResponse = snapshot.data;
            var carouselImageList = [];
            sliderResponse.sliders.forEach((slider) {
              carouselImageList.add(slider.photo);
            });
            return SizedBox(
              height: 250,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        aspectRatio: 1,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayAnimationDuration: Duration(milliseconds: 1000),
                        //autoPlayCurve: Curves.linear,
                        //enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          Timer(Duration(milliseconds: 500), () {
                            setState(() {
                              _current_slider = index;
                            });
                          });
                        }),
                    items: carouselImageList.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: double.infinity,
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.png',
                              image: AppConfig.BASE_PATH + i,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (BuildContext context,
                                  Object exception, StackTrace stackTrace) {
                                return Image.asset(
                                  "assets/placeholder.png",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: carouselImageList.map((url) {
                          int index = carouselImageList.indexOf(url);
                          return Container(
                            width: _current_slider == index ? 12 : 7.0,
                            height: 7.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              //shape: BoxShape.circle,
                              borderRadius: BorderRadius.circular(4),
                              color: _current_slider == index
                                  ? MyTheme.accent_color
                                  : Color.fromRGBO(112, 112, 112, .3),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Shimmer.fromColors(
                baseColor: MyTheme.shimmer_base,
                highlightColor: MyTheme.shimmer_highlighted,
                child: Container(
                  height: 176,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
            );
          }
        });
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: widget.show_back_button
            ? Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.arrow_back, color: MyTheme.accent_color),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            : Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Container(
                    child: Image.asset(
                      'assets/hamburger.png',
                      height: 16,
                      //color: MyTheme.dark_grey,
                      color: MyTheme.accent_color,
                    ),
                  ),
                ),
              ),
      ),
      title: Container(
        height: kToolbarHeight +
            statusBarHeight -
            (MediaQuery.of(context).viewPadding.top > 40 ? 16.0 : 16.0),
        child: Container(
          child: Padding(
              padding: EdgeInsets.only(
                  top: 14.0,
                  bottom: 14,
                  right: isRTL ? 0 : 16,
                  left: isRTL ? 16 : 0),
              // when notification bell will be shown , the right padding will cease to exist.
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Filter();
                    }));
                  },
                  child: buildHomeSearchBox(context))),
        ),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildHomeSearchBox(BuildContext context) {
    return TextField(
      focusNode:
          FocusNode(canRequestFocus: false, descendantsAreFocusable: false),
      onTap: () {
        //FocusScope.of(context).unfocus();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Filter();
        }));
      },
      autofocus: false,
      decoration: InputDecoration(
          hintText: S.of(context).search,
          hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.textfield_grey, width: 0.5),
            borderRadius: const BorderRadius.all(
              const Radius.circular(20.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.textfield_grey, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(20.0),
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              color: MyTheme.accent_color,
              size: 20,
            ),
          ),
          contentPadding: EdgeInsets.all(0.0)),
    );
  }

  Future<void> _onRefresh() async {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => MainScreen(),
      ),
    );
  }

  buildHomeCategory() {
    return FutureBuilder(
        future: CategoryRepository().getCategories(parent_id: 0),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              height: 80,
              child: Center(
                child: Text(
                  S.of(context).pleasePullDownToRefreshnorCheckYourInternetOr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MyTheme.grey_153),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            var categoryResponse = snapshot.data as CategoryResponse;
            categoryList = categoryResponse.categories;
            return SizedBox(
              height: 80,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 8),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (builder) {
                          return HomeCategoryProducts(
                              categoryResponse.categories[index]);
                        }),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipOval(
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
                          SizedBox(
                            height: 6,
                          ),
                          SizedBox(
                            width: 58,
                            child: Text(
                              categoryResponse.categories[index].name,
                              style: TextStyle(fontSize: 12),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: categoryResponse.categories.length,
              ),
            );
          } else {
            return SizedBox(
              height: 80,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 8),
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Shimmer.fromColors(
                    baseColor: MyTheme.shimmer_base,
                    highlightColor: MyTheme.shimmer_highlighted,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 60,
                        width: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                itemCount: 8,
              ),
            );
          }
        });
  }

  buildCategoryProduct(int id) {
    return FutureBuilder(
        future: ProductRepository().getCategoryProducts(id: id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              height: MediaQuery.of(context).size.height * .4,
              child: Center(
                child: Text(
                  S.of(context).pleasePullDownToRefreshnorCheckYourInternetOr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MyTheme.grey_153),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            var productResponse = snapshot.data as ProductMiniResponse;
            if (productResponse.products.length == 0) return SizedBox();
            return SizedBox(
              height: MediaQuery.of(context).size.height * .4,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemExtent: MediaQuery.of(context).size.width * .51,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ProductCard(
                      image: productResponse.products[index].thumbnail_image,
                      id: productResponse.products[index].id,
                      name: productResponse.products[index].name,
                      price: productResponse.products[index].stroked_price,
                    ),
                  );
                },
                itemCount: productResponse.products.length,
              ),
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height * .4,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 8),
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemExtent: MediaQuery.of(context).size.width * .4,
                itemBuilder: (BuildContext context, int index) {
                  return Shimmer.fromColors(
                    baseColor: MyTheme.shimmer_base,
                    highlightColor: MyTheme.shimmer_highlighted,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 60,
                        width: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                itemCount: 8,
              ),
            );
          }
        });
  }

  divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Container(
        color: MyTheme.light_grey,
        height: 2,
        width: double.infinity,
      ),
    );
  }
}
