import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vs_live/src/config/constants/app_strings.dart';
import 'package:vs_live/src/utils/analytics_util.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  void initState() {
    // Record a visit to this page.
    AnalyticsUtil.logScreenView(screenName: 'PrivacyPolicyPage');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: GptMarkdown(
            AppStrings.privacyPolicyMarkdown,
            onLinkTap: (url, title) async {
              final uri = Uri.parse(url);
              if (!await launchUrl(uri)) {
                throw Exception('Could not launch $url');
              }
            },
          ),
        ),
      ),
    );
  }
}
