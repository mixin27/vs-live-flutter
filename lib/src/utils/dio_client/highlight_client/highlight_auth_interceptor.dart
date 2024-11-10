import 'dart:io';

import 'package:dio/dio.dart';
import 'package:vs_live/src/config/env.dart';

class HighlightAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiKey = Env.highlightApiKey;

    if (apiKey.isNotEmpty) {
      if (!options.headers.containsKey(HttpHeaders.authorizationHeader)) {
        options.headers["x-rapidapi-host"] =
            "free-football-soccer-videos.p.rapidapi.com";
        options.headers["x-rapidapi-key"] = apiKey;
      }
    }

    return handler.next(options);
  }
}
