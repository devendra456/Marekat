import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:marekat/data_model/address_add_response.dart';
import 'package:marekat/data_model/address_delete_response.dart';
import 'package:marekat/data_model/address_make_default_response.dart';
import 'package:marekat/data_model/address_response.dart';
import 'package:marekat/data_model/address_update_in_cart_response.dart';
import 'package:marekat/data_model/address_update_response.dart';
import 'package:marekat/data_model/city_response.dart';
import 'package:marekat/data_model/country_response.dart';
import 'package:marekat/data_model/shipping_cost_response.dart';
import 'package:marekat/helpers/shared_value_helper.dart';

import '../app_config.dart';

class AddressRepository {
  Future<AddressResponse> getAddressList() async {
    final response = await http.get(
      Uri.parse("${AppConfig.BASE_URL}/user/shipping/address/${user_id.$}"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Content-Type": "application/json",
        "Authorization": "Bearer"
            " ${access_token.$}"
      },
    );
    return addressResponseFromJson(response.body);
  }

  Future<AddressAddResponse> getAddressAddResponse(String address,
      String country, String city, String postal_code, String phone) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "address": "$address",
      "country": "$country",
      "city": "$city",
      "postal_code": "$postal_code",
      "phone": "$phone"
    });
    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/user/shipping/create"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    return addressAddResponseFromJson(response.body);
  }

  Future<AddressUpdateResponse> getAddressUpdateResponse(int id, String address,
      String country, String city, String postal_code, String phone) async {
    var post_body = jsonEncode({
      "id": "$id",
      "user_id": "${user_id.$}",
      "address": "$address",
      "country": "$country",
      "city": "$city",
      "postal_code": "$postal_code",
      "phone": "$phone"
    });
    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/user/shipping/update"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    return addressUpdateResponseFromJson(response.body);
  }

  Future<AddressMakeDefaultResponse> getAddressMakeDefaultResponse(
    int id,
  ) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "id": "$id",
    });
    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/user/shipping/make_default"),
        headers: {
          "X-localization": langCode.$ == "ar" ? "sa" : "en",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    return addressMakeDefaultResponseFromJson(response.body);
  }

  Future<AddressDeleteResponse> getAddressDeleteResponse(
    int id,
  ) async {
    final response = await http.get(
      Uri.parse("${AppConfig.BASE_URL}/user/shipping/delete/$id"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Authorization": "Bearer ${access_token.$}"
      },
    );

    return addressDeleteResponseFromJson(response.body);
  }

  Future<CityResponse> getCityList() async {
    final response = await http.get(Uri.parse("${AppConfig.BASE_URL}/cities"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});

    return cityResponseFromJson(response.body);
  }

  Future<CountryResponse> getCountryList() async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/countries"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return countryResponseFromJson(response.body);
  }

  Future<ShippingCostResponse> getShippingCostResponse(
      int owner_id, int user_id, String city_name) async {
    var post_body = jsonEncode({
      "owner_id": "${owner_id}",
      "user_id": "$user_id",
      "city_name": "$city_name"
    });
    final response =
        await http.post(Uri.parse("${AppConfig.BASE_URL}/shipping_cost"),
            headers: {
              "X-localization": langCode.$ == "ar" ? "sa" : "en",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${access_token.$}"
            },
            body: post_body);

    return shippingCostResponseFromJson(response.body);
  }

  Future<AddressUpdateInCartResponse> getAddressUpdateInCartResponse(
    int address_id,
  ) async {
    var post_body =
        jsonEncode({"address_id": "${address_id}", "user_id": "${user_id.$}"});
    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/update-address-in-cart"),
        headers: {
          "X-localization": langCode.$ == "ar" ? "sa" : "en",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    return addressUpdateInCartResponseFromJson(response.body);
  }
}
