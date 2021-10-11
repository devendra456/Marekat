import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/data_model/slider_response.dart';
import 'package:Daemmart/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

class SlidersRepository {
  Future<SliderResponse> getSliders() async {
    final response = await http.get(Uri.parse("${AppConfig.BASE_URL}/sliders"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return sliderResponseFromJson(response.body);
  }
}
