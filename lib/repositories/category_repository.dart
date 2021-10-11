import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/data_model/category_response.dart';
import 'package:Daemmart/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

class CategoryRepository {
  Future<CategoryResponse> getCategories({parent_id = 0}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/categories?parent_id=${parent_id}"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFeturedCategories() async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/categories/featured"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getTopCategories() async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/categories/top"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFilterPageCategories() async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/filter/categories"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return categoryResponseFromJson(response.body);
  }
}
