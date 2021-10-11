import 'package:http/http.dart' as http;
import 'package:marekat/app_config.dart';
import 'package:marekat/data_model/flash_deal_response.dart';
import 'package:marekat/helpers/shared_value_helper.dart';

class FlashDealRepository {
  Future<FlashDealResponse> getFlashDeals() async {
    final response = await http.get(
        Uri.parse("${AppConfig.BASE_URL}/flash-deals"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return flashDealResponseFromJson(response.body);
  }
}
