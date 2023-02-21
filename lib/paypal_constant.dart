class PaypalConstant {
  static const String clientID = 'AQCNtmtcj6TU7MOHH00hFxDe15Rtn49owQI97vjYE_uiItqNSTaLLQngzm91kIDC6On3N__zNzmX0oLN';
  static const String secret = 'EAdG2CyGYx5qX1TZmRNgDjx9GhXLP--OlqtI43qDI8tKBaPuG3ybwvAslo9SiC9B76MI8Pf6qeofFVYf';
  static const String redirectUri = 'https://app.bullz.com/';
  static const String scope = 'openid profile email address';
  static const String responseType = 'code';
  static const String authorizationCode = 'authorization_code';
  static const String clientCredentials = 'client_credentials';
  static const String token = 'token';
  static const String devUrl = 'https://www.sandbox.paypal.com';
  static const String prodUrl = 'https://www.paypal.com';
  static const String errorTypeUrl = '?error_uri';
  static const bool sandboxMode = true;

  static String requestUrl =
      '$baseUrl/connect?flowEntry=static&client_id=$clientID&response_type=$responseType&scope=$scope&redirect_uri=$redirectUri';

  static String get baseUrl => sandboxMode ? devUrl : prodUrl;
}
