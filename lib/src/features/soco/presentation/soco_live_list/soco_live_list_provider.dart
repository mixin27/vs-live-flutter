import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vs_live/src/features/soco/data/repositories/soco_repository.dart';
import 'package:vs_live/src/features/soco/domain/soco_models.dart';

part 'soco_live_list_provider.g.dart';

@riverpod
class GetSocoLiveMatches extends _$GetSocoLiveMatches {
  Future<List<SocoLiveMatch>> _fetchData() async {
    final cancelToken = CancelToken();
    ref.onDispose(() {
      cancelToken.cancel();
    });

    final repository = ref.read(socoLiveRepositoryRemoteProvider());

    return repository.getLiveMatches(cancelToken: cancelToken);
  }

  @override
  FutureOr<List<SocoLiveMatch>> build() {
    return _fetchData();
  }
}
