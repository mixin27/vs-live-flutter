import 'package:flutter/material.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VS Football Live".hardcoded),
      ),
    );
  }
}
