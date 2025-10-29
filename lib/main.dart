import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//#region Screens
import 'package:learner_space_app/Screens/User/GetStartedPage.dart';
import 'package:learner_space_app/Screens/User/Signup.dart';
import 'package:learner_space_app/Screens/User/UserHome.dart';
import 'package:learner_space_app/Screens/User/UserLogin.dart';
//#endregion

//#region Providers
import 'package:learner_space_app/State/auth_provider.dart';
//#endregion

void main() {
  runApp(const MyApp());
}

//#region Main App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //#region Providers
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      //#endregion
      child: MaterialApp(
        //#region App Config
        title: 'Learner Space',
        debugShowCheckedModeBanner: false,
        //#endregion

        //#region Theme
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: "Poppins",
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          cardTheme: const CardThemeData(color: Colors.white),
          textTheme: const TextTheme(
            titleSmall: TextStyle(fontFamily: "Poppins"),
            titleMedium: TextStyle(fontFamily: "Poppins"),
            titleLarge: TextStyle(fontFamily: "Poppins"),
          ),
        ),
        //#endregion

        //#region Navigation
        initialRoute: "/get-started",
        routes: {
          "/get-started": (context) => const GetStartedPage(),
          "/login": (context) => const UserLogin(),
          "/signup": (context) => const UserSignup(),
          "/home": (context) => const UserHome(),
        },
        //#endregion
      ),
    );
  }
}

//#endregion
