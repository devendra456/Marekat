import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:marekat/app_config.dart';
import 'package:marekat/data_model/product_mini_response.dart';
import 'package:marekat/data_model/shop_details_response.dart';
import 'package:marekat/data_model/shop_response.dart';
import 'package:marekat/helpers/shared_value_helper.dart';

class ShopRepository {
  Future<ShopResponse> getShops({name = "", page = 1}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/shops" + "?page=${page}&name=${name}"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return shopResponseFromJson(response.body);
  }

  Future<ShopDetailsResponse> getShopInfo({@required id = 0}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/shops/details/${id}"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return shopDetailsResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts({int id = 0}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/shops/products/top/" + id.toString()),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getNewFromThisSellerProducts({int id = 0}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/shops/products/new/" + id.toString()),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getfeaturedFromThisSellerProducts(
      {int id = 0}) async {
    final response = await http.get(
        Uri.parse(
            "${AppConfig.BASE_URL}/shops/products/featured/" + id.toString()),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }
}
