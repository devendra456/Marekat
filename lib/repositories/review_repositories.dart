import 'dart:convert';

import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/data_model/review_response.dart';
import 'package:Daemmart/data_model/review_submit_response.dart';
import 'package:Daemmart/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ReviewRepository {
  Future<ReviewResponse> getReviewResponse(@required int product_id,
      {page = 1}) async {
    final response = await http.get(
      Uri.parse(
          "${AppConfig.BASE_URL}/reviews/product/${product_id}?page=${page}"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}"
      },
    );
    return reviewResponseFromJson(response.body);
  }

  Future<ReviewSubmitResponse> getReviewSubmitResponse(
    @required int product_id,
    @required int rating,
    @required String comment,
  ) async {
    var post_body = jsonEncode({
      "product_id": "${product_id}",
      "user_id": "${user_id.$}",
      "rating": "$rating",
      "comment": "$comment"
    });
    print(post_body.toString());
    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/reviews/submit"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    return reviewSubmitResponseFromJson(response.body);
  }
}
