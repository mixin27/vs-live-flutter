import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'highlight_auth_interceptor.dart';

part 'highlight_dio_client.g.dart';

class HighlightDioClient {
  static HighlightDioClient? _instance;
  static late Dio _dio;
  Dio get instance => _dio;

  HighlightDioClient._private() {
    _dio = _createDioClient();
  }

  factory HighlightDioClient() {
    return _instance ??= HighlightDioClient._private();
  }

  Dio _createDioClient() {
    final dio = Dio()
      ..options = BaseOptions(
        baseUrl: "https://free-football-soccer-videos.p.rapidapi.com",
        headers: {
          Headers.acceptHeader: Headers.jsonContentType,
          Headers.contentTypeHeader: Headers.jsonContentType,
        },
      )
      ..interceptors.addAll([
        if (!kReleaseMode)
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
          ),
        HighlightAuthInterceptor(),
        // AppInterceptor(),
      ]);

    return dio;
  }
}

@riverpod
Dio highlightDioClient(Ref ref) {
  final dio = Dio()
    ..options = BaseOptions(
      baseUrl: "https://free-football-soccer-videos.p.rapidapi.com",
      headers: {
        Headers.acceptHeader: Headers.jsonContentType,
        Headers.contentTypeHeader: Headers.jsonContentType,
      },
    )
    ..interceptors.addAll([
      if (!kReleaseMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      HighlightAuthInterceptor(),
      // AppInterceptor(),
    ]);

  return dio;
}
