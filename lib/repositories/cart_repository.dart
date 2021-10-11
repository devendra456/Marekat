import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:marekat/app_config.dart';
import 'package:marekat/data_model/cart_add_response.dart';
import 'package:marekat/data_model/cart_delete_response.dart';
import 'package:marekat/data_model/cart_process_response.dart';
import 'package:marekat/data_model/cart_response.dart';
import 'package:marekat/data_model/cart_summary_response.dart';
import 'package:marekat/helpers/shared_value_helper.dart';

class CartRepository {
  Future<List<CartResponse>> getCartResponseList(
    int user_id,
  ) async {
    final response = await http.post(
      Uri.parse("${AppConfig.BASE_URL}/carts/$user_id"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}"
      },
    );

    return cartResponseFromJson(response.body);
  }

  Future<CartDeleteResponse> getCartDeleteResponse(
    int cart_id,
  ) async {
    final response = await http.delete(
      Uri.parse("${AppConfig.BASE_URL}/carts/$cart_id"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}"
      },
    );

    return cartDeleteResponseFromJson(response.body);
  }

  Future<CartProcessResponse> getCartProcessResponse(
      String cart_ids, String cart_quantities) async {
    var post_body = jsonEncode(
        {"cart_ids": "${cart_ids}", "cart_quantities": "$cart_quantities"});
    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/carts/process"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    return cartProcessResponseFromJson(response.body);
  }

  Future<CartAddResponse> getCartAddResponse(
      @required int id,
      @required String variant,
      @required int user_id,
      @required int quantity) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "variant": "$variant",
      "user_id": "$user_id",
      "quantity": "$quantity"
    });

    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/carts/add"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    print(response.body.toString());
    return cartAddResponseFromJson(response.body);
  }

  Future<CartSummaryResponse> getCartSummaryResponse(@required owner_id) async {
    final response = await http.get(
      Uri.parse("${AppConfig.BASE_URL}/cart-summary/${user_id.$}/${owner_id}"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}"
      },
    );

    return cartSummaryResponseFromJson(response.body);
  }
}
