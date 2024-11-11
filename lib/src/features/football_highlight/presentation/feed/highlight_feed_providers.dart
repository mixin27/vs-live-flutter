import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vs_live/src/features/football_highlight/data/football_highlight_repository.dart';
import 'package:vs_live/src/features/football_highlight/domain/football_highlight.dart';
import 'package:vs_live/src/utils/extensions/riverpod_extensions.dart';

part 'highlight_feed_providers.g.dart';

@riverpod
class GetAllHighlightsFeed extends _$GetAllHighlightsFeed {
  Future<List<FootballHighlight>> _fetch() async {
    final client = await ref.getDebouncedHighlightClient();

    final repository = ref.watch(footballHighlightRepositoryProvider(client));
    final result = await repository.fetchFeed();
    return result;
  }

  @override
  FutureOr<List<FootballHighlight>> build() {
    return _fetch();
  }
}

@riverpod
class SearchHighlights extends _$SearchHighlights {
  @override
  List<FootballHighlight> build() {
    return [];
  }

  void onSearch(String query, List<FootballHighlight> data) {
    state = [];
    if (query.isNotEmpty) {
      final result = data
          .where((element) {
            final str = '${element.side1.name}${element.side2.name}';
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
