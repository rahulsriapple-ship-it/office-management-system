enum AppEnvironment {
  local,
  uat,
  prod;

  static AppEnvironment fromName(String value) {
    switch (value.toLowerCase()) {
      case 'uat':
        return AppEnvironment.uat;
      case 'prod':
      case 'production':
        return AppEnvironment.prod;
      case 'local':
      default:
        return AppEnvironment.local;
    }
  }
}

class AppConfig {
  static AppEnvironment? _environmentOverride;

  static void initialize({AppEnvironment? environmentOverride, }) {
    _environmentOverride = environmentOverride;
  }

  static const String _environmentName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'local',
  );

  static const String _apiBaseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const String _enableApiLogs = String.fromEnvironment(
    'ENABLE_API_LOGS',
    defaultValue: '',
  );

  static AppEnvironment get environment =>
      _environmentOverride ?? AppEnvironment.fromName(_environmentName);

  static String get environmentLabel => environment.name.toUpperCase();

  static bool get shouldLogApi {
    if (_enableApiLogs.isNotEmpty) {
      return _enableApiLogs.toLowerCase() == 'true';
    }
    return environment == AppEnvironment.local ||
        environment == AppEnvironment.uat;
  }

  static String get apiBaseUrl {
    if (_apiBaseUrlOverride.isNotEmpty) {
      return _apiBaseUrlOverride;
    }

    switch (environment) {
      case AppEnvironment.local:
        return 'http://localhost:5050/api';
      case AppEnvironment.uat:
        return 'https://uat-api.yourdomain.com/api';
      case AppEnvironment.prod:
        return 'https://api.yourdomain.com/api';
    }
  }
}
