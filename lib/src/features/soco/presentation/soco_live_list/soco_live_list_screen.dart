import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/features/soco/presentation/soco_live_list/soco_live_list_provider.dart';
import 'package:vs_live/src/features/soco/presentation/soco_live_list/widgets/soco_live_list_view_widget.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/analytics_util.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/theme/theme_mode_switch_button.dart';
import 'package:wiredash/wiredash.dart';

class SocoLiveListScreen extends StatefulWidget {
  const SocoLiveListScreen({super.key});

  @override
  State<SocoLiveListScreen> createState() => _SocoLiveListScreenState();
}

class _SocoLiveListScreenState extends State<SocoLiveListScreen> {
  @override
  void initState() {
    // Record a visit to this page.
    AnalyticsUtil.logScreenView(screenName: 'SocoLiveListScreen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'soco-live-list-fab',
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
            title: Text("Live Matches".hardcoded),
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
            ],
          ),
          Consumer(
            builder: (context, ref, child) {
              return CupertinoSliverRefreshControl(
                onRefresh: () => ref.refresh(getSocoLiveMatchesProvider.future),
              );
            },
          ),

          const SocoLiveListViewWidget(),
        ],
      ),
    );
  }
}
