import 'package:flutter/material.dart';

import 'package:ihc_app/screens/screens.dart';

class AppRoutes {
  static const initialRoute = 'home';

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    appRoutes.addAll(
      {
        'home': (BuildContext context) => const HomeScreen(),
        'sensor1': (BuildContext context) => const Sensor1Screen(),
        'sensor2': (BuildContext context) => const Sensor2Screen(),
        'shake': (BuildContext context) => const ShakeScreen(),
      },
    );

    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const AlertScreen(),
    );
  }
}
