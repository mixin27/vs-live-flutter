import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vs_live/src/features/live_match/data/live_match_repository.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';

part 'live_match_providers.g.dart';

@riverpod
class GetAllLiveMatch extends _$GetAllLiveMatch {
  Future<List<LiveMatch>> _fetch() async {
    final repository = ref.watch(liveMatchRepositoryProvider);
    final result = await repository.fetchAllLiveMatch();
    return result.data ?? [];
  }

  @override
  Future<List<LiveMatch>> build() {
    return _fetch();
  }
}
