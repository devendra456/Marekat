import 'package:http/http.dart' as http;
import 'package:marekat/app_config.dart';
import 'package:marekat/data_model/brand_response.dart';
import 'package:marekat/data_model/color_filter_model.dart';
import 'package:marekat/helpers/shared_value_helper.dart';

class BrandRepository {
  Future<BrandResponse> getFilterPageBrands() async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/filter/brands"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return brandResponseFromJson(response.body);
  }

  Future<BrandResponse> getFilterBrands(int id) async {
    final response = await http.post(
        Uri.parse("${AppConfig.BASE_URL}/filter/brands"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"},
        body: {"category_id": id.toString()});
    return brandResponseFromJson(response.body);
  }

  Future<BrandResponse> getBrands({name = "", page = 1}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/brands" + "?page=$page&name=$name"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return brandResponseFromJson(response.body);
  }

  Future<BrandResponse> getTopBrands() async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/brands/top"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return brandResponseFromJson(response.body);
  }

  Future<List<String>> getFilterColor(int id) async {
    final response = await http
        .post(Uri.parse("${AppConfig.BASE_URL}/filter/colors"), body: {
      "category_id": id.toString(),
    });
    return filterColorModelFromJson(response.body);
  }
}
