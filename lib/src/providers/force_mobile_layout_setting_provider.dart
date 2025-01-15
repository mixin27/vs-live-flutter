import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vs_live/src/utils/prefs_manager.dart';

part 'force_mobile_layout_setting_provider.g.dart';

const PreferenceKey forceMobileLayoutKey = 'force_mobile_layout';

@Riverpod(keepAlive: true)
class ForceMobileLayoutSetting extends _$ForceMobileLayoutSetting {
  bool _getCachedSetting() {
    final prefs = ref.read(preferenceManagerProvider);
    final isForceMobileLayout = prefs.getData<bool>(forceMobileLayoutKey);
    return isForceMobileLayout ?? false;
  }

  @override
  bool build() {
    return _getCachedSetting();
  }

  void toggle([bool value = false]) {
    final prefs = ref.read(preferenceManagerProvider);
    prefs.setData<bool>(value, forceMobileLayoutKey);

    state = _getCachedSetting();
  }
}
