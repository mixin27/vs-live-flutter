import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_list/live_match_providers.dart';
import 'package:vs_live/src/utils/ads/ad_helper.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/error_status_icon_widget.dart';

import 'live_match_grid_view.dart';
import 'live_match_list_view.dart';

enum ViewType {
  list,
  grid,
}

class LiveMatchListWidget extends ConsumerStatefulWidget {
  const LiveMatchListWidget({
    super.key,
    this.viewType = ViewType.grid,
  });

  final ViewType viewType;

  @override
  ConsumerState<LiveMatchListWidget> createState() =>
      _LiveMatchListWidgetState();
}

class _LiveMatchListWidgetState extends ConsumerState<LiveMatchListWidget> {
  List<LiveMatch> _liveMatches = List.empty();

  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;

  @override
  void initState() {
    super.initState();

    final ad = AdHelper.loadNativeAd(onLoaded: () {
      setState(() {
        _isNativeAdLoaded = true;
      });
    });
    setState(() {
      _nativeAd = ad;
    });
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      getAllLiveMatchProvider,
      (prev, state) {
        // state.showAlertDialogOnError(context);

        setState(() {
          _liveMatches = state.maybeWhen(
            orElse: () => prev?.valueOrNull ?? [],
            data: (data) => data,
          );
        });
      },
    );

    final state = ref.watch(getAllLiveMatchProvider);
    final searchState = ref.watch(searchLiveMatchesProvider);

    return switch (state) {
      AsyncData(:final value) when value.isNotEmpty =>
        widget.viewType == ViewType.grid
            ? LiveMatchGridView(
                matches: searchState.isNotEmpty ? searchState : _liveMatches)
            : LiveMatchListView(
                matches: searchState.isNotEmpty ? searchState : _liveMatches),
      AsyncLoading() => _liveMatches.isEmpty
          ? SliverList.list(
              children: const [CupertinoActivityIndicator()],
            )
          : widget.viewType == ViewType.grid
              ? LiveMatchGridView(
                  matches: searchState.isNotEmpty ? searchState : _liveMatches,
                )
              : LiveMatchListView(
                  matches: searchState.isNotEmpty ? searchState : _liveMatches,
                ),
      AsyncError(:final error, stackTrace: var _) => SliverList.list(children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ErrorStatusIconWidget(),
                const SizedBox(height: Sizes.p16),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: Sizes.p16),
                FilledButton(
                  onPressed: () => ref.refresh(getAllLiveMatchProvider.future),
                  child: Text("Try again".hardcoded),
                ),
                if (_nativeAd != null && _isNativeAdLoaded)
                  SafeArea(
                    child: SizedBox(
                      height: 400,
                      child: AdWidget(ad: _nativeAd!),
                    ),
                  ),
              ],
            ),
          ),
        ]),
      _ => SliverList.list(
          children: [
            Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ErrorStatusIconWidget(
                    icon: Icons.sports_soccer_outlined,
                  ),
                  const SizedBox(height: Sizes.p16),
                  Text(
                    "No matches available from the server".hardcoded,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: Sizes.p4),
                  Text(
                    "Please refresh again or come back later".hardcoded,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7)),
                  ),
                  const SizedBox(height: Sizes.p16),
                  FilledButton(
                    onPressed: () =>
                        ref.refresh(getAllLiveMatchProvider.future),
                    child: Text("Refresh".hardcoded),
                  ),
                  if (_nativeAd != null && _isNativeAdLoaded)
                    SafeArea(
                      child: SizedBox(
                        height: 400,
                        child: AdWidget(ad: _nativeAd!),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
    };
  }
}
