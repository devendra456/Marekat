import 'package:Daemmart/custom/toast_component.dart';
import 'package:Daemmart/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: AssetImage("assets/intro_back.png"),
            fit: BoxFit.fill,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .3,
                  width: MediaQuery.of(context).size.width * .9,
                  child: SvgPicture.asset("assets/offline.svg"),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Oops!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.accent_color,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "No internet connection found",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Check your Internet connection\nor WiFi",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 32,
                ),
                MaterialButton(
                  onPressed: () {
                    ToastComponent.showDialog("You are offline");
                  },
                  child: Text(
                    "Retry",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  minWidth: 104,
                  height: 40,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
                  color: MyTheme.accent_color,
                  textColor: MyTheme.white,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
