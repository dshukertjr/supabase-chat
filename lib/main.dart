import 'package:flutter/material.dart';
import 'package:supabasechat/pages/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sinple Chat App',
      theme: ThemeData.dark().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: Colors.black,
          textTheme: TextTheme(
            headline6: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        primaryColor: Colors.orange,
        accentColor: Colors.orange,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(primary: Colors.orange),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: Colors.orange),
        ),
      ),
      home: SplashPage(),
    );
  }
}
