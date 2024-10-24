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

    final icon = switch (state) {
      ThemeMode.dark => const Icon(Icons.dark_mode_outlined),
      ThemeMode.light => const Icon(Icons.light_mode_outlined),
      _ => null,
    };

    return PopupMenuButton(
      icon: icon,
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
                  Icons.settings_system_daydream_outlined,
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
                  Icons.dark_mode_outlined,
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
                  Icons.light_mode_outlined,
                ),
                title: Text("Light".hardcoded),
              ),
            ),
        ];
      },
    );
  }
}
