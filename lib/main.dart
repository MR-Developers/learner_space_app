import 'package:flutter/material.dart';
import 'package:learner_space_app/User/GetStartedPage.dart';
import 'package:learner_space_app/User/UserHome.dart';
import 'package:learner_space_app/User/UserLogin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learner Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(color: Colors.white),
        textTheme: TextTheme(
          titleSmall: TextStyle(fontFamily: "Poppins"),
          titleLarge: TextStyle(fontFamily: "Poppins"),
          titleMedium: TextStyle(fontFamily: "Poppins"),
        ),
      ),
      home: GetStartedPage(),
      routes: {
        "/login": (context) => UserLogin(),
        "/home": (context) => UserHome(),
      },
    );
  }
}
