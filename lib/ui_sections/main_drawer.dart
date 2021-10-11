import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/generated/l10n.dart';
import 'package:Daemmart/helpers/auth_helper.dart';
import 'package:Daemmart/helpers/shared_value_helper.dart';
import 'package:Daemmart/my_theme.dart';
import 'package:Daemmart/screens/login.dart';
import 'package:Daemmart/screens/main_screen.dart';
import 'package:Daemmart/screens/order_list.dart';
import 'package:Daemmart/screens/profile.dart';
import 'package:Daemmart/screens/wallet.dart';
import 'package:Daemmart/screens/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool isSwitched = false;

  @override
  void initState() {
    getLang();
    super.initState();
  }

  onTapLogout(context) async {
    AuthHelper().clearUserData();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (dialogContext) => Login()),
        ModalRoute.withName("/Login"));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              is_logged_in.$ == true
                  ? ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          AppConfig.BASE_PATH + "${avatar_original.$}",
                        ),
                      ),
                      title: Text(
                        "${user_name.$}",
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: user_email.$ != "" && user_email.$ != null
                          ? Text(
                              "${user_email.$}",
                              style: TextStyle(fontSize: 14),
                            )
                          : Text(
                              "${user_phone.$}",
                              style: TextStyle(fontSize: 14),
                            ))
                  : Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: MyTheme.accent_color,
                            child: SvgPicture.asset(
                              "assets/user.svg",
                              height: 12,
                              width: 12,
                              color: MyTheme.white,
                            ),
                          ),
                        ),
                        Text(
                          S.of(context).youAreNotLoggedIn,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                      ],
                    ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  leading: Container(
                      height: 18,
                      width: 18,
                      child: SvgPicture.asset(
                        "assets/home.svg",
                        color: Color.fromRGBO(153, 153, 153, 1),
                      )),
                  title: Text(S.of(context).home,
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (dialogContex) => MainScreen()),
                        ModalRoute.withName("/Main"));
                  }),
              is_logged_in.$ == true
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Container(
                        height: 18,
                        width: 18,
                        child: SvgPicture.asset(
                          "assets/user.svg",
                          color: Color.fromRGBO(153, 153, 153, 1),
                        ),
                      ),
                      title: Text(S.of(context).profile,
                          style: TextStyle(
                              color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: 16)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Profile(show_back_button: true);
                        }));
                      })
                  : Container(),
              is_logged_in.$ == true
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset("assets/order.png",
                          height: 18, color: Color.fromRGBO(153, 153, 153, 1)),
                      title: Text(S.of(context).orders,
                          style: TextStyle(
                              color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: 16)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return OrderList(from_checkout: false);
                        }));
                      })
                  : Container(),
              is_logged_in.$ == true
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset("assets/heart.png",
                          height: 18, color: Color.fromRGBO(153, 153, 153, 1)),
                      title: Text(S.of(context).myWishlist,
                          style: TextStyle(
                              color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: 16)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Wishlist();
                        }));
                      })
                  : Container(),
              is_logged_in.$ == true
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset("assets/wallet.png",
                          height: 18, color: Color.fromRGBO(153, 153, 153, 1)),
                      title: Text(S.of(context).wallet,
                          style: TextStyle(
                              color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: 16)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Wallet();
                        }));
                      })
                  : Container(),
              Divider(height: 24),
              is_logged_in.$ == false
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset("assets/login.png",
                          height: 18, color: Color.fromRGBO(153, 153, 153, 1)),
                      title: Text(S.of(context).login,
                          style: TextStyle(
                              color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: 16)),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Login();
                        }));
                      })
                  : Container(),
              is_logged_in.$ == true
                  ? ListTile(
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      leading: Image.asset("assets/logout.png",
                          height: 18, color: Color.fromRGBO(153, 153, 153, 1)),
                      title: Text(S.of(context).logout,
                          style: TextStyle(
                              color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: 16)),
                      onTap: () {
                        //onTapLogout(context);
                        _showMyDialog();
                      })
                  : Container(),
              Divider(),
              ListTile(
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                leading: Container(
                    height: 22,
                    width: 22,
                    child: SvgPicture.asset("assets/language_icon.svg")),
                title: Container(
                  child: Row(
                    children: [
                      Text(
                        "En",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Switch(
                        value: isSwitched,
                        onChanged: toggleSwitch,
                        activeColor: Color.fromARGB(255, 248, 152, 28),
                        activeTrackColor: Color.fromARGB(119, 248, 152, 28),
                        inactiveThumbColor: Color.fromARGB(255, 148, 15, 124),
                        inactiveTrackColor: Color.fromARGB(119, 148, 15, 124),
                      ),
                      Text(
                        "ص",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        setLang("ar");
      }); /*
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (dialogContext) => MyApp()),
          ModalRoute.withName("/MyApp"));*/
      Phoenix.rebirth(context);
    } else {
      setState(() {
        isSwitched = false;
        setLang("en");
      });
      /*Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (dialogContext) => MyApp()),
          ModalRoute.withName("/MyApp"));*/

      Phoenix.rebirth(context);
    }
  }

  void setLang(String lang) async {
    SharedPreferences prefer = await SharedPreferences.getInstance();
    prefer.setString("lang", lang).then((value) => print(lang));
  }

  void getLang() async {
    SharedPreferences prefer = await SharedPreferences.getInstance();
    var langCode = prefer.getString("lang");
    switch (langCode) {
      case "ar":
        setState(() {
          isSwitched = true;
        });
        break;
      case "en":
        setState(() {
          isSwitched = false;
        });
        break;
      default:
        setState(() {
          isSwitched = false;
        });
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 0),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                //Icon(Icons.logout),
                Text(S.of(context).areYouSureWantToLogout),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).confirm),
              onPressed: () {
                onTapLogout(context);
                //Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
