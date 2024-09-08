import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:splite_mate/models/payment/add_payment_request_model.dart';
import 'package:splite_mate/models/payment/add_payment_response_model.dart';
import 'package:splite_mate/models/payment/get_currency_rate_model.dart';
import 'package:splite_mate/models/payment/payment_upload_receipt_response_model.dart';
import 'package:splite_mate/utils/api.dart';

class PaymentAPIServices {
  static var client = http.Client();

  static Future<PaymentUploadReceiptResponseModel> uploadBill(
    XFile image,
    String token,
  ) async {
    var headers = {'Authorization': 'Bearer $token'};

    var request = http.MultipartRequest('POST', Uri.parse(MyAPI.uploadBill));

    request.files.add(await http.MultipartFile.fromPath('bill_image', image.path));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode != 500) {
      if (response.statusCode == 200) {
        PaymentUploadReceiptResponseModel responseModel =
        PaymentUploadReceiptResponseModel.fromJson(jsonDecode(await response.stream.bytesToString()));
        return responseModel;
      } else {
        return PaymentUploadReceiptResponseModel(amount: "-1");
      }
    } else {
      return PaymentUploadReceiptResponseModel(amount: "-1");
    }
  }

  static Future<AddPaymentResponseModel> createPayment(
      AddPaymentRequestModel data, String token) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse(MyAPI.addPayment);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(data),
    );

    if (response.statusCode != 500) {
      if (response.statusCode == 201) {
        AddPaymentResponseModel responseModel =
        AddPaymentResponseModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return AddPaymentResponseModel(error: response.reasonPhrase);
    } else {
      return AddPaymentResponseModel(error: response.reasonPhrase);
    }
  }

  static Future<GetCurrencyRateModel> getCurrency(String token) async {
    // var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(MyAPI.currencyAPI);

    var response = await http.get(url);

    if (response.statusCode != 500) {
      if (response.statusCode == 200) {
        GetCurrencyRateModel responseModel =
        GetCurrencyRateModel.fromJson(jsonDecode(response.body));
        return responseModel;
      }
      return GetCurrencyRateModel(result: "Fail");
    } else {
      return GetCurrencyRateModel(result: "Fail");
    }
  }
}
