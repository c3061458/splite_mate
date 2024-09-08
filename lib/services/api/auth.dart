import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:splite_mate/models/auth/login/login_request_model.dart';
import 'package:splite_mate/models/auth/login/login_response_model.dart';
import 'package:splite_mate/models/auth/otp/o_t_p_verification_response_model.dart';
import 'package:splite_mate/models/auth/register/register_request_model.dart';
import 'package:splite_mate/models/auth/register/register_response_model.dart';
import 'package:splite_mate/utils/api.dart';


class AuthAPIServices {
  static var client = http.Client();

  static Future<RegisterResponseModel> register(RegisterRequestModel requestModel) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.parse(MyAPI.register);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(requestModel),
    );

    if (response.statusCode != 500) {
      return RegisterResponseModel(
          statusCode: response.statusCode, message: response.reasonPhrase);
    } else {
      return RegisterResponseModel(
          statusCode: response.statusCode, message: response.reasonPhrase);
    }
  }

  static Future<OTPVerificationResponseModel> verifyOtp(
      String email, String otp) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.parse(MyAPI.verifyOTP);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode({"email": email, "otp": otp}),
    );

    return OTPVerificationResponseModel(
        statusCode: response.statusCode, message: response.reasonPhrase);
  }

  static Future<LoginResponseModel> login(
      LoginRequestModel requestModel) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.parse(MyAPI.login);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(requestModel),
    );

    if (response.statusCode != 500) {
      if (response.statusCode == 200) {
        LoginResponseModel responseModel =
        LoginResponseModel.fromJson(jsonDecode(response.body));

        return responseModel;
      }
      return LoginResponseModel(
          statusCode: response.statusCode, message: response.reasonPhrase);
    } else {
      return LoginResponseModel(
          statusCode: response.statusCode, message: response.reasonPhrase);
    }
  }
}