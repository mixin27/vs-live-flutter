import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vs_live/src/errors/exceptions.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/models/app_response.dart';
import 'package:vs_live/src/utils/dio_client/dio_client.dart';

part 'live_match_repository.g.dart';

class LiveMatchRepository {
  LiveMatchRepository({
    Dio? dioClient,
  }) : _client = dioClient ??= DioClient().instance;

  final Dio _client;

  Future<AppResponse<List<LiveMatch>?>> fetchAllLiveMatch({
    int? page,
    int? limit,
  }) async {
    final presentQueryParams = page != null || limit != null;

    try {
      final response = await _client.get(
        '/api/matches',
        queryParameters: presentQueryParams
            ? {
                "page": page,
                "limit": limit,
              }
            : null,
      );

      final result = AppResponse<List<LiveMatch>>.fromJson(
        response.data,
        (dynamic json) => response.data["success"] && json != null
            ? (json as List<dynamic>)
                .map((e) => LiveMatch.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
      );

      if (result.success) {
        return result;
      } else {
        throw ServerException(
          code: result.statusCode.toString(),
          message: result.message,
        );
      }
    } catch (error) {
      developer.log("[fetchLiveMatches]: $error");
      rethrow;
    }
  }
}

@riverpod
LiveMatchRepository liveMatchRepository(LiveMatchRepositoryRef ref) {
  return LiveMatchRepository();
}
