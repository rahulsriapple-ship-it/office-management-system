import 'core/config/app_config.dart';
import 'main.dart' as app;

void main() {
  AppConfig.initialize(environmentOverride: AppEnvironment.local);
  app.bootstrap();
}
