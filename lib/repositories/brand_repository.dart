import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/data_model/brand_response.dart';
import 'package:Daemmart/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

class BrandRepository {
  Future<BrandResponse> getFilterPageBrands() async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/filter/brands"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return brandResponseFromJson(response.body);
  }

  Future<BrandResponse> getBrands({name = "", page = 1}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/brands" + "?page=$page&name=$name"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return brandResponseFromJson(response.body);
  }
}
