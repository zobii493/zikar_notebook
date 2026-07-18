import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:naqashbandi_shazli/core/app_theme.dart';
import 'package:naqashbandi_shazli/core/username_cache.dart';
import 'package:naqashbandi_shazli/registrations_screens/login.dart';
import 'package:naqashbandi_shazli/registrations_screens/welcome.dart';
import 'package:naqashbandi_shazli/GNav.dart';
import 'package:naqashbandi_shazli/screens/splash_screen/splash_screen_page.dart';
import 'package:naqashbandi_shazli/viewmodel/bottom_nav_provider.dart';
import 'package:naqashbandi_shazli/viewmodel/counter_provider.dart';
import 'package:naqashbandi_shazli/viewmodel/fezunoor_provider.dart';
import 'package:naqashbandi_shazli/viewmodel/ismezat_kalmasharif_provider.dart';
import 'package:naqashbandi_shazli/viewmodel/progressbar_provider.dart';
import 'package:naqashbandi_shazli/viewmodel/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBV677SHIjWAqhphSqqK_-5Jmf9b1qBvv8',
      appId: '1:1009668325193:android:d859f5754a2e5e68cbe498',
      messagingSenderId: '1009668325193',
      projectId: 'shazli-notebook',
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  final user = FirebaseAuth.instance.currentUser;

  // Load the saved theme BEFORE runApp so there's no light-mode flash
  // on startup for users who picked dark.
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeMode();
  await UsernameCache.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        ChangeNotifierProvider(create: (_) => IsmezatProvider()),
        ChangeNotifierProvider(create: (_) => FezuNoorProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
      ],
      child: MyApp(
        isFirstLaunch: isFirstLaunch,
        isLoggedIn: user != null,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isFirstLaunch,
    required this.isLoggedIn,
  });

  Widget _resolveNextScreen() {
    if (isFirstLaunch) return const Welcome();
    if (isLoggedIn) return BottomNavBar();
    return const Login();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      home: SplashScreen(nextScreenBuilder: _resolveNextScreen),
    );
  }
}