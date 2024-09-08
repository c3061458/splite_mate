import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:splite_mate/models/budget/add_budget_response_model.dart';
import 'package:splite_mate/models/budget/get_budget_model.dart';
import 'package:splite_mate/utils/api.dart';

class BudgetAPIServices {
  static var client = http.Client();

  static Future<GetBudgetModel> getBudget(
      String token) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(MyAPI.getBudget);

    var response = await http.get(url, headers: headers);

    if (response.statusCode != 500) {
      if (response.statusCode == 200) {
        GetBudgetModel responseModel =
            GetBudgetModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return GetBudgetModel(
          budgets: null);
    } else {
      return GetBudgetModel(
          budgets: null);
    }
  }

  static Future<AddBudgetResponseModel> addBudget(
      int budget, String token) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse(MyAPI.addBudget);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "budget": budget
      }),
    );

    if (response.statusCode != 500) {
      if (response.statusCode == 201) {
        AddBudgetResponseModel responseModel =
        AddBudgetResponseModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return AddBudgetResponseModel(
          error: response.reasonPhrase);
    } else {
      return AddBudgetResponseModel(
          error: response.reasonPhrase);
    }
  }

  static Future<AddBudgetResponseModel> updateBudget(
      int budget, String token, String id) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse(MyAPI.updateBudget + id);

    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode({
        "budget": budget
      }),
    );

    if (response.statusCode != 500) {
      if (response.statusCode == 200) {
        AddBudgetResponseModel responseModel =
        AddBudgetResponseModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return AddBudgetResponseModel(
          error: response.reasonPhrase);
    } else {
      return AddBudgetResponseModel(
          error: response.reasonPhrase);
    }
  }
}