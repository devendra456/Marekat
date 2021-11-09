import 'dart:async';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marekat/app_config.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/data_model/brand_response.dart';
import 'package:marekat/data_model/category_response.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/shimmer_helper.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/brand_repository.dart';
import 'package:marekat/repositories/category_repository.dart';
import 'package:marekat/repositories/product_repository.dart';
import 'package:marekat/repositories/sliders_repository.dart';
import 'package:marekat/screens/category_list.dart';
import 'package:marekat/screens/home_category_products.dart';
import 'package:marekat/screens/main_screen.dart';
import 'package:marekat/screens/todays_deal_products.dart';
import 'package:marekat/screens/top_selling_products.dart';
import 'package:marekat/ui_elements/product_card.dart';
import 'package:marekat/ui_sections/main_drawer.dart';
import 'package:shimmer/shimmer.dart';

import 'brand_products.dart';
import 'filter.dart';
import 'flash_deal_list.dart';

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
  ScrollController _featuredProductScrollController;

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
                            child: Image.network(
                              "https://demo.marekat.com/public/uploads/all/"
                              "mT97RVRjqnv7w0rBMwH4qSxIApL3YhTUy8Gk8eiA"
                              ".jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          16.0,
                          16.0,
                          0.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).feature_categories,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: MyTheme.accent_color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            0.0,
                            4.0,
                            0.0,
                            0.0,
                          ),
                          child: SizedBox(
                            height: 164,
                            child: buildHomeFeaturedCategories(context),
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        SizedBox(
                          height: 250,
                          child: Image.network(
                            "https://demo.marekat.com/public/uploads/all/V9"
                            "jNUWSRI3EEGhPOJojadCShDRV6xwpklN84ph6X.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          16.0,
                          16.0,
                          0.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).products,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: MyTheme.accent_color),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                4.0,
                                0.0,
                                4.0,
                                0.0,
                              ),
                              child: buildHomeFeaturedProducts(context),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 275,
                              child: Image.network(
                                "https://demo.marekat.com/public/uploads"
                                "/all/ziGlq4gl7xvgUUpGx"
                                "O7ok71DbJx1ZuA4dfJmuWHt.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                S.of(context).topTenBrands,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: MyTheme.accent_color,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
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
            return GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 1),
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
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        width: 0.3,
                        color: Color.fromARGB(255, 221, 221, 221),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
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

  buildHomeFeaturedProducts(context) {
    return FutureBuilder(
        future: ProductRepository().getFeaturedProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            var featuredProductResponse = snapshot.data;
            return GridView.builder(
              itemCount: featuredProductResponse.products.length,
              controller: _featuredProductScrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.52),
              padding: EdgeInsets.all(8),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ProductCard(
                  id: featuredProductResponse.products[index].id,
                  image:
                      featuredProductResponse.products[index].thumbnail_image,
                  name: featuredProductResponse.products[index].name,
                  price: featuredProductResponse.products[index].stroked_price,
                );
              },
            );
          } else {
            return ShimmerHelper().buildProductGridShimmer(
                scontroller: _featuredProductScrollController);
          }
        });
  }

  buildHomeFeaturedCategories(context) {
    return FutureBuilder(
        future: CategoryRepository().getFeturedCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            //snapshot.hasData
            var featuredCategoryResponse = snapshot.data;
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featuredCategoryResponse.categories.length,
                itemExtent: 125,
                controller: _scrollController,
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 8, right: 8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: GestureDetector(
                      onTap: () {
                        if (featuredCategoryResponse
                                .categories[index].number_of_children >
                            0) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CategoryList(
                              parent_category_name: featuredCategoryResponse
                                  .categories[index].name,
                              parent_category_id:
                                  featuredCategoryResponse.categories[index].id,
                            );
                          }));
                        } else {
                          ToastComponent.showDialog(
                            S.of(context).noSubCategoriesAvailable,
                          );
                        }
                      },
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Color.fromARGB(255, 232, 232, 232),
                              width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 1.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: double.infinity,
                                height: 100,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(8),
                                        bottom: Radius.zero),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'assets/placeholder.png',
                                      image: AppConfig.BASE_PATH +
                                          featuredCategoryResponse
                                              .categories[index].banner,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace stackTrace) {
                                        return Image.asset(
                                          "assets/placeholder.png",
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ))),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, top: 8),
                              child: Divider(
                                color: MyTheme.black.withOpacity(0.1),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                              child: Container(
                                height: 28,
                                child: Text(
                                  featuredCategoryResponse
                                      .categories[index].name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 11, color: MyTheme.font_grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ShimmerHelper().buildBasicShimmer(
                        height: 120.0,
                        width: (MediaQuery.of(context).size.width - 32) / 3)),
                Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ShimmerHelper().buildBasicShimmer(
                        height: 120.0,
                        width: (MediaQuery.of(context).size.width - 32) / 3)),
                Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: ShimmerHelper().buildBasicShimmer(
                        height: 120.0,
                        width: (MediaQuery.of(context).size.width - 32) / 3)),
              ],
            );
          }
        });
  }

  buildHomeMenuRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CategoryList(
                is_top_category: true,
              );
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                  height: 57,
                  width: 57,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(
                        Radius.circular(28),
                      ),
                      border: Border.all(color: MyTheme.light_grey, width: 1),
                      color: Color.fromARGB(255, 248, 252, 255)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset("assets/top_categories.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    S.of(context).top_categories,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(132, 132, 132, 1),
                        fontWeight: FontWeight.w300),
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Filter(
                selected_filter: "brands",
              );
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      border: Border.all(color: MyTheme.light_grey, width: 1),
                      color: Color.fromARGB(255, 248, 252, 255),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset("assets/brands.png"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text(S.of(context).brands,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(132, 132, 132, 1),
                              fontWeight: FontWeight.w300)),
                    )),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TopSellingProducts();
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      border: Border.all(color: MyTheme.light_grey, width: 1),
                      color: Color.fromARGB(255, 248, 252, 255),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset("assets/top_sellers.png"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(S.of(context).top_sellers,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300))),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TodaysDealProducts();
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      border: Border.all(color: MyTheme.light_grey, width: 1),
                      color: Color.fromARGB(255, 248, 252, 255),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset("assets/todays_deal.png"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(S.of(context).today_deal,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300))),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FlashDealList();
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                      border: Border.all(color: MyTheme.light_grey, width: 1),
                      color: Color.fromARGB(255, 248, 252, 255),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset("assets/flash_deal.png"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(S.of(context).flash_deal,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300))),
              ],
            ),
          ),
        )
      ],
    );
  }

  buildHomeCarouselSlider(context) {
    return FutureBuilder(
        future: SlidersRepository().getSliders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
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

  ScrollController _scrollController;
  GlobalKey globalKey;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    globalKey = GlobalKey();
  }

  Future<void> _onRefresh() async {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => MainScreen(),
      ),
    );
    setState(() {});
  }

  buildHomeCategory() {
    return FutureBuilder(
        future: CategoryRepository().getCategories(parent_id: 0),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (snapshot.hasData) {
            var categoryResponse = snapshot.data as CategoryResponse;
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
}
