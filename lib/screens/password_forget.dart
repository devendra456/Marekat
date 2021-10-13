import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:marekat/addon_config.dart';
import 'package:marekat/custom/input_decorations.dart';
import 'package:marekat/custom/intl_phone_input.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/auth_repository.dart';
import 'package:marekat/screens/password_otp.dart';

class PasswordForget extends StatefulWidget {
  @override
  _PasswordForgetState createState() => _PasswordForgetState();
}

class _PasswordForgetState extends State<PasswordForget> {
  String _send_code_by = "email"; //phone or email
  String initialCountry = 'US';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'US');
  String _phone = "";

  //controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  onPressSendCode() async {
    var email = _emailController.text.toString();

    if (_send_code_by == 'email' && email == "") {
      ToastComponent.showDialog(
        S.of(context).enterEmail,
      );
      return;
    } else if (_send_code_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
        S.of(context).enterPhoneNumber,
      );
      return;
    }

    var passwordForgetResponse = await AuthRepository()
        .getPasswordForgetResponse(
            _send_code_by == 'email' ? email : _phone, _send_code_by);

    if (passwordForgetResponse.result == false) {
      ToastComponent.showDialog(
        passwordForgetResponse.message,
      );
    } else {
      ToastComponent.showDialog(
        passwordForgetResponse.message,
      );

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PasswordOtp(
          verify_by: _send_code_by,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: _screen_width * (3 / 4),
            child: Image.asset(
                "assets/splash_login_registration_background_image.png"),
          ),
          Container(
            width: double.infinity,
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 64.0, bottom: 15),
                  child: Container(
                    width: _screen_width * .4,
                    child:
                        Image.asset('assets/login_registration_form_logo.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    S.of(context).forgetPassword,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  width: _screen_width * (3 / 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          _send_code_by == "email" ? "Email" : "Phone",
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (_send_code_by == "email")
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
                              AddonConfig.otp_addon_installed
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _send_code_by = "phone";
                                        });
                                      },
                                      child: Text(
                                        S.of(context).orSendCodeViaPhoneNumber,
                                        style: TextStyle(
                                            color: MyTheme.accent_color,
                                            fontStyle: FontStyle.italic,
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
                                          hintText: "01710 333 558"),
                                  onSaved: (PhoneNumber number) {},
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _send_code_by = "email";
                                  });
                                },
                                child: Text(
                                  S.of(context).orSendCodeViaEmail,
                                  style: TextStyle(
                                      color: MyTheme.accent_color,
                                      fontStyle: FontStyle.italic,
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyTheme.textfield_grey, width: 1),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            //height: 50,
                            color: MyTheme.accent_color,
                            shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(11.0))),
                            child: Text(
                              S.of(context).sendCode,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              onPressSendCode();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
          )
        ],
      ),
    );
  }
}
