import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vs_live/src/providers/shared_preferences_provider.dart';

part 'onboarding_repository.g.dart';

class OnboardingRepository {
  OnboardingRepository(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  static const onboardingCompleteKey = 'onboardingComplete';

  Future<void> setOnboardingComplete() async {
    await sharedPreferences.setBool(onboardingCompleteKey, true);
  }

  bool isOnboardingComplete() =>
      sharedPreferences.getBool(onboardingCompleteKey) ?? false;
}

@Riverpod(keepAlive: true)
Future<OnboardingRepository> onboardingRepository(Ref ref) async {
  final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
  return OnboardingRepository(sharedPreferences);
}
