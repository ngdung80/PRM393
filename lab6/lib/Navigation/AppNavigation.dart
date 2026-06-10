import 'package:flutter/material.dart';
import '../Views/GenreScreen.dart';

class AppNavigation {
  static const String initialRoute = '/';

  static Map<String, WidgetBuilder> get routes => {
    initialRoute: (context) => const GenreScreen(),
  };
}
