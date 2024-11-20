import 'package:flutter/material.dart';
import 'package:vs_live/src/utils/analytics_util.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/settings/notification_list_tile.dart';
import 'package:vs_live/src/widgets/settings/privacy_policy_list_tile.dart';
import 'package:vs_live/src/widgets/theme/theme_mode_switch_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    // Record a visit to this page.
    AnalyticsUtil.logScreenView(screenName: 'SettingsScreen');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings".hardcoded),
      ),
      body: ListView(
        children: [
          const NotificationSwitchListTile(),
          const ThemeModeSwitchTile(),
          const PrivacyPolicyListTile(),
          AboutListTile(
            icon: const Icon(Icons.info_outline),
            applicationName: "Billion Sport Live",
            applicationVersion: 'v1.0.1',
            applicationIcon: Image.asset(
              "assets/images/logo_gradient.png",
              width: 30,
              height: 30,
            ),
            applicationLegalese: 'Copyright (c) 2024 Billion Sport Live',
            child: Text("License".hardcoded),
          ),
        ],
      ),
    );
  }
}
