import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_list/live_match_providers.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/theme/theme_mode_switch_button.dart';

import 'widgets/live_match_list_widget.dart';

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({super.key});

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  int _selectedView = 1;

  @override
  Widget build(BuildContext context) {
    final isGridView = _selectedView == 1;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            title: Text("Live Matches".hardcoded),
            floating: true,
            snap: true,
            pinned: true,
            actions: const [
              ThemeModeSwitchButton(),
            ],
            bottom: AppBar(
              title: Row(
                children: [
                  const Expanded(
                    child: CustomSearchField(),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: Sizes.p8),
                        child: ToggleButtons(
                          constraints: const BoxConstraints(
                              minWidth: 30.0, minHeight: 30.0),
                          isSelected: [_selectedView == 0, _selectedView == 1],
                          onPressed: (index) {
                            if (index > 1) return;
                            setState(() {
                              _selectedView = index;
                            });
                          },
                          children: [
                            Tooltip(
                              message: "List".hardcoded,
                              child: const Icon(Icons.list_outlined, size: 20),
                            ),
                            Tooltip(
                              message: "Grid".hardcoded,
                              child: const Icon(Icons.grid_view_outlined,
                                  size: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              return CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await ref.read(getAllLiveMatchProvider.notifier).refresh();
                },
              );
            },
          ),
          SliverList.list(children: const [SizedBox(height: 20)]),
          LiveMatchListWidget(
            viewType: isGridView ? ViewType.grid : ViewType.list,
          ),
        ],
      ),
    );
  }
}

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CupertinoSearchTextField();
  }
}
