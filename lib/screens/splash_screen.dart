import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:marekat/helpers/shared_value_helper.dart';
import 'package:marekat/repositories/auth_repository.dart';
import 'package:marekat/screens/main_screen.dart';
import 'package:marekat/screens/offline_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
    );
    navigateToScreens();
    super.initState();
  }

  fetch_user() async {
    var userByTokenResponse = await AuthRepository().getUserByTokenResponse();

    if (userByTokenResponse.result == true) {
      is_logged_in.$ = true;
      user_id.$ = userByTokenResponse.id;
      user_name.$ = userByTokenResponse.name;
      user_email.$ = userByTokenResponse.email;
      user_phone.$ = userByTokenResponse.phone;
      avatar_original.$ = userByTokenResponse.avatar_original;
    }
  }

  navigateToScreens() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isNotFirstTime = preferences.getBool("isNotFirstTime");
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult value,
            Widget child,
          ) {
            if (value == ConnectivityResult.none) {
              return OfflineScreen();
            } else {
              access_token.load().whenComplete(() {
                fetch_user();
              });
              return isNotFirstTime == true ? MainScreen() : IntroScreen();
            }
          },
          builder: (context) =>
              isNotFirstTime == true ? MainScreen() : IntroScreen(),
        );
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            Positioned(
              right: -90,
              top: -150,
              child: SizedBox(
                height: 300,
                child: Image(
                  image: AssetImage("assets/splash_top.png"),
                ),
              ),
            ),
            Positioned(
              left: -70,
              right: -80,
              bottom: -135,
              child: SizedBox(
                child: Image(
                  image: AssetImage("assets/splash_bottom.png"),
                ),
              ),
            ),
            Center(
              child: Image(
                image: AssetImage("assets/splash_logo.jpg"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
