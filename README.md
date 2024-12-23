# Billion Sport Live Application

> Enjoy free live sports streaming and match highlights on Billion Sport Live—your go-to app for real-time sports action.

Billion Sport Live brings you the thrill of live sports right to your fingertips! With a user-friendly design and a focus on delivering high-quality streaming, Billion Sport Live lets you:

- **Watch Live Matches for Free** – Access real-time streaming of your favorite sports without any cost. From exciting tournaments to nail-biting finals, enjoy every moment live.
- **Catch Up with Free Highlights** – Missed the match? No worries! Billion Sport Live offers free highlight videos, so you can relive every key moment.

Stay connected to the sports you love, anytime, anywhere, with Billion Sport Live. Download now and never miss a game again!

### Remote Config

```json
{
  "live_match_list_page": "{     \"native\": true,     \"banner\": true,     \"interstitial\": true,     \"rewarded\": true }",
  "live_match_detail_page": "{     \"native\": true,     \"banner\": true,     \"interstitial\": true,     \"rewarded\": true }",
  "highlight_list_page": "{     \"native\": true,     \"banner\": true,     \"interstitial\": true,     \"rewarded\": true }",
  "latest_build": "10",
  "latest_version": "1.0.9",
  "force_update": "true",
  "banner_ad": "ca-app-pub-7567997114394639/8648546201",
  "interstitial_ad": "ca-app-pub-7567997114394639/1475405831",
  "native_ad": "ca-app-pub-7567997114394639/9425876604",
  "rewarded_ad": "ca-app-pub-7567997114394639/8288226195",
  "show_ads": "true",
  "app_open_ad": "ca-app-pub-7567997114394639/7748304172",
  "show_app_open_ad": "true",
  "show_banner_ad": "true",
  "show_native_ad": "true",
  "show_interstitial_ad": "true",
  "show_rewarded_ad": "true",
  "show_ads_in_match_list": "true",
  "show_ads_in_match_detail": "true",
  "show_ads_in_highlight_list": "true"
}
```


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
