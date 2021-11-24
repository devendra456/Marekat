import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/screens/category_list.dart';
import 'package:marekat/screens/home.dart';
import 'package:marekat/screens/profile.dart';
import 'package:marekat/screens/wishlist.dart';

import 'cart.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  var _children = [
    Home(),
    CategoryList(
      is_base_category: true,
    ),
    Cart(has_bottomnav: true),
    Wishlist(
      hasBottomNav: true,
    ),
    Profile()
  ];

  void onTapped(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _children[_currentIndex],
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //specify the location of the FAB
      /*floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom ==
            0.0, // if the kyeboard is open then hide, else show
        child: Theme(
          data: Theme.of(context).copyWith(
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              sizeConstraints: BoxConstraints.tightFor(width: 64, height: 64),
            ),
          ),
          child: FloatingActionButton(
            backgroundColor: MyTheme.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Cart(
                    has_bottomnav: false,
                  ); */ /*Filter(
                    selected_filter: "sellers",
                  );*/ /*
                }),
              );
            },
            tooltip: "start FAB",
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 4, color: MyTheme.black),
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/favicon.svg",
                    color: MyTheme.black,
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
            ),
            elevation: 0.0,
          ),
        ),
      ),*/
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        child: BottomAppBar(
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTapped,
            backgroundColor: MyTheme.accent_color,
            currentIndex: _currentIndex,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            elevation: 3,
            items: [
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/home.svg",
                        color: Colors.white,
                        height: 20,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 14,
                        height: 1,
                        color:
                            _currentIndex == 0 ? Colors.white : MyTheme.black,
                      )
                    ],
                  ),
                  label: S.of(context).home),
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Image.asset(
                        "assets/categories.png",
                        color: Colors.white,
                        height: 20,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 14,
                        height: 1,
                        color:
                            _currentIndex == 1 ? Colors.white : MyTheme.black,
                      )
                    ],
                  ),
                  label: S.of(context).categories),
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/favicon.svg",
                        color: MyTheme.white,
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 14,
                        height: 1,
                        color:
                            _currentIndex == 2 ? Colors.white : MyTheme.black,
                      )
                    ],
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      /*SvgPicture.asset(
                        "assets/favicon.svg",
                        color: Colors.white,
                        height: 20,
                      ),*/
                      Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 14,
                        height: 1,
                        color:
                            _currentIndex == 3 ? Colors.white : MyTheme.black,
                      )
                    ],
                  ),
                  label: S.of(context).cart),
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/user.svg",
                        color: Colors.white,
                        height: 20,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 14,
                        height: 1,
                        color:
                            _currentIndex == 4 ? Colors.white : MyTheme.black,
                      )
                    ],
                  ),
                  label: S.of(context).profile),
            ],
          ),
        ),
      ),
    );
  }
}
