import 'package:flutter/material.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings".hardcoded),
      ),
    );
  }
}
