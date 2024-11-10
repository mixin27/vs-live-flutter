import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/football_highlight/domain/football_highlight.dart';
import 'package:vs_live/src/features/football_highlight/presentation/feed/highlight_feed_providers.dart';
import 'package:vs_live/src/features/football_highlight/presentation/feed/widgets/football_highlights_list.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/theme/theme_mode_switch_button.dart';

class HighlightFeedScreen extends StatefulWidget {
  const HighlightFeedScreen({super.key});

  @override
  State<HighlightFeedScreen> createState() => _HighlightFeedScreenState();
}

class _HighlightFeedScreenState extends State<HighlightFeedScreen> {
  int _selectedView = 0;

  @override
  Widget build(BuildContext context) {
    final isGridView = _selectedView == 0;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            title: Text("Highlights".hardcoded),
            floating: true,
            snap: true,
            pinned: true,
            actions: const [
              ThemeModeSwitchButton(),
            ],
            bottom: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  const Expanded(
                    child: HighlightsSearchField(),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: Sizes.p8),
                    child: ToggleButtons(
                      constraints: const BoxConstraints(
                        minWidth: 30.0,
                        minHeight: 30.0,
                      ),
                      isSelected: [_selectedView == 0, _selectedView == 1],
                      onPressed: (index) {
                        if (index > 1) return;
                        setState(() {
                          _selectedView = index;
                        });
                      },
                      children: [
                        Tooltip(
                          message: "Grid".hardcoded,
                          child: const Icon(
                            Icons.grid_view_outlined,
                            size: 20,
                          ),
                        ),
                        Tooltip(
                          message: "List".hardcoded,
                          child: const Icon(Icons.list_outlined, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              return CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await ref
                      .read(getAllHighlightsFeedProvider.notifier)
                      .refresh();
                },
              );
            },
          ),
          SliverList.list(children: const [SizedBox(height: 20)]),
          FootballHighlightsList(
            viewType: isGridView ? ViewType.grid : ViewType.list,
          ),
        ],
      ),
    );
  }
}

class HighlightsSearchField extends ConsumerStatefulWidget {
  const HighlightsSearchField({
    super.key,
  });

  @override
  ConsumerState<HighlightsSearchField> createState() =>
      _CustomSearchFieldState();
}

class _CustomSearchFieldState extends ConsumerState<HighlightsSearchField> {
  final _searchController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getAllHighlightsFeedProvider);
    final List<FootballHighlight> data =
        state.maybeWhen(orElse: () => [], data: (data) => data);

    return CupertinoSearchTextField(
      controller: _searchController,
      placeholder: "Search".hardcoded,
      style: Theme.of(context).textTheme.labelLarge,
      onChanged: (value) {
        ref.read(searchHighlightsProvider.notifier).onSearch(value, data);
      },
      onSuffixTap: () {
        _searchController.clear();
        ref.read(searchHighlightsProvider.notifier).clear();
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
