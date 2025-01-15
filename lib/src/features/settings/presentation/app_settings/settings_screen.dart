import 'package:flutter/material.dart';
import 'package:vs_live/src/utils/analytics_util.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/settings/force_mobile_layout_list_tile.dart';
import 'package:vs_live/src/widgets/settings/notification_list_tile.dart';
import 'package:vs_live/src/widgets/settings/privacy_policy_list_tile.dart';
import 'package:vs_live/src/widgets/theme/theme_mode_switch_tile.dart';
import 'package:wiredash/wiredash.dart';

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
          const ForceMobileLayoutListTile(),
          const ThemeModeSwitchTile(),
          const PrivacyPolicyListTile(),
          ListTile(
            onTap: () {
              Wiredash.of(context).show(inheritMaterialTheme: true);
            },
            leading: const Icon(Icons.feedback_outlined),
            title: Text("Feedback".hardcoded),
          ),
        ],
      ),
    );
  }
}
