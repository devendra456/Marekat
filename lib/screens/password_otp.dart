import 'package:flutter/material.dart';
import 'package:marekat/custom/input_decorations.dart';
import 'package:marekat/custom/toast_component.dart';
import 'package:marekat/generated/l10n.dart';
import 'package:marekat/my_theme.dart';
import 'package:marekat/repositories/auth_repository.dart';
import 'package:marekat/screens/login.dart';

class PasswordOtp extends StatefulWidget {
  PasswordOtp({Key key, this.verify_by = "email", this.email_or_code})
      : super(key: key);
  final String verify_by;
  final String email_or_code;

  @override
  _PasswordOtpState createState() => _PasswordOtpState();
}

class _PasswordOtpState extends State<PasswordOtp> {
  //controllers
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  onPressConfirm() async {
    var code = _codeController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();

    if (code == "") {
      ToastComponent.showDialog(
        S.of(context).enterTheCode,
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

    var passwordConfirmResponse =
        await AuthRepository().getPasswordConfirmResponse(code, password);

    if (passwordConfirmResponse.result == false) {
      ToastComponent.showDialog(
        passwordConfirmResponse.message,
      );
    } else {
      ToastComponent.showDialog(
        passwordConfirmResponse.message,
      );

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Login();
      }));
    }
  }

  onTapResend() async {
    var passwordResendCodeResponse = await AuthRepository()
        .getPasswordResendCodeResponse(widget.email_or_code, widget.verify_by);

    if (passwordResendCodeResponse.result == false) {
      ToastComponent.showDialog(
        passwordResendCodeResponse.message,
      );
    } else {
      ToastComponent.showDialog(
        passwordResendCodeResponse.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String _verify_by = widget.verify_by; //phone or email
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
                  padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                  child: Container(
                    width: _screen_width * (2 / 3),
                    child:
                        Image.asset('assets/login_registration_form_logo.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    S.of(context).enterTheCodeSent,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                      width: _screen_width * (3 / 4),
                      child: _verify_by == "email"
                          ? Text(
                              S
                                  .of(context)
                                  .enterTheVerificationCodeThatSentToYourEmailRecently,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyTheme.dark_grey, fontSize: 14))
                          : Text(
                              S
                                  .of(context)
                                  .enterTheVerificationCodeThatSentToYourPhoneRecently,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyTheme.dark_grey, fontSize: 14))),
                ),
                Container(
                  width: _screen_width * (3 / 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 36,
                              child: TextField(
                                controller: _codeController,
                                autofocus: false,
                                decoration:
                                    InputDecorations.buildInputDecoration_1(
                                        hintText: "A X B 4 J H"),
                              ),
                            ),
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
                              S.of(context).confirm,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            onPressed: () {
                              onPressConfirm();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: InkWell(
                    onTap: () {
                      onTapResend();
                    },
                    child: Text(S.of(context).resendCode,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            decoration: TextDecoration.underline,
                            fontSize: 13)),
                  ),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }
}
