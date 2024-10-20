import 'package:flutter/material.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/widgets/video_player/my_video_player.dart';

class LiveMatchDetailScreen extends StatefulWidget {
  const LiveMatchDetailScreen({
    super.key,
    required this.match,
  });

  final LiveMatch match;

  @override
  State<LiveMatchDetailScreen> createState() => _LiveMatchDetailScreenState();
}

class _LiveMatchDetailScreenState extends State<LiveMatchDetailScreen> {
  String _selectedLink = "";

  @override
  void initState() {
    super.initState();
    _selectedLink = widget.match.links.first.url;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final title =
        "${widget.match.homeTeam.name} - ${widget.match.awayTeam.name}";

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MyVideoPlayer(videoUrl: _selectedLink, isLive: true),
            const SizedBox(height: Sizes.p16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: Sizes.p20),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: widget.match.links.length,
                itemBuilder: (context, index) {
                  final link = widget.match.links[index];
                  return ListTile(
                    onTap: () {
                      setState(() {
                        _selectedLink = link.url;
                      });
                    },
                    title: Text(link.name),
                    selected: _selectedLink == link.url,
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
