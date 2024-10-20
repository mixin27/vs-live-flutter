import 'dart:io';

import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    const apiKey =
        bool.hasEnvironment("API_KEY") ? String.fromEnvironment("API_KEY") : "";

    if (apiKey.isNotEmpty) {
      if (!options.headers.containsKey(HttpHeaders.authorizationHeader)) {
        options.headers["x-auth-key"] = apiKey;
      }
    }

    return handler.next(options);
  }
}
