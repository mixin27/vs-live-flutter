import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/onboarding/presentation/onboarding_controller.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/responsive_center.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);

    return Scaffold(
      body: ResponsiveCenter(
        maxContentWidth: 450,
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 50,
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  "assets/images/sport_live_logo.png",
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            gapH16,
            Text(
              'Welcome to Billion Sport Live.\nEnjoy watching!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            gapH16,
            FilledButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      await ref
                          .read(onboardingControllerProvider.notifier)
                          .completeOnboarding();
                      if (context.mounted) {
                        // go to sign in page after completing onboarding
                        context.goNamed(AppRoute.home.name);
                      }
                    },
              child: Text('Get Started'.hardcoded),
            ),
            gapH16,
          ],
        ),
      ),
    );
  }
}
