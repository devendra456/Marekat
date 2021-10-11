import 'package:Daemmart/app_config.dart';
import 'package:Daemmart/data_model/wallet_balance_response.dart';
import 'package:Daemmart/data_model/wallet_recharge_response.dart';
import 'package:Daemmart/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;

class WalletRepository {
  Future<WalletBalanceResponse> getBalance() async {
    final response = await http.get(
      Uri.parse("${AppConfig.BASE_URL}/wallet/balance/${user_id.$}"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Authorization": "Bearer ${access_token.$}"
      },
    );
    //print(response.body.toString());
    return walletBalanceResponseFromJson(response.body);
  }

  Future<WalletRechargeResponse> getRechargeList({int page = 1}) async {
    final response = await http.get(
      Uri.parse(
          "${AppConfig.BASE_URL}/wallet/history/${user_id.$}?page=${page}"),
      headers: {
        "X-localization": langCode.$ == "ar" ? "sa" : "en",
        "Authorization": "Bearer ${access_token.$}"
      },
    );
    return walletRechargeResponseFromJson(response.body);
  }
}
