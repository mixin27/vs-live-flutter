import 'package:dio/dio.dart';
import 'package:vs_live/src/features/soco/data/services/api/bsl_api_client.dart';
import 'package:vs_live/src/features/soco/domain/soco_models.dart';

import 'soco_repository.dart';

class SocoRepositoryRemote implements SocoRepository {
  SocoRepositoryRemote({
    required BslApiClient apiClient,
  }) : _apiClient = apiClient;

  final BslApiClient _apiClient;

  @override
  Future<List<SocoLiveMatch>> getLiveMatches({CancelToken? cancelToken}) async {
    return _apiClient.fetchSocoLiveMatches(cancelToken: cancelToken);
  }
}
