import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/firebase_options.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';
import 'package:flutter_practice/ui/pages/login_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'misc/strings.dart';

Future configureFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureFirebase();
  configureDependencies();

  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        translations: Strings(),
        locale: const Locale('en', 'US'),
        home: const LoginPage(),
      );
}
