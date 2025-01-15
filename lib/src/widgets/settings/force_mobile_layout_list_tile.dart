import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/providers/force_mobile_layout_setting_provider.dart';
import 'package:vs_live/src/utils/prefs_manager.dart';

const PreferenceKey keyTheme = 'key_theme';

class ForceMobileLayoutListTile extends HookConsumerWidget {
  const ForceMobileLayoutListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isForceMobileLayout = ref.watch(forceMobileLayoutSettingProvider);

    return SwitchListTile.adaptive(
      value: isForceMobileLayout,
      onChanged: (newValue) async {
        ref.read(forceMobileLayoutSettingProvider.notifier).toggle(newValue);
      },
      secondary: const Icon(Icons.mobile_friendly_outlined),
      title: const Text('Mobile Layout'),
      subtitle: const Text('Force to use mobile layout only.'),
    );
  }
}
