/// Base class for all all client-side errors that can be generated by the app
sealed class AppException implements Exception {
  AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NeedEnvironmentVariableDeclareException extends AppException {
  NeedEnvironmentVariableDeclareException([String? code, String? message])
      : super(
          message ?? 'Need environment variable declaration.',
        );
}

class UnknownException extends AppException {
  UnknownException([String? code, String? message])
      : super(
          message ?? 'Something went wrong! Please try again.',
        );
}

class ConnectionException extends AppException {
  ConnectionException([String? code, String? message])
      : super(
          message ?? 'No internet connection.',
        );
}

class ServerException extends AppException {
  ServerException({
    required String code,
    required String message,
  }) : super(message);
}
