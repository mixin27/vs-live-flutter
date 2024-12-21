import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vs_live/src/errors/exceptions.dart';
import 'package:vs_live/src/features/soco/domain/soco_models.dart';
import 'package:vs_live/src/utils/dio_client/dio_client.dart';

part 'bsl_api_client.g.dart';

class BslApiClient {
  BslApiClient(
    Dio Function()? clientFactory,
  ) : _clientFactory = clientFactory ?? (() => Dio());

  final Dio Function() _clientFactory;

  Future<List<SocoLiveMatch>> fetchSocoLiveMatches({
    CancelToken? cancelToken,
  }) async {
    final client = _clientFactory();

    try {
      final response = await client.get('/matches', cancelToken: cancelToken);

      if (response.statusCode == 200) {
        final result =
            SocoLiveModel.fromJson(response.data as Map<String, dynamic>);
        return result.data;
      } else {
        throw ServerException(
          code: response.statusCode.toString(),
          message: response.statusMessage ?? "Unknown error",
        );
      }
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionError) {
        throw ConnectionException(null, error.message);
      } else {
        throw UnknownException(null, error.message);
      }
    } catch (error) {
      developer.log("[fetchSocoLiveMatches]: $error");
      rethrow;
    }
  }
}

@riverpod
BslApiClient bslApiClient(Ref ref, {Dio? client}) {
  return BslApiClient(() => client ?? ref.read(bslDioClientProvider));
}
