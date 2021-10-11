import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:marekat/app_config.dart';
import 'package:marekat/data_model/coupon_apply_response.dart';
import 'package:marekat/data_model/coupon_remove_response.dart';
import 'package:marekat/helpers/shared_value_helper.dart';

class CouponRepository {
  Future<CouponApplyResponse> getCouponApplyResponse(
      @required int owner_id, @required String coupon_code) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "owner_id": "$owner_id",
      "coupon_code": "$coupon_code"
    });
    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/coupon-apply"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    return couponApplyResponseFromJson(response.body);
  }

  Future<CouponRemoveResponse> getCouponRemoveResponse(
      @required int owner_id) async {
    var post_body =
        jsonEncode({"user_id": "${user_id.$}", "owner_id": "$owner_id"});
    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/coupon-remove"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    return couponRemoveResponseFromJson(response.body);
  }
}
