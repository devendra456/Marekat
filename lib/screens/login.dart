import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:marekat/addon_config.dart';
import 'package:marekat/app_config.dart';
import 'package:marekat/custom/input_decorations.dart';
import 'package:marekat/custom/intl_phone_input.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/helpers/auth_helper.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/auth_repository.dart';
import 'package:marekat/screens/main_screen.dart';
import 'package:marekat/screens/password_forget.dart';
import 'package:marekat/screens/registration.dart';
import 'package:marekat/ui_sections/loader.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _login_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");
  String _phone = "";

  //controllers
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  onPressedLogin() async {
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();

    if (_login_by == 'email' && email == "") {
      ToastComponent.showDialog(S.of(context).enterEmail);
      return;
    } else if (_login_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
        S.of(context).enterPhoneNumber,
      );
      return;
    } else if (password == "") {
      ToastComponent.showDialog(
        S.of(context).enterPassword,
      );
      return;
    }

    Loader.showLoaderDialog(context);

    var loginResponse = await AuthRepository()
        .getLoginResponse(_login_by == 'email' ? email : _phone, password);

    Loader.dismissDialog(context);

    if (loginResponse.result == false) {
      ToastComponent.showDialog(
        loginResponse.message,
      );
    } else {
      ToastComponent.showDialog(
        loginResponse.message,
      );
      AuthHelper().setUserData(loginResponse);
      /*Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));*/
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (dialogContex) => MainScreen()),
          ModalRoute.withName("/Main"));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .4,
                    height: 140,
                    child:
                        Image.asset('assets/login_registration_form_logo.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 0.0, top: 10, left: 24, right: 24),
                  child: RichText(
                    text: TextSpan(
                        text: "Welcome!",
                        style: TextStyle(
                            color: MyTheme.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(
                            text:
                                "\nLorem Ipsum has been the industry's standard \ndummy text ever since the",
                            style: TextStyle(
                                color: MyTheme.grey_153,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20.0, top: 12, left: 24, right: 24),
                  child: Text(
                    S.of(context).loginTo + " " + AppConfig.app_name,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  width: _screen_width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          _login_by == "email" ? "Email" : "Phone",
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (_login_by == "email")
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 36,
                                child: TextField(
                                  controller: _emailController,
                                  decoration:
                                      InputDecorations.buildInputDecoration_1(
                                          hintText:
                                              S.of(context).johndoeexamplecom),
                                ),
                              ),
                              AddonConfig.otp_addon_installed
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _login_by = "phone";
                                        });
                                      },
                                      child: Text(
                                        S.of(context).orLoginWithAPhoneNumber,
                                        style: TextStyle(
                                            color: MyTheme.accent_color,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 36,
                                child: CustomInternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber number) {
                                    setState(() {
                                      _phone = number.phoneNumber;
                                    });
                                  },
                                  onInputValidated: (bool value) {
                                    print(value);
                                  },
                                  selectorConfig: SelectorConfig(
                                    selectorType: PhoneInputSelectorType.DIALOG,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle:
                                      TextStyle(color: MyTheme.font_grey),
                                  initialValue: phoneCode,
                                  textFieldController: _phoneNumberController,
                                  formatInput: true,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  inputDecoration: InputDecorations
                                      .buildInputDecorationPhone(
                                          hintText: S.of(context).mobHint),
                                  onSaved: (PhoneNumber number) {},
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _login_by = "email";
                                  });
                                },
                                child: Text(
                                  S.of(context).orLoginWithAnEmail,
                                  style: TextStyle(
                                      color: MyTheme.accent_color,
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          S.of(context).password,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 36,
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration:
                                    InputDecorations.buildInputDecoration_1(
                                        hintText: "• • • • • • • •"),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PasswordForget();
                                }));
                              },
                              child: Text(
                                S.of(context).forgotPassword,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: MaterialButton(
                          height: 45,
                          minWidth: MediaQuery.of(context).size.width,
                          shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(24.0))),
                          color: MyTheme.accent_color,
                          onPressed: () {
                            onPressedLogin();
                          },
                          child: Text(
                            S.of(context).logIn,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).orCreateANewAccount,
                              style: TextStyle(
                                  color: MyTheme.medium_grey, fontSize: 12),
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24.0))),
                              child: Text(
                                S.of(context).signUp,
                                style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Registration();
                                }));
                              },
                            ),
                          ],
                        )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
