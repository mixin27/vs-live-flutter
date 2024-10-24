import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';

class PrivacyPolicyListTile extends StatelessWidget {
  const PrivacyPolicyListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.pushNamed(AppRoute.privacyPolicy.name);
      },
      leading: const Icon(Icons.shield_outlined),
      title: Text("Privacy policy".hardcoded),
      trailing: IconButton(
        onPressed: () async {
          final url = Uri.parse(
            'https://www.termsfeed.com/live/f8d439ed-1831-4fc2-98a4-954a0694400f',
          );
          if (!await launchUrl(url)) {
            throw Exception('Could not launch $url');
          }
        },
        icon: Icon(
          Icons.open_in_new_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
