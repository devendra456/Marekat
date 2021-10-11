import 'dart:convert';

import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/data_model/confirm_code_response.dart';
import 'package:Daemmart/data_model/login_response.dart';
import 'package:Daemmart/data_model/logout_response.dart';
import 'package:Daemmart/data_model/password_confirm_response.dart';
import 'package:Daemmart/data_model/password_forget_response.dart';
import 'package:Daemmart/data_model/resend_code_response.dart';
import 'package:Daemmart/data_model/signup_response.dart';
import 'package:Daemmart/data_model/user_by_token.dart';
import 'package:Daemmart/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  Future<LoginResponse> getLoginResponse(String email, String password) async {
    var post_body = jsonEncode({"email": "${email}", "password": "$password"});

    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/auth/login"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json"
            },
            body: post_body);
    return loginResponseFromJson(response.body);
  }

  Future<LogoutResponse> getLogoutResponse() async {
    final response = await http.get(
      Uri.parse("${AppConfig.BASE_URL}/auth/logout"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Authorization": "Bearer ${access_token.$}"
      },
    );

    return logoutResponseFromJson(response.body);
  }

  Future<SignupResponse> getSignupResponse(String name, String email_or_phone,
      String password, String passowrd_confirmation, String register_by) async {
    var post_body = jsonEncode({
      "name": "$name",
      "email_or_phone": "${email_or_phone}",
      "password": "$password",
      "password_confirmation": "${passowrd_confirmation}",
      "register_by": "$register_by"
    });

    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/auth/signup"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json"
            },
            body: post_body);

    return signupResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getResendCodeResponse(
      int user_id, String verify_by) async {
    var post_body =
        jsonEncode({"user_id": "$user_id", "register_by": "$verify_by"});

    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/auth/resend_code"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json"
            },
            body: post_body);

    return resendCodeResponseFromJson(response.body);
  }

  Future<ConfirmCodeResponse> getConfirmCodeResponse(
      int user_id, String verification_code) async {
    var post_body = jsonEncode(
        {"user_id": "$user_id", "verification_code": "$verification_code"});

    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/auth/confirm_code"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json"
            },
            body: post_body);

    return confirmCodeResponseFromJson(response.body);
  }

  Future<PasswordForgetResponse> getPasswordForgetResponse(
      String email_or_phone, String send_code_by) async {
    var post_body = jsonEncode(
        {"email_or_phone": "$email_or_phone", "send_code_by": "$send_code_by"});

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/auth/password/forget_request"),
        headers: {
          "X-localization": langCode.$ == "ar" ? "sa" : "en",
          "Content-Type": "application/json"
        },
        body: post_body);

    //print(response.body.toString());

    return passwordForgetResponseFromJson(response.body);
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      String verification_code, String password) async {
    var post_body = jsonEncode(
        {"verification_code": "$verification_code", "password": "$password"});

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/auth/password/confirm_reset"),
        headers: {
          "X-localization": langCode.$ == "ar" ? "sa" : "en",
          "Content-Type": "application/json"
        },
        body: post_body);

    return passwordConfirmResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      String email_or_code, String verify_by) async {
    var post_body = jsonEncode(
        {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/auth/password/resend_code"),
        headers: {
          "X-localization": langCode.$ == "ar" ? "sa" : "en",
          "Content-Type": "application/json"
        },
        body: post_body);

    return resendCodeResponseFromJson(response.body);
  }

  Future<UserByTokenResponse> getUserByTokenResponse() async {
    var post_body = jsonEncode({"access_token": "${access_token.$}"});

    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/get-user-by-access_token"),
        headers: {
          "X-localization": langCode.$ == "ar" ? "sa" : "en",
          "Content-Type": "application/json"
        },
        body: post_body);

    return userByTokenResponseFromJson(response.body);
  }
}
