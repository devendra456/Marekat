import 'dart:async';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marekat/app_config.dart';
import 'package:marekat/data_model/brand_response.dart';
import 'package:marekat/data_model/category_response.dart';
import 'package:marekat/data_model/product_mini_response.dart';
import 'package:marekat/data_model/slider_response.dart';
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
  final ScrollController controller;
  Home({
    Key key,
    this.title,
    this.show_back_button = false,
    this.controller = null,
  }) : super(key: key);

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

  List<Sliders> sliders = [];

  List<Category> categoriesList = [];

  List<Product> list1 = [];
  List<Product> list2 = [];
  List<Product> list3 = [];
  List<Product> list4 = [];
  List<Product> list5 = [];
  List<Product> list6 = [];
  List<Product> list7 = [];
  List<Product> list8 = [];
  List<Product> list9 = [];
  List<Product> list10 = [];
  List<Product> list11 = [];
  List<Product> list12 = [];

  final String bannerImage1 =
      "https://demo.marekat.com/public/uploads/all/mT97RVRjqnv7w0rBMwH4qSxIApL3YhTUy8Gk8eiA.jpg";
  final String bannerImage2 =
      "https://demo.marekat.com/public/uploads/all/ziGlq4gl7xvgUUpGxO7ok71DbJx1ZuA4dfJmuWHt.jpg";
  final String bannerImage3 = "https://demo.marekat.com/public/uploads/all/V9"
      "jNUWSRI3EEGhPOJojadCShDRV6xwpklN84ph6X.jpg";
  final String bannerImage4 =
      "https://marekat.com/wp-content/uploads/2021/07/kids-fashion-home-page.jpg";
  final String bannerImage5 =
      "https://marekat.com/wp-content/uploads/2021/07/sportwear-banner-HP.jpg";
  final String bannerImage6 =
      "https://marekat.com/wp-content/uploads/2021/07/women-bag-home-page-v02.jpg";
  final String bannerImage7 =
      "https://marekat.com/wp-content/uploads/2021/07/faxkxkpk-MADEII@29.jpg";
  final String bannerImage8 =
      "https://marekat.com/wp-content/uploads/2021/06/perfume-banner-Home-page.jpg";
  final String bannerImage9 =
      "https://marekat.com/wp-content/uploads/2021/06/sunglasses-women-em-600x600-1.jpg";
  final String bannerImage10 =
      "https://marekat.com/wp-content/uploads/2021/06/man-with-sunglasses-1.jpg";
  final String bannerImage11 =
      "https://marekat.com/wp-content/uploads/2021/06/PORTRA2-scaled-1.jpg";
  final String bannerImage12 =
      "https://marekat.com/wp-content/uploads/2021/06/men-watches-scaled-1.jpg";

  @override
  void initState() {
    getSliders();
    getHomeCategories();
    super.initState();
    globalKey = GlobalKey();
    getList1();
    getList2();
    getList3();
    getList4();
    getList5();
    getList6();
    getList7();
    getList8();
    getList9();
    getList10();
    getList11();
    getList12();
  }

  getList1() async {
    final res = await ProductRepository().getCategoryProducts(id: 51);
    list1 = res.products;
    setState(() {});
  }

  getList2() async {
    final res = await ProductRepository().getCategoryProducts(id: 91);
    list2 = res.products;
    setState(() {});
  }

  getList3() async {
    final res = await ProductRepository().getCategoryProducts(id: 126);
    list3 = res.products;
    setState(() {});
  }

  getList4() async {
    final res = await ProductRepository().getCategoryProducts(id: 83);
    list4 = res.products;
    setState(() {});
  }

  getList5() async {
    final res = await ProductRepository().getCategoryProducts(id: 25);
    list5 = res.products;
    setState(() {});
  }

  getList6() async {
    final res = await ProductRepository().getCategoryProducts(id: 26);
    list6 = res.products;
    setState(() {});
  }

  getList7() async {
    final res = await ProductRepository().getCategoryProducts(id: 34);
    list7 = res.products;
    setState(() {});
  }

  getList8() async {
    final res = await ProductRepository().getCategoryProducts(id: 118);
    list8 = res.products;
    setState(() {});
  }

  getList9() async {
    final res = await ProductRepository().getCategoryProducts(id: 49);
    list9 = res.products;
    setState(() {});
  }

  getList10() async {
    final res = await ProductRepository().getCategoryProducts(id: 77);
    list10 = res.products;
    setState(() {});
  }

  getList11() async {
    final res = await ProductRepository().getCategoryProducts(id: 50);
    list11 = res.products;
    setState(() {});
  }

  getList12() async {
    final res = await ProductRepository().getCategoryProducts(id: 78);
    list12 = res.products;
    setState(() {});
  }

  getSliders() async {
    final response = await SlidersRepository().getSliders();
    sliders = response.sliders;
    setState(() {});
  }

  getHomeCategories() async {
    final response = await CategoryRepository().getCategories(parent_id: 0);
    categoriesList = response.categories;
    setState(() {});
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
                controller: widget.controller,
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
                          _buildHomeBanners(
                              productList: list1,
                              description: S
                                  .of(context)
                                  .discoverAWideRangeOfHighqualitynmenCollection,
                              heading: S.of(context).mensCollections,
                              imagePath: bannerImage1,
                              onClickScreen: CategoryProducts(
                                category_id: 51,
                                category_name: "Men's Collection",
                              ))
                        ],
                      ),
                    ]),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        _buildHomeBanners(
                            description: S
                                .of(context)
                                .latestAdditionsToOurWomensnstyleUsa,
                            productList: list2,
                            heading: S.of(context).fashionUsa,
                            imagePath: bannerImage2,
                            onClickScreen: CategoryProducts(
                              category_id: 91,
                              category_name: "Fashion USA",
                            )),
                        _buildHomeBanners(
                            description: S
                                .of(context)
                                .shopTheLatestAndTrendWomensneuropeFashion,
                            heading: S.of(context).europeFashion,
                            imagePath: bannerImage3,
                            productList: list3,
                            onClickScreen: CategoryProducts(
                              category_id: 126,
                              category_name: "Europe Fashion",
                            )),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildHomeBanners(
                                productList: list4,
                                description: S
                                    .of(context)
                                    .matchTheDailyJourneyWithOurKidsNessential,
                                heading: S.of(context).kidsCollections,
                                imagePath: bannerImage4,
                                onClickScreen: CategoryProducts(
                                  category_id: 83,
                                  category_name: "Kid's Collections",
                                )),
                            _buildHomeBanners(
                                productList: list5,
                                description: S
                                    .of(context)
                                    .pushYourselfFurtherWithOurTrendySportswear,
                                heading: S.of(context).womensSportswear,
                                imagePath: bannerImage5,
                                onClickScreen: CategoryProducts(
                                  category_id: 25,
                                  category_name: "Swimwear & Sportswear",
                                )),
                            _buildHomeBanners(
                                productList: list6,
                                description: S
                                    .of(context)
                                    .discoverOurBagsForWomenVibrantDesigns,
                                heading: S.of(context).womensBags,
                                imagePath: bannerImage6,
                                onClickScreen: CategoryProducts(
                                  category_id: 26,
                                  category_name: "BAGS",
                                )),
                            _buildHomeBanners(
                                productList: list7,
                                description: S
                                    .of(context)
                                    .shoesFromTheBestBrandsMustHavenshoesForEvery,
                                heading: S.of(context).womensShoes,
                                imagePath: bannerImage7,
                                onClickScreen: CategoryProducts(
                                  category_id: 34,
                                  category_name: "SHOES",
                                )),
                            _buildHomeBanners(
                                productList: list8,
                                description: S
                                    .of(context)
                                    .addTheFinishingTouchToYourLookWithnourRange,
                                heading: S.of(context).perfumes,
                                imagePath: bannerImage8,
                                onClickScreen: CategoryProducts(
                                  category_id: 118,
                                  category_name: "Perfumes",
                                )),
                            _buildHomeBanners(
                                productList: list9,
                                description: S
                                    .of(context)
                                    .bestWomensSunglassesCollections,
                                heading: S.of(context).womensSunglasses,
                                imagePath: bannerImage9,
                                onClickScreen: CategoryProducts(
                                  category_id: 49,
                                  category_name: "Women's Sunglasses",
                                )),
                            _buildHomeBanners(
                                productList: list10,
                                description:
                                    S.of(context).bestMensSunglassesCollections,
                                heading: S.of(context).mensSunglasses,
                                imagePath: bannerImage10,
                                onClickScreen: CategoryProducts(
                                  category_id: 77,
                                  category_name: "Men's Sunglasses",
                                )),
                            _buildHomeBanners(
                                productList: list11,
                                description:
                                    S.of(context).bestWomensWatchesCollectionss,
                                heading: S.of(context).womensWatches,
                                imagePath: bannerImage11,
                                onClickScreen: CategoryProducts(
                                  category_name: "Women's Watches",
                                  category_id: 50,
                                )),
                            _buildHomeBanners(
                                productList: list12,
                                description:
                                    S.of(context).bestMensWatchesCollections,
                                heading: S.of(context).mensWatches,
                                imagePath: bannerImage12,
                                onClickScreen: CategoryProducts(
                                  category_id: 78,
                                  category_name: "Men's Watches",
                                )),
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
    return sliders.length == 0
        ? Padding(
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
          )
        : SizedBox(
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
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        Timer(Duration(milliseconds: 500), () {
                          setState(() {
                            _current_slider = index;
                          });
                        });
                      }),
                  items: sliders.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: double.infinity,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: AppConfig.BASE_PATH + i.photo.toString(),
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
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: sliders.map((url) {
                        int index = sliders.indexOf(url);
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
    return categoriesList.length == 0
        ? SizedBox(
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
          )
        : SizedBox(
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
                        return HomeCategoryProducts(categoriesList[index]);
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
                                  categoriesList[index].banner,
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
                            categoriesList[index].name,
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
              itemCount: categoriesList.length,
            ),
          );
  }

  buildCategoryProduct(List<Product> productList) {
    return productList.length == 0
        ? Container()
        : SizedBox(
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
                    image: productList[index].thumbnail_image,
                    id: productList[index].id,
                    name: productList[index].name,
                    price: productList[index].stroked_price,
                  ),
                );
              },
              itemCount: productList.length,
            ),
          );
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

  _buildHomeBanners({
    @required Widget onClickScreen,
    @required String imagePath,
    @required String heading,
    @required String description,
    @required List<Product> productList,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) {
                return onClickScreen;
              }));
            },
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: MyTheme.accent_color,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object exception,
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
          heading,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        buildCategoryProduct(productList),
        divider(),
      ],
    );
  }
}
