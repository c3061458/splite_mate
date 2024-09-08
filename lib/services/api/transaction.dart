import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:splite_mate/models/transaction/all_transaction_model.dart';
import 'package:splite_mate/models/transaction/get_accounts_model.dart';
import 'package:splite_mate/utils/api.dart';

class TransactionAPIServices {
  static var client = http.Client();

  static Future<AllTransactionModel> getAllTransactions(
      String token) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(MyAPI.getTransactions);

    var response = await http.get(url, headers: headers);

    if (response.statusCode != 500) {
      AllTransactionModel responseModel =
      AllTransactionModel.fromJson(jsonDecode(response.body));
      return responseModel;
    } else {
      return AllTransactionModel(
          message: response.reasonPhrase);
    }
  }

  static Future<GetAccountsModel> getAccounts(
      String token) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(MyAPI.getAccounts);

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      GetAccountsModel responseModel =
      GetAccountsModel.fromJson(jsonDecode(response.body));
      return responseModel;
    } else {
      return GetAccountsModel(
          data: null);
    }
  }
}