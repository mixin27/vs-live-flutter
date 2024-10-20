import 'package:flutter/material.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';

import 'widgets/live_match_list_widget.dart';

class LiveMatchScreen extends StatelessWidget {
  const LiveMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Matches".hardcoded),
      ),
      body: const LiveMatchListWidget(),
    );
  }
}
