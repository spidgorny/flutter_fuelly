import 'package:flutter/material.dart';
import 'package:flutter_fuelly/CheckPermissions.dart';

import 'NavigationService.dart';
import 'locator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    setupLocator();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuelly Bon Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      home: CheckPermissions(title: 'Fuelly Bon Scanner'),
    );
  }
}
