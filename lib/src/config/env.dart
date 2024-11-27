import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  static final String baseUrl = _Env.baseUrl;

  // @EnviedField(varName: 'API_KEY', obfuscate: true)
  // static final String apiKey = _Env.apiKey;

  @EnviedField(varName: 'ONESIGNAL_APP_ID', obfuscate: true)
  static final String onesignalAppId = _Env.onesignalAppId;

  @EnviedField(varName: 'HIGHLIGHT_API_KEY', obfuscate: true)
  static final String highlightApiKey = _Env.highlightApiKey;

  @EnviedField(varName: 'WIREDASH_PROJECT_ID', obfuscate: true)
  static final String wiredashProjectId = _Env.wiredashProjectId;

  @EnviedField(varName: 'WIREDASH_SECRET', obfuscate: true)
  static final String wiredashSecret = _Env.wiredashSecret;
}
