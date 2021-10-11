import 'package:http/http.dart' as http;
import 'package:marekat/app_config.dart';
import 'package:marekat/data_model/slider_response.dart';
import 'package:marekat/helpers/shared_value_helper.dart';

class SlidersRepository {
  Future<SliderResponse> getSliders() async {
    final response = await http.get(Uri.parse("${AppConfig.BASE_URL}/sliders"),
        headers: {"X-localization": langCode.$ == "ar" ? "sa" : "en"});
    return sliderResponseFromJson(response.body);
  }
}
