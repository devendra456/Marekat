import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:marekat/addon_config.dart';
import 'package:marekat/app_config.dart';
import 'package:marekat/custom/input_decorations.dart';
import 'package:marekat/custom/intl_phone_input.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/auth_repository.dart';
import 'package:marekat/screens/otp.dart';
import 'package:marekat/ui_sections/loader.dart';

import 'login.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _register_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US', dialCode: "+1");

  String _phone = "";

  //controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  onPressSignUp() async {
    var name = _nameController.text.toString();
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();

    if (name == "") {
      ToastComponent.showDialog(
        S.of(context).enterYourName,
      );

      return;
    } else if (_register_by == 'email' && email == "") {
      ToastComponent.showDialog(
        S.of(context).enterEmail,
      );
      return;
    } else if (_register_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
        S.of(context).enterPhoneNumber,
      );
      return;
    } else if (password == "") {
      ToastComponent.showDialog(
        S.of(context).enterPassword,
      );
      return;
    } else if (password_confirm == "") {
      ToastComponent.showDialog(
        S.of(context).confirmYourPassword,
      );
      return;
    } else if (password.length < 6) {
      ToastComponent.showDialog(
        S.of(context).passwordMustContainAtLeast6Characters,
      );
      return;
    } else if (password != password_confirm) {
      ToastComponent.showDialog(
        S.of(context).passwordsDoNotMatch,
      );
      return;
    }

    Loader.showLoaderDialog(context);

    var signupResponse;

    try{
      signupResponse = await AuthRepository().getSignupResponse(
          name,
          _register_by == 'email' ? email : _phone,
          password,
          password_confirm,
          _register_by);
      Loader.dismissDialog(context);
    }catch(e){
      Loader.dismissDialog(context);
    }



    if (signupResponse.result == false) {
      ToastComponent.showDialog(
        signupResponse.message,
      );
    } else {
      ToastComponent.showDialog(
        signupResponse.message,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AddonConfig.otp_addon_installed
            ? Otp(
                verify_by: _register_by,
                user_id: signupResponse.user_id,
              )
            : Login();
      }));
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
                  padding:
                      const EdgeInsets.only(bottom: 0.0, left: 24, right: 24),
                  child: Text(
                    S.of(context).join + " " + AppConfig.app_name,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24.0, bottom: 16, right: 24),
                  child: Text(
                    S
                        .of(context)
                        .signUpWithAppnameSmartStoreToContinuenshoppingHealthyAnd,
                    style: TextStyle(color: MyTheme.dark_grey),
                  ),
                ),
                Container(
                  width: _screen_width,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          S.of(context).name,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 36,
                          child: TextField(
                            controller: _nameController,
                            autofocus: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hintText: S.of(context).johnDoe),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          _register_by == "email" ? "Email" : "Phone",
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (_register_by == "email")
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 36,
                                child: TextField(
                                  controller: _emailController,
                                  autofocus: false,
                                  decoration:
                                      InputDecorations.buildInputDecoration_1(
                                          hintText:
                                              S.of(context).johndoeexamplecom),
                                ),
                              ),
                              /*AddonConfig.otp_addon_installed
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _register_by = "phone";
                                        });
                                      },
                                      child: Text(
                                        S
                                            .of(context)
                                            .orRegisterWithAPhoneNumber,
                                        style: TextStyle(
                                            color: MyTheme.accent_color,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    )
                                  : Container()*/
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
                                  onSaved: (PhoneNumber number) {
                                    //print('On Saved: $number');
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _register_by = "email";
                                  });
                                },
                                child: Text(
                                  S.of(context).orRegisterWithAnEmail,
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
                                autofocus: false,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration:
                                    InputDecorations.buildInputDecoration_1(
                                        hintText: "• • • • • • • •"),
                              ),
                            ),
                            Text(
                              S.of(context).passwordMustBeAtLeast6Character,
                              style: TextStyle(
                                  color: MyTheme.textfield_grey,
                                  fontStyle: FontStyle.italic),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          S.of(context).retypePassword,
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 36,
                          child: TextField(
                            controller: _passwordConfirmController,
                            autofocus: false,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecorations.buildInputDecoration_1(
                                hintText: "• • • • • • • •"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          height: 45,
                          color: MyTheme.accent_color,
                          shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(24.0))),
                          child: Text(
                            S.of(context).signUp,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            onPressSignUp();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).alreadyHaveAnAccount,
                                style: TextStyle(
                                    color: MyTheme.medium_grey, fontSize: 12),
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24.0))),
                                child: Text(
                                  S.of(context).logIn,
                                  style: TextStyle(
                                      color: MyTheme.accent_color,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
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
