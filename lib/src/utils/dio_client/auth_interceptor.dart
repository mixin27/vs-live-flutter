import 'dart:io';

import 'package:dio/dio.dart';
import 'package:vs_live/src/config/env.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiKey = Env.apiKey;

    if (apiKey.isNotEmpty) {
      if (!options.headers.containsKey(HttpHeaders.authorizationHeader)) {
        options.headers["x-auth-key"] = apiKey;
      }
    }

    return handler.next(options);
  }
}
