import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/providers/video_link_provider.dart';
import 'package:vs_live/src/utils/extensions/flutter_extensions.dart';
import 'package:vs_live/src/widgets/video_player/my_chewie_vido_player.dart';

class LiveMatchDetailScreen extends ConsumerStatefulWidget {
  const LiveMatchDetailScreen({
    super.key,
    required this.match,
  });

  final LiveMatch match;

  @override
  ConsumerState<LiveMatchDetailScreen> createState() =>
      _LiveMatchDetailScreenState();
}

class _LiveMatchDetailScreenState extends ConsumerState<LiveMatchDetailScreen> {
  @override
  void initState() {
    super.initState();

    final links = widget.match.links;
    // Future.microtask(
    //   () => ref.read(videoLinkStateProvider.notifier).setLink(
    //         "https://v2-stream.scoreswift.xyz/BBC_15_Uk/multy.m3u8?match_id=11927529&s_id=1&t_id=1795&stats=statssport.inplaynet.tech&timestamp=1729446553&key=VTJGc2RHVmtYMTlrb253SDhuRTExam5ocHQrRkVNRloxeFdmNjBraGVHOVh6ZkFqQlZwcm1ZY2lSSjdjZzNnczFaNXZRM094bTlydEhtaHhKNDY1MjhyaWlMdXErZXRQS2RjZGVJdCt2U3N4Z3FKYXZneTlVYURodjgxd1JqM2I4WXduWDZ0cXlQMklDNWlTNG5xcnhJSThhSG16UXU1RFlWZ2hZczFFV3I4PQ==",
    //       ),
    // );
    Future.microtask(
      () => ref.read(videoLinkStateProvider.notifier).setLink(links.first.url),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title =
        "${widget.match.homeTeam.name} - ${widget.match.awayTeam.name}";

    final links = widget.match.links;
    final videoLink = ref.watch(videoLinkStateProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: context.screenWidth,
              height: context.screenWidth * 9.0 / 16.0 + 20,
              child: const MyChewieVideoPlayer(isLive: true),
            ),
            const SizedBox(height: Sizes.p16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: Sizes.p20),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: links.length,
                itemBuilder: (context, index) {
                  final link = links[index];
                  return ListTile(
                    onTap: () {
                      // ref.read(videoLinkStateProvider.notifier).setLink(
                      //     "https://playasport.envivo.cloud/live/a0e56e32f3be2d7f.m3u8?txSecret=06cbc7b3c50f0c4d69c9511dbf64dcdd&txTime=6716918B");
                      ref
                          .read(videoLinkStateProvider.notifier)
                          .setLink(link.url);
                    },
                    title: Text(link.name),
                    selected: videoLink == link.url,
                    selectedColor: Theme.of(context).colorScheme.onPrimary,
                    selectedTileColor: Theme.of(context).colorScheme.primary,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: Sizes.p16),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
