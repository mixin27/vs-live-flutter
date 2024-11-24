# VS Football Live Application

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Test Deep Links

Test `bsl://open.bsl.app:`

Use ADB to simulate the custom schema:

```bash
adb shell am start -a android.intent.action.VIEW -d "bsl://open.bsl.app" com.billion.sport_live
```

Test `bls://kyawzayartun.com:`

Use ADB for the HTTPS link:

```bash
adb shell am start -a android.intent.action.VIEW -d "bsl://kyawzayartun.com" com.billion.sport_live
```

```bash
adb shell am start -a android.intent.action.VIEW -d "https://play.google.com/store/apps/details?id=com.billion.sport_live" com.billion.sport_live
```

### Test App Links

**Test with ADB:**

Run the following command to test:

```bash
adb shell am start -a android.intent.action.VIEW -d "https://www.kyawzayartun.com/bsl" com.billion.sport_live
```

```bash
adb shell am start -a android.intent.action.VIEW -d "https://kyawzayartun.com/bsl" com.billion.sport_live
```