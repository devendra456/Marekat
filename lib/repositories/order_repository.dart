import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:marekat/app_config.dart';
import 'package:marekat/data_model/order_detail_response.dart';
import 'package:marekat/data_model/order_item_response.dart';
import 'package:marekat/data_model/order_mini_response.dart';
import 'package:marekat/helpers/shared_value_helper.dart';

class OrderRepository {
  Future<OrderMiniResponse> getOrderList(
      {@required int user_id = 0,
      page = 1,
      payment_status = "",
      delivery_status = ""}) async {
    var url = "${AppConfig.BASE_URL}/purchase-history/" +
        user_id.toString() +
        "?page=${page}&payment_status=${payment_status}&delivery_status=${delivery_status}";

    final response = await http.get(Uri.parse(url),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    //print("url:" +url.toString());
    return orderMiniResponseFromJson(response.body);
  }

  Future<OrderDetailResponse> getOrderDetails({int id = 0}) async {
    var url = "${AppConfig.BASE_URL}/purchase-history-details/" + id.toString();

    final response = await http.get(Uri.parse(url),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    //print("url:" +url.toString());
    return orderDetailResponseFromJson(response.body);
  }

  Future<OrderItemResponse> getOrderItems({int id = 0}) async {
    var url = "${AppConfig.BASE_URL}/purchase-history-items/" + id.toString();

    final response = await http.get(Uri.parse(url),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    //print("url:" +url.toString());
    return orderItemlResponseFromJson(response.body);
  }

  Future<http.Response> cancelOrder(int id) async {
    try {
      var url = "${AppConfig.BASE_URL}/order/cancel";
      final response = await http.post(
        Uri.parse(url),
        body: {"order_id": id.toString()},
        headers: {
          "X-localization": langCode.$ == "ar" ? "sa" : "en",
          "Authorization": "Bearer ${access_token.$}",
          "Accept": "Application/json"
        },
      );
      return response;
    } finally {}
  }
}
