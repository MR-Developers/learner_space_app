import 'package:flutter/material.dart';
import 'package:learner_space_app/Screens/Learner/CourseDetails.dart';
import 'package:learner_space_app/Screens/Learner/HelpAndSupport/ContactSupport.dart';
import 'package:learner_space_app/Screens/Learner/HelpAndSupport/FAQ.dart';
import 'package:learner_space_app/Screens/Learner/Profile/HelpAndSupport.dart';
import 'package:learner_space_app/Screens/Learner/Profile/UserSettings.dart';
import 'package:learner_space_app/Screens/Learner/Referrals.dart';
import 'package:learner_space_app/Screens/Learner/SearchPage.dart';
import 'package:learner_space_app/Screens/Learner/Settings/AppPreferences.dart';
import 'package:learner_space_app/Screens/Learner/Settings/EditProfile.dart';
import 'package:learner_space_app/Screens/Learner/Settings/PrivacyAndSecurity.dart';
import 'package:learner_space_app/Screens/Learner/SplashScreen.dart';
import 'package:learner_space_app/Screens/Learner/SubmitOutcomes.dart';
import 'package:learner_space_app/Screens/Learner/UserAiChat.dart';
import 'package:learner_space_app/Screens/Learner/UserCommunity.dart';
import 'package:learner_space_app/Screens/Learner/UserOutcomes.dart';
import 'package:learner_space_app/Screens/Learner/UserPostPage.dart';
import 'package:learner_space_app/Screens/Learner/UserSkeleton.dart';
import 'package:provider/provider.dart';

//#region Screens
import 'package:learner_space_app/Screens/Learner/GetStartedPage.dart';
import 'package:learner_space_app/Screens/Learner/Signup.dart';
import 'package:learner_space_app/Screens/Learner/UserLogin.dart';
//#endregion

//#region Providers
import 'package:learner_space_app/State/auth_provider.dart';
import 'package:learner_space_app/State/theme_provider.dart';
//#endregion

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

//#region Main App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color brandColor = Color(0xFFEF7C08);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Learner Space',
      debugShowCheckedModeBanner: false,

      // 🌗 DARK MODE CONTROL
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // 🌞 LIGHT THEME
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Poppins",
        colorScheme:
            ColorScheme.fromSeed(
              seedColor: brandColor,
              brightness: Brightness.light,
            ).copyWith(
              surface: Colors.white,
              surfaceContainerLowest: Colors.white,
              surfaceContainerLow: Colors.white,
            ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
      ),

      // 🌙 DARK THEME
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: "Poppins",
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandColor,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(elevation: 0),
      ),

      // 🚦 Navigation
      initialRoute: "/splashScreen",
      routes: {
        "/splashScreen": (context) => const SplashScreen(),
        "/getStarted": (context) => const GetStartedPage(),
        "/login": (context) => const UserLogin(),
        "/signUp": (context) => const UserSignup(),
        "/home": (context) => const UserSkeleton(initialIndex: 0),
        "/courses": (context) => const UserSkeleton(initialIndex: 1),
        "/community": (context) => const UserSkeleton(initialIndex: 2),
        "/profile": (context) => const UserSkeleton(initialIndex: 3),
        "/aiChat": (context) => const UserAiChat(),
        "/courseDetails": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return CourseDetailPage(id: args);
        },
        "/referrals": (context) => const ReferralsPage(),
        "/userOutcomes": (context) => const UserOutcomes(),
        "/userPostPage": (context) => const UploadPostPage(),
        "/userSubmitOutcome": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return SubmitOutcomePage(courseId: args['courseId']!);
        },
        "/help": (context) => const HelpSupportPage(),
        "/help/faq": (context) => FaqPage(),
        "/help/contact": (context) => const ContactSupportPage(),

        "/settings": (context) => const SettingsPage(),
        "/settings/preferences": (context) => const AppPreferencesPage(),
        "/settings/privacy-security": (context) =>
            const PrivacyAndSecurityPage(),
        "/search": (context) => SearchPage(),
        "/editProfile": (context) => EditProfileScreen(),
      },
    );
  }
}

//#endregion
