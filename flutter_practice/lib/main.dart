import 'package:flutter/material.dart';
import 'package:flutter_practice/ui/pages/login_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'misc/strings.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Strings(),
      locale: const Locale('en', 'US'),
      home: const LoginPage(),
    );
  }
}
