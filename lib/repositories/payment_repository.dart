import 'dart:convert';

import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/data_model/order_create_response.dart';
import 'package:Daemmart/data_model/payment_type_response.dart';
import 'package:Daemmart/data_model/paypal_url_response.dart';
import 'package:Daemmart/data_model/razorpay_payment_success_response.dart';
import 'package:Daemmart/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PaymentRepository {
  Future<List<PaymentTypeResponse>> getPaymentResponseList({mode = ""}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/payment-types?mode=${mode}"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});

    return paymentTypeResponseFromJson(response.body);
  }

  Future<OrderCreateResponse> getOrderCreateResponse(
      @required int owner_id, @required payment_method) async {
    var post_body = jsonEncode({
      "owner_id": "${owner_id}",
      "user_id": "${user_id.$}",
      "payment_type": "${payment_method}"
    });

    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/order/store"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    return orderCreateResponseFromJson(response.body);
  }

  Future<PaypalUrlResponse> getPaypalUrlResponse(@required String payment_type,
      @required int order_id, @required double amount) async {
    final response = await http.get(
        Uri.parse(
            "${AppConfig.BASE_URL}/paypal/payment/url?payment_type=${payment_type}&order_id=${order_id}&amount=${amount}&user_id=${user_id.$}"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});

    print(response.body.toString());
    return paypalUrlResponseFromJson(response.body);
  }

  Future<OrderCreateResponse> getOrderCreateResponseFromWallet(
      @required int owner_id,
      @required payment_method,
      @required double amount) async {
    var post_body = jsonEncode({
      "owner_id": "${owner_id}",
      "user_id": "${user_id.$}",
      "payment_type": "${payment_method}",
      "amount": "${amount}"
    });

    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/payments/pay/wallet"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    return orderCreateResponseFromJson(response.body);
  }

  Future<OrderCreateResponse> getOrderCreateResponseFromCod(
      @required int owner_id, @required payment_method) async {
    var post_body = jsonEncode({
      "owner_id": "${owner_id}",
      "user_id": "${user_id.$}",
      "payment_type": "${payment_method}"
    });

    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/payments/pay/cod"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    //print(response.body.toString());
    return orderCreateResponseFromJson(response.body);
  }

  Future<RazorpayPaymentSuccessResponse>
      getRazorpayPaymentSuccessResponseResponse(
          @required payment_type,
          @required double amount,
          @required int order_id,
          @required String payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "order_id": "${order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/razorpay/success"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    return razorpayPaymentSuccessResponseFromJson(response.body);
  }
}
