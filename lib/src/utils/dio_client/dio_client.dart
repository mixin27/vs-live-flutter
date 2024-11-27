import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vs_live/src/config/env.dart';
import 'package:vs_live/src/utils/dio_client/app_interceptor.dart';
import 'package:vs_live/src/utils/dio_client/auth_interceptor.dart';
import 'package:vs_live/src/utils/remote_config/remote_config.dart';

part 'dio_client.g.dart';

class DioClient {
  static DioClient? _instance;
  static late Dio _dio;
  Dio get instance => _dio;

  DioClient._private() {
    _dio = _createDioClient();
  }

  factory DioClient() {
    return _instance ??= DioClient._private();
  }

  Dio _createDioClient() {
    final baseUrl =
        AppRemoteConfig.apiUrl.isEmpty ? Env.baseUrl : AppRemoteConfig.apiUrl;
    final dio = Dio()
      ..options = BaseOptions(
        baseUrl: baseUrl,
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
        AuthInterceptor(),
        AppInterceptor(),
      ]);

    return dio;
  }
}

@riverpod
Dio defaultDioClient(Ref ref) {
  final baseUrl =
      AppRemoteConfig.apiUrl.isEmpty ? Env.baseUrl : AppRemoteConfig.apiUrl;
  final dio = Dio()
    ..options = BaseOptions(
      baseUrl: baseUrl,
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
      AuthInterceptor(),
      AppInterceptor(),
    ]);
  return dio;
}
