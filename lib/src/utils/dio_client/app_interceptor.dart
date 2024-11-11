import 'dart:io';

import 'package:dio/dio.dart';
import 'package:vs_live/src/models/app_response.dart';

class AppInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final responseData = mapResponseData(
      requestOptions: response.requestOptions,
      response: response,
    );

    return handler.resolve(responseData);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorMessage = getErrorMessage(err, err.response?.statusCode);

    final responseData = mapResponseData(
      requestOptions: err.requestOptions,
      response: err.response,
      customMessage: errorMessage,
      isErrorResponse: true,
    );

    return handler.resolve(responseData);
  }
}

Response<dynamic> mapResponseData({
  Response<dynamic>? response,
  required RequestOptions requestOptions,
  String customMessage = "",
  bool isErrorResponse = false,
}) {
  final bool hasResponseData = response?.data != null;
  Map<String, dynamic>? responseData = response?.data;

  if (hasResponseData) {
    responseData!.addAll({
      'statusCode': response?.statusCode,
      'statusMessage': response?.statusMessage,
    });
  }

  return Response(
    requestOptions: requestOptions,
    data: hasResponseData
        ? responseData
        : AppResponse(
            success: isErrorResponse == false,
            message: customMessage,
            statusCode: response?.statusCode,
            statusMessage: response?.statusMessage,
          ).toJson((value) => null),
  );
}

class DioExceptionMessage {
  static const badRequestException = 'Invalid request';
  static const internalServerErrorException =
      'Unknown error occurred, please try again later.';
  static const conflictException = 'Conflict occurred';
  static const unauthorizedException = 'Access denied';
  static const notFoundException =
      'The requested information could not be found';
  static const unexpectedException = 'Unexpected error occurred.';
  static const noInternetConnectionException =
      'No internet connection detected, please try again.';
  static const deadlineExceededException =
      'The connection has timed out, please try again.';
  static const userCancelException = 'User cancel the request.';
  static const unprocessableException = 'The validation error(s) occurred.';
}

String getErrorMessage(DioException dioException, int? statusCode) {
  var errorMessage = '';
  switch (dioException.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      errorMessage = DioExceptionMessage.deadlineExceededException;
    case DioExceptionType.connectionError:
      errorMessage = DioExceptionMessage.noInternetConnectionException;
    case DioExceptionType.badResponse:
      switch (statusCode) {
        case 400:
          errorMessage = DioExceptionMessage.badRequestException;
        case 401:
          errorMessage = DioExceptionMessage.unauthorizedException;
        case 404:
          errorMessage = DioExceptionMessage.notFoundException;
        case 409:
          errorMessage = DioExceptionMessage.conflictException;
        case 422:
          errorMessage = DioExceptionMessage.unprocessableException;
        case 500:
          errorMessage = DioExceptionMessage.internalServerErrorException;
      }
    case DioExceptionType.cancel:
      errorMessage = DioExceptionMessage.userCancelException;
    case DioExceptionType.unknown:
      if (dioException.error is SocketException) {
        errorMessage = DioExceptionMessage.noInternetConnectionException;
      } else {
        errorMessage = DioExceptionMessage.unexpectedException;
      }
    case DioExceptionType.badCertificate:
      break;
  }

  return errorMessage;
}
