import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vs_live/src/errors/exceptions.dart';
import 'package:vs_live/src/features/football_highlight/domain/football_highlight.dart';
import 'package:vs_live/src/utils/dio_client/highlight_client/highlight_dio_client.dart';

part 'football_highlight_repository.g.dart';

class FootballHighlightRepository {
  FootballHighlightRepository({
    Dio? dioClient,
  }) : _client = dioClient ??= HighlightDioClient().instance;

  final Dio _client;

  Future<List<FootballHighlight>> fetchFeed({CancelToken? cancelToken}) async {
    try {
      final response = await _client.get('/', cancelToken: cancelToken);

      final data = response.data as List<dynamic>;
      final result = data
          .map((e) => FootballHighlight.fromJson(e as Map<String, dynamic>))
          .toList();

      return result;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionError) {
        throw ConnectionException(null, error.message);
      } else {
        throw UnknownException(null, error.message);
      }
    } catch (error) {
      developer.log("[fetchLiveMatches]: $error");
      rethrow;
    }
  }
}

@riverpod
FootballHighlightRepository footballHighlightRepository(
  Ref ref,
  Dio? client,
) {
  return FootballHighlightRepository(dioClient: client);
}
