import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vs_live/src/config/constants/app_strings.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Markdown(
        data: AppStrings.privacyPolicyMarkdown,
        onTapLink: (text, href, title) async {
          if (href == null) return;
          final url = Uri.parse(href);
          if (!await launchUrl(url)) {
            throw Exception('Could not launch $url');
          }
        },
      ),
    );
  }
}
