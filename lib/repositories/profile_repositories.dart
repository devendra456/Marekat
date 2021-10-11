import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:marekat/app_config.dart';
import 'package:marekat/data_model/profile_counters_response.dart';
import 'package:marekat/data_model/profile_image_update_response.dart';
import 'package:marekat/data_model/profile_update_response.dart';
import 'package:marekat/helpers/shared_value_helper.dart';

class ProfileRepository {
  Future<ProfileCountersResponse> getProfileCountersResponse() async {
    final response = await http.get(
      Uri.parse("${AppConfig.BASE_URL}/profile/counters/${user_id.$}"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Authorization": "Bearer ${access_token.$}"
      },
    );
    return profileCountersResponseFromJson(response.body);
  }

  Future<ProfileUpdateResponse> getProfileUpdateResponse(
      @required String name, @required String password) async {
    var post_body = jsonEncode(
        {"id": "${user_id.$}", "name": "${name}", "password": "$password"});

    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/profile/update"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    return profileUpdateResponseFromJson(response.body);
  }

  Future<ProfileImageUpdateResponse> getProfileImageUpdateResponse(
      @required String image, @required String filename) async {
    var post_body = jsonEncode(
        {"id": "${user_id.$}", "image": "${image}", "filename": "$filename"});
    //print(post_body.toString());

    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/profile/update-image"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    return profileImageUpdateResponseFromJson(response.body);
  }
}
