import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_detail/live_match_detail_screen.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_list/live_match_providers.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/async_value_ui.dart';
import 'package:vs_live/src/widgets/text/animated_live_text.dart';
import 'package:vs_live/src/widgets/text/animated_text.dart';

class LiveMatchListWidget extends ConsumerWidget {
  const LiveMatchListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      getAllLiveMatchProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(getAllLiveMatchProvider);

    return switch (state) {
      AsyncData(value: var liveMatches) when liveMatches.isNotEmpty =>
        LiveMatchList(matches: liveMatches),
      AsyncLoading() => const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(Sizes.p16),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      AsyncError(:final error, stackTrace: var _) => Text(error.toString()),
      _ => Text("No matches found".hardcoded),
    };
  }
}

class LiveMatchList extends ConsumerWidget {
  const LiveMatchList({
    super.key,
    required this.matches,
  });

  final List<LiveMatch> matches;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(getAllLiveMatchProvider.notifier).refresh();
      },
      child: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) => LiveMatchItem(match: matches[index]),
      ),
    );
  }
}

class LiveMatchItem extends ConsumerWidget {
  const LiveMatchItem({
    super.key,
    required this.match,
  });

  final LiveMatch match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title =
        "${match.homeTeam.name.substring(0, 3)} - ${match.awayTeam.name.substring(0, 3)}";

    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: GlassContainer(
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          onTap: () {
            // ref
            //     .read(videoLinkStateProvider.notifier)
            //     .setLink(match.links.first.url);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveMatchDetailScreen(match: match),
              ),
            );
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        match.league.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        match.startedDate,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Image
                    CachedNetworkImage(
                      imageUrl: match.homeTeam.logo,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                    const SizedBox(width: Sizes.p12),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                          ),
                          // const SizedBox(height: 4),
                          Text(
                            match.startedTime,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (match.liveStatus) ...[
                            const SizedBox(height: 8),
                            AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                AnimatedLiveText(
                                  "LIVE",
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: Sizes.p12),
                    CachedNetworkImage(
                      imageUrl: match.awayTeam.logo,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassContainer extends StatefulWidget {
  const GlassContainer(
      {super.key, this.child, this.onTap, this.width, this.height});

  final Widget? child;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapUp: (_) {
        setState(() => isPressed = true);
      },
      onTapDown: (_) {
        setState(() => isPressed = false);
      },
      child: Container(
        alignment: Alignment.center,
        child: ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AnimatedContainer(
              duration: const Duration(microseconds: 200),
              height: widget.width,
              width: widget.height,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 25,
                    spreadRadius: -5,
                  )
                ],
                color: Colors.white.withOpacity(isPressed ? 0.5 : 0.4),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(width: 2, color: Colors.white30),
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
