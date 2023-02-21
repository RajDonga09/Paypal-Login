import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:http_auth/http_auth.dart';
import 'package:paypal_login_demo/paypal_constant.dart';
import 'package:paypal_login_demo/paypal_reponse.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'main.dart';

class PaypalController {
  static final PaypalController _paypalController = PaypalController._init();

  factory PaypalController() {
    return _paypalController;
  }

  PaypalController._init();

  PayPalResponse? payPalResponse;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isConnected = ValueNotifier(false);

  Future<NavigationDecision> webViewInstagramCallBack(BuildContext context, NavigationRequest request) async {
    if (request.url.startsWith(PaypalConstant.redirectUri)) {
      if (request.url.contains(PaypalConstant.errorTypeUrl)) {
        Navigator.pop(context);
        showSnackBar('Something went wrong. Please try again');
        return NavigationDecision.navigate;
      }

      var startIndex = request.url.indexOf('code=');
      var endIndex = request.url.lastIndexOf('&scope');
      var authCode = request.url.substring(startIndex + 5, endIndex);
      Navigator.pop(context);
      doConnectWithPayPal(context, authCode);
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  Future<void> doConnectWithPayPal(BuildContext context, String authCode) async {
    log('PayPalAPITest doConnectWithPayPal authCode: $authCode');
    try {
      isLoading.value = true;
      String accessToken = await getAccessToken(authCode);
      log('PayPalAPITest getAccessToken accessToken: $accessToken');
      try {
        payPalResponse = await getUserProfile(accessToken);
        isConnected.value = true;
        log('PayPalAPITest getUserProfile userInfoMap: ${payPalResponse?.toJson()}');
      } catch (e, st) {
        log('PayPalAPITest getUserProfile: $e STACK: $st');
        showSnackBar('$e');
      }
    } catch (e, st) {
      log('PayPalAPITest getAccessToken: $e STACK: $st');
      showSnackBar('$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getAccessToken(String authCode) async {
    var client = BasicAuthClient(PaypalConstant.clientID, PaypalConstant.secret);

    var body = {
      'grant_type': PaypalConstant.authorizationCode,
      'response_type': PaypalConstant.token,
      'redirect_uri': PaypalConstant.redirectUri,
      'code': authCode,
    };

    var response = await client.post(Uri.parse("${PaypalConstant.baseUrl}/v1/oauth2/token"), body: body);

    if (response.statusCode != 200) {
      throw Exception('${response.statusCode} Access token API failure');
    }

    return (json.decode(response.body)['access_token']);
  }

  Future<PayPalResponse> getUserProfile(String accessToken) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    var response =
        await https.get(Uri.parse("${PaypalConstant.baseUrl}/v1/identity/oauth2/userinfo?schema=paypalv1.1"), headers: headers);

    if (response.statusCode != 200) {
      throw Exception('${response.statusCode} User Profile get API failure');
    }

    return PayPalResponse.fromJson(json.decode(response.body));
  }
}
