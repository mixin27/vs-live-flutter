import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/providers/app_theme_provider.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/utils/prefs_manager.dart';

const PreferenceKey keyTheme = 'key_theme';

class ThemeModeSwitchTile extends HookConsumerWidget {
  const ThemeModeSwitchTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);

    void changeTheme(ThemeMode mode) {
      ref.read(appThemeModeProvider.notifier).setThemeMode(mode);
      context.pop();
    }

    void handleTap() {
      showAdaptiveDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Theme".hardcoded),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () => changeTheme(ThemeMode.system),
                title: Text("System".hardcoded),
                trailing: themeMode == ThemeMode.system
                    ? const Icon(Icons.check_outlined, color: Colors.green)
                    : null,
              ),
              ListTile(
                onTap: () => changeTheme(ThemeMode.light),
                title: Text("Light".hardcoded),
                trailing: themeMode == ThemeMode.light
                    ? const Icon(Icons.check_outlined, color: Colors.green)
                    : null,
              ),
              ListTile(
                onTap: () => changeTheme(ThemeMode.dark),
                title: Text("Dark".hardcoded),
                trailing: themeMode == ThemeMode.dark
                    ? const Icon(Icons.check_outlined, color: Colors.green)
                    : null,
              ),
            ],
          ),
        ),
      );
    }

    return ListTile(
      onTap: handleTap,
      leading: const Icon(CupertinoIcons.moon_circle),
      title: const Text('Theme'),
      subtitle: const Text('Change theme mode.'),
    );
  }
}
