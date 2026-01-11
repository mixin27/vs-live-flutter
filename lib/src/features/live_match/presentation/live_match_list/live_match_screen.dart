import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_list/live_match_providers.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/analytics_util.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/utils/scheduler.dart';
import 'package:vs_live/src/widgets/theme/theme_mode_switch_button.dart';
import 'package:wiredash/wiredash.dart';

import 'widgets/live_match_list_widget.dart';

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({super.key});

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  int _selectedView = 0;

  @override
  void initState() {
    // Record a visit to this page.
    AnalyticsUtil.logScreenView(screenName: 'LiveMatchScreen');
    super.initState();

    // initOnesignal();

    AppScheduler.taskDaily('vpn_notice', () {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          forceActionsBelow: true,
          padding: const EdgeInsets.all(20),
          leading: const Icon(Icons.warning_amber_rounded),
          content: const Text(
            'If you are from some restricted regions like Europe and America, you must use VPN to watch some stream links.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text('DISMISS'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGridView = _selectedView == 0;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'live-match-fab',
        onPressed: () {
          Wiredash.of(context).show(inheritMaterialTheme: true);
        },
        child: const Icon(Icons.feedback_outlined),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            title: Text("Billion Sport Live".hardcoded),
            floating: true,
            snap: true,
            pinned: true,
            actions: [
              const ThemeModeSwitchButton(),
              IconButton(
                onPressed: () {
                  context.goNamed(AppRoute.settings.name);
                },
                icon: const Icon(Icons.settings_outlined),
              ),
              // IconButton(
              //   onPressed: () {
              //     // context.pushNamed(AppRoute.adsTest.name);
              //     showAdaptiveDialog(
              //       context: context,
              //       barrierDismissible: false,
              //       builder: (context) {
              //         return WatchAdDialog(
              //           onComplete: () {
              //             AdHelper.showInterstitialAd(
              //               context,
              //               onComplete: () {
              //                 ScaffoldMessenger.of(context).showSnackBar(
              //                   const SnackBar(
              //                     content: Text("Yayy! You are rewarded!!!"),
              //                   ),
              //                 );
              //               },
              //             );
              //           },
              //         );
              //       },
              //     );
              //   },
              //   icon: const Icon(Icons.ad_units_sharp),
              // ),
            ],
            bottom: AppBar(
              title: Row(
                children: [
                  const Expanded(child: CustomSearchField()),
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
                          child: const Icon(Icons.grid_view_outlined, size: 20),
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
                onRefresh: () => ref.refresh(getAllLiveMatchProvider.future),
              );
            },
          ),

          LiveMatchListWidget(
            viewType: isGridView ? ViewType.grid : ViewType.list,
          ),
        ],
      ),
    );
  }
}

class CustomSearchField extends ConsumerStatefulWidget {
  const CustomSearchField({super.key});

  @override
  ConsumerState<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends ConsumerState<CustomSearchField> {
  final _searchController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getAllLiveMatchProvider);
    final List<LiveMatch> data = state.maybeWhen(
      orElse: () => [],
      data: (data) => data,
    );

    return CupertinoSearchTextField(
      controller: _searchController,
      placeholder: "Search".hardcoded,
      style: Theme.of(context).textTheme.labelLarge,
      onChanged: (value) {
        ref.read(searchLiveMatchesProvider.notifier).onSearch(value, data);
      },
      onSuffixTap: () {
        _searchController.clear();
        ref.read(searchLiveMatchesProvider.notifier).clear();
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
