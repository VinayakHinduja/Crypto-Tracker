import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'price_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const PriceScreen(),
      theme: ThemeData.dark().copyWith(
          primaryColor: Colors.black,
          useMaterial3: true,
          cupertinoOverrideTheme: const CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              pickerTextStyle: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          scaffoldBackgroundColor: const Color(0xFF303030)),
    );
  }
}
