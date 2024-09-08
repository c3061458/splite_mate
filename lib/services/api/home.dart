import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:splite_mate/models/home/get_current_month_total_amount_model.dart';
import 'package:splite_mate/models/home/get_home_transactions_model.dart';
import 'package:splite_mate/utils/api.dart';

class HomeAPIServices {

  static Future<GetHomeTransactionsModel> getHomeDetails(
      String token) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(MyAPI.getHomeTransactions);

    var response = await http.get(url, headers: headers);

    if (response.statusCode != 500) {
      GetHomeTransactionsModel responseModel =
      GetHomeTransactionsModel.fromJson(jsonDecode(response.body));
      return responseModel;
    } else {
      return GetHomeTransactionsModel(
          message: response.reasonPhrase);
    }
  }

  static Future<GetCurrentMonthTotalAmountModel> getCurrentMonthTotal(
      String token) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(MyAPI.getTotalAmountCurrentMonth);

    var response = await http.get(url, headers: headers);

    if (response.statusCode != 500) {
      GetCurrentMonthTotalAmountModel responseModel =
      GetCurrentMonthTotalAmountModel.fromJson(jsonDecode(response.body));
      return responseModel;
    } else {
      return GetCurrentMonthTotalAmountModel(
          totalAmount: "-1");
    }
  }
}