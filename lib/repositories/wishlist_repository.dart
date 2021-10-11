import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/data_model/wishlist_check_response.dart';
import 'package:Daemmart/data_model/wishlist_delete_response.dart';
import 'package:Daemmart/data_model/wishlist_response.dart';
import 'package:Daemmart/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WishListRepository {
  Future<WishlistResponse> getUserWishlist() async {
    final response = await http.get(
      Uri.parse("${AppConfig.BASE_URL}/wishlists/${user_id.$}"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Authorization": "Bearer ${access_token.$}"
      },
    );
    return wishlistResponseFromJson(response.body);
  }

  Future<WishlistDeleteResponse> delete({
    @required int wishlist_id = 0,
  }) async {
    final response = await http.delete(
      Uri.parse("${AppConfig.BASE_URL}/wishlists/${wishlist_id}"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Authorization": "Bearer ${access_token.$}"
      },
    );
    return wishlistDeleteResponseFromJson(response.body);
  }

  Future<WishListChekResponse> isProductInUserWishList(
      {@required product_id = 0}) async {
    final response = await http.get(
      Uri.parse(
          "${AppConfig.BASE_URL}/wishlists-check-product?product_id=${product_id}&user_id=${user_id.$}"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Authorization": "Bearer ${access_token.$}"
      },
    );
    return wishListChekResponseFromJson(response.body);
  }

  Future<WishListChekResponse> add({@required product_id = 0}) async {
    final response = await http.get(
      Uri.parse(
          "${AppConfig.BASE_URL}/wishlists-add-product?product_id=${product_id}&user_id=${user_id.$}"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Authorization": "Bearer ${access_token.$}"
      },
    );
    return wishListChekResponseFromJson(response.body);
  }

  Future<WishListChekResponse> remove({@required product_id = 0}) async {
    final response = await http.get(
      Uri.parse(
          "${AppConfig.BASE_URL}/wishlists-remove-product?product_id=${product_id}&user_id=${user_id.$}"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Authorization": "Bearer ${access_token.$}"
      },
    );
    return wishListChekResponseFromJson(response.body);
  }
}
