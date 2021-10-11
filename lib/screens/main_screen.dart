import 'dart:ui';

import 'package:Daemmart/generated/l10n.dart';
import 'package:Daemmart/my_theme.dart';
import 'package:Daemmart/screens/cart.dart';
import 'package:Daemmart/screens/category_list.dart';
import 'package:Daemmart/screens/home.dart';
import 'package:Daemmart/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'filter.dart';

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
    Home(),
    Cart(has_bottomnav: true),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //specify the location of the FAB
      floatingActionButton: Visibility(
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
                  return Filter(
                    selected_filter: "sellers",
                  );
                }),
              );
            },
            tooltip: "start FAB",
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 4, color: MyTheme.green),
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/favicon.svg",
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
            ),
            elevation: 0.0,
          ),
        ),
      ),
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
            backgroundColor: MyTheme.green,
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
                            _currentIndex == 0 ? Colors.white : MyTheme.green,
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
                            _currentIndex == 1 ? Colors.white : MyTheme.green,
                      )
                    ],
                  ),
                  label: S.of(context).categories),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.circle,
                    color: Colors.transparent,
                  ),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      SvgPicture.asset(
                        "assets/cart.svg",
                        height: 20,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 14,
                        height: 1,
                        color:
                            _currentIndex == 3 ? Colors.white : MyTheme.green,
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
                            _currentIndex == 4 ? Colors.white : MyTheme.green,
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

/*BottomAppBar(
        clipBehavior: Clip.antiAlias,
        color: Color.fromARGB(255, 0, 177, 103),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTapped,
            currentIndex: _currentIndex,
            backgroundColor: Color.fromARGB(238, 252, 249, 245),
            fixedColor: Theme.of(context).accentColor,
            unselectedItemColor: Color.fromRGBO(153, 153, 153, 1),
            elevation: 3,
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/home.svg",
                    color: _currentIndex == 0 ? Theme.of(context).accentColor : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      S.of(context).home,
                      style: TextStyle(fontSize: 12),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    "assets/categories.png",
                    color: _currentIndex == 1 ? Theme.of(context).accentColor : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      S.of(context).categories,
                      style: TextStyle(fontSize: 12),
                    ),
                  )),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.circle,
                  color: Colors.transparent,
                ),
                title: Text(""),
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/cart.svg",
                    color: _currentIndex == 3 ? Theme.of(context).accentColor : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      S.of(context).cart,
                      style: TextStyle(fontSize: 12),
                    ),
                  )),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/user.svg",
                    color: _currentIndex == 4 ? Theme.of(context).accentColor : Color.fromRGBO(153, 153, 153, 1),
                    height: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      S.of(context).profile,
                      style: TextStyle(fontSize: 12),
                    ),
                  )),
            ],
          ),
        ),
      ),



      Container(
              margin: EdgeInsets.all(0.0),
              child: IconButton(
                  icon: /* SvgPicture.asset(
                    "assets/square_logo.svg",
                    color: MyTheme.white,
                  ),*/
                      Image.asset(
                    'assets/favicon.png',
                    color: MyTheme.white,
                  ),
                  tooltip: 'Action',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Filter(
                        selected_filter: "sellers",
                      );
                    }));
                  })),

      */
