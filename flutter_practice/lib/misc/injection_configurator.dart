import 'package:event_bus_plus/res/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'injection_configurator.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.init();

  registerCustomDependencies();
}

void registerCustomDependencies() {
  getIt.registerSingleton(InternetConnectionChecker());
  getIt.registerSingleton(EventBus());
  getIt.registerSingleton(ImagePicker());
}
