import 'package:http/http.dart' as http;
import 'package:marekat/app_config.dart';
import 'package:marekat/data_model/product_details_response.dart';
import 'package:marekat/data_model/product_mini_response.dart';
import 'package:marekat/data_model/variant_response.dart';
import 'package:marekat/helpers/shared_value_helper.dart';

class ProductRepository {
  Future<ProductMiniResponse> getFeaturedProducts() async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/products/featured"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBestSellingProducts() async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/products/best-seller"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTodaysDealProducts() async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/products/todays-deal"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFlashDealProducts({int id = 0}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/flash-deal-products/" + id.toString()),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryProducts(
      {int id = 0, name = "", page = 1}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/products/category/" +
            id.toString() +
            "?page=$page&name=$name"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getShopProducts(
      {int id = 0, name = "", page = 1}) async {
    var url = "${AppConfig.BASE_URL}/products/seller/" +
        id.toString() +
        "?page=$page&name=$name";

    final response = await http.get(Uri.parse(url),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBrandProducts(
      {int id = 0, name = "", page = 1}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/products/brand/" +
            id.toString() +
            "?page=$page&name=$name"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFilteredProducts({
    name = "",
    sort_key = "",
    page = 1,
    brands = "",
    categories = "",
    min = "",
    max = "",
    colors = "",
  }) async {
    var url = "${AppConfig.BASE_URL}/products/search" +
        "?page=$page&name=$name&sort_key=$sort_key&brands=$brands&categories=$categories&min=$min&max=$max&colors=$colors";

    //print("url:" + url);
    final response = await http.get(Uri.parse(url),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductDetailsResponse> getProductDetails({int id = 0}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/products/" + id.toString()),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});

    return productDetailsResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getRelatedProducts({int id = 0}) async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/products/related/" + id.toString()),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTopFromThisSellerProducts({int id = 0}) async {
    final response = await http.get(
        Uri.parse(
            "${AppConfig.BASE_URL}/products/top-from-seller/" + id.toString()),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return productMiniResponseFromJson(response.body);
  }

  Future<VariantResponse> getVariantWiseInfo(
      {int id = 0, color = '', variants = ''}) async {
    var url =
        "${AppConfig.BASE_URL}/products/variant/price?id=${id.toString()}&color=$color&variants=$variants";

    final response = await http.get(Uri.parse(url),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});

    return variantResponseFromJson(response.body);
  }
}
