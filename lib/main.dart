import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:learner_space_app/Screens/Learner/UserPreferences.dart';
import 'package:provider/provider.dart';

import 'Screens/Learner/CourseDetails.dart';
import 'Screens/Learner/HelpAndSupport/ContactSupport.dart';
import 'Screens/Learner/HelpAndSupport/FAQ.dart';
import 'Screens/Learner/Profile/HelpAndSupport.dart';
import 'Screens/Learner/Profile/UserSettings.dart';
import 'Screens/Learner/Referrals.dart';
import 'Screens/Learner/SearchPage.dart';
import 'Screens/Learner/Settings/AppPreferences.dart';
import 'Screens/Learner/Settings/EditProfile.dart';
import 'Screens/Learner/Settings/PrivacyAndSecurity.dart';
import 'Screens/Learner/SplashScreen.dart';
import 'Screens/Learner/SubmitOutcomes.dart';
import 'Screens/Learner/UserAiChat.dart';
import 'Screens/Learner/UserCommunity.dart';
import 'Screens/Learner/UserOutcomes.dart';
import 'Screens/Learner/UserPostPage.dart';
import 'Screens/Learner/UserSkeleton.dart';

//#region Screens
import 'Screens/Learner/GetStartedPage.dart';
import 'Screens/Learner/Signup.dart';
import 'Screens/Learner/UserLogin.dart';
//#endregion

//#region Providers
import 'State/auth_provider.dart';
import 'State/theme_provider.dart';
//#endregion

/// 🔥 ENTRY POINT
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ✅ 1. Initialize Firebase FIRST
  await Firebase.initializeApp();

  /// ✅ 2. Initialize FCM safely
  await _initFCM();

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

/// 🔔 FCM SETUP (safe & reusable)
Future<void> _initFCM() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    /// iOS permission (safe on Android too)
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    final token = await messaging.getToken();
    debugPrint("🔥 FCM TOKEN: $token");

    /// 🔁 Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📩 Foreground notification: ${message.notification?.title}");
    });

    /// 🔁 App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("🚀 Opened from notification: ${message.data}");
    });
  } catch (e) {
    debugPrint("❌ FCM init failed: $e");
  }
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

      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Poppins",
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: "Poppins",
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandColor,
          brightness: Brightness.dark,
        ),
      ),

      initialRoute: "/splashScreen",
      routes: {
        "/splashScreen": (_) => const SplashScreen(),
        "/getStarted": (_) => const GetStartedPage(),
        "/login": (_) => const UserLogin(),
        "/signUp": (_) => const UserSignup(),
        "/home": (_) => const UserSkeleton(initialIndex: 0),
        "/courses": (_) => const UserSkeleton(initialIndex: 1),
        "/community": (_) => const UserSkeleton(initialIndex: 2),
        "/profile": (_) => const UserSkeleton(initialIndex: 3),
        "/aiChat": (_) => const UserAiChat(),
        "/courseDetails": (context) {
          final id = ModalRoute.of(context)!.settings.arguments as String;
          return CourseDetailPage(id: id);
        },
        "/referrals": (_) => const ReferralsPage(),
        "/userOutcomes": (_) => const UserOutcomes(),
        "/userPostPage": (_) => const UploadPostPage(),
        "/userSubmitOutcome": (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return SubmitOutcomePage(courseId: args['courseId']!);
        },
        "/help": (_) => const HelpSupportPage(),
        "/help/faq": (_) => FaqPage(),
        "/help/contact": (_) => const ContactSupportPage(),
        "/settings": (_) => const SettingsPage(),
        "/settings/preferences": (_) => const AppPreferencesPage(),
        "/settings/privacy-security": (_) => const PrivacyAndSecurityPage(),
        "/search": (_) => const SearchPage(),
        "/editProfile": (_) => const EditProfileScreen(),
        "/preferencesSetup": (_) => const PreferencesSetupScreen(),
      },
    );
  }
}

//#endregion
