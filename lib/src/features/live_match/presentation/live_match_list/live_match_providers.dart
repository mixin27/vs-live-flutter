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

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

@Riverpod(keepAlive: true)
class LiveMatches extends _$LiveMatches {
  @override
  List<LiveMatch> build() {
    return [];
  }

  void setData(List<LiveMatch> items) {
    state = items;
  }
}

@riverpod
class SearchLiveMatches extends _$SearchLiveMatches {
  @override
  List<LiveMatch> build() {
    return [];
  }

  void onSearch(String query, List<LiveMatch> data) {
    state = [];
    if (query.isNotEmpty) {
      final result = data
          .where((element) {
            final str = '${element.homeTeam.name}${element.awayTeam.name}';
            return str.toLowerCase().contains(query.toLowerCase());
          })
          .toSet()
          .toList();
      state.addAll(result);
    }
  }

  void clear() {
    state = [];
  }
}

@riverpod
class SearchKeyword extends _$SearchKeyword {
  @override
  String build() {
    return '';
  }

  void update(String keyword) => state = keyword;
}
