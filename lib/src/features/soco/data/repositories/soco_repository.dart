import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vs_live/src/features/soco/data/services/api/bsl_api_client.dart';
import 'package:vs_live/src/features/soco/domain/soco_models.dart';

import 'soco_repository_remote.dart';

part 'soco_repository.g.dart';

abstract class SocoRepository {
  Future<List<SocoLiveMatch>> getLiveMatches({CancelToken? cancelToken});
}

@riverpod
SocoRepository socoLiveRepositoryRemote(Ref ref, {Dio? client}) {
  return SocoRepositoryRemote(
    apiClient: ref.read(bslApiClientProvider(client: client)),
  );
}
