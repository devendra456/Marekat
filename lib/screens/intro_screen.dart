import 'package:Daemmart/my_theme.dart';
import 'package:Daemmart/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  var _pages = [
    PageVew1(),
    PageView2(),
  ];

  PageController _pageViewController;

  int _selectedIndex = 0;

  @override
  void initState() {
    _pageViewController = PageController(initialPage: 0);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    setFirstTimeValue();
    super.initState();
  }

  setFirstTimeValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isNotFirstTime", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: AssetImage("assets/intro_back.png"),
            fit: BoxFit.fill,
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .73,
                child: PageView(
                  children: _pages,
                  physics: BouncingScrollPhysics(),
                  controller: _pageViewController,
                  onPageChanged: (value) {
                    setState(() {
                      _selectedIndex = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .27,
                child: Column(
                  children: [
                    SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      height: 8,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: _selectedIndex == index
                                  ? MyTheme.accent_color
                                  : MyTheme.light_grey,
                            ),
                          );
                        },
                        itemCount: _pages.length,
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .80,
                      height: 44,
                      child: MaterialButton(
                        onPressed: () {
                          if (_selectedIndex < _pages.length - 1) {
                            setState(() {
                              _selectedIndex++;
                            });
                            _pageViewController.animateToPage(
                              _selectedIndex,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linear,
                            );
                          } else {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return MainScreen();
                            }));
                          }
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        color: MyTheme.accent_color,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                      ),
                    ),
                    Spacer()
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class PageView2 extends StatelessWidget {
  const PageView2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Image(
          image: AssetImage("assets/intro_image2.png"),
          height: 200,
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          "Shop your daily",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyTheme.black.withAlpha(180),
          ),
        ),
        Text(
          "Necessary",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MyTheme.black.withAlpha(180),
          ),
        ),
        Spacer(),
        Text(
          "Lorem Ipsum has been the industry's standard\n"
          "dummy text ever since the 1500s, when an\n"
          "unknown printer",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: MyTheme.dark_grey),
        ),
      ],
    );
  }
}

class PageVew1 extends StatelessWidget {
  const PageVew1({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Image(
          image: AssetImage("assets/intro_image1.png"),
          height: 200,
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          "Welcome to Daemmart!",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyTheme.black.withAlpha(180),
          ),
        ),
        Text(
          "New Organic Items",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MyTheme.black.withAlpha(180),
          ),
        ),
        Spacer(),
        Text(
          "Lorem Ipsum has been the industry's standard\n"
          "dummy text ever since the 1500s, when an\n"
          "unknown printer",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: MyTheme.dark_grey),
        ),
      ],
    );
  }
}
