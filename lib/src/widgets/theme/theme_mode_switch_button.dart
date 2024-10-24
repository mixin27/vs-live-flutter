import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/providers/app_theme_provider.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';

class ThemeModeSwitchButton extends ConsumerWidget {
  const ThemeModeSwitchButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appThemeModeProvider);

    return PopupMenuButton(
      icon: const Icon(CupertinoIcons.moon_circle),
      itemBuilder: (context) {
        return [
          if (state != ThemeMode.system)
            PopupMenuItem(
              onTap: () {
                ref
                    .read(appThemeModeProvider.notifier)
                    .setThemeMode(ThemeMode.system);
              },
              child: ListTile(
                leading: const Icon(
                  CupertinoIcons.settings,
                ),
                title: Text("System".hardcoded),
              ),
            ),
          if (state != ThemeMode.dark)
            PopupMenuItem(
              onTap: () {
                ref
                    .read(appThemeModeProvider.notifier)
                    .setThemeMode(ThemeMode.dark);
              },
              child: ListTile(
                leading: const Icon(
                  CupertinoIcons.moon,
                ),
                title: Text("Dark".hardcoded),
              ),
            ),
          if (state != ThemeMode.light)
            PopupMenuItem(
              onTap: () {
                ref
                    .read(appThemeModeProvider.notifier)
                    .setThemeMode(ThemeMode.light);
              },
              child: ListTile(
                leading: const Icon(
                  CupertinoIcons.sun_max,
                ),
                title: Text("Light".hardcoded),
              ),
            ),
        ];
      },
    );
  }
}
