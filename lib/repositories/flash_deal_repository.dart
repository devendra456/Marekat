import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/data_model/flash_deal_response.dart';
import 'package:Daemmart/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

class FlashDealRepository {
  Future<FlashDealResponse> getFlashDeals() async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/flash-deals"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return flashDealResponseFromJson(response.body);
  }
}
