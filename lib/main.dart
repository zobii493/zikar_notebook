import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:naqashbandi_shazli/provider/counter_provider.dart';
import 'package:naqashbandi_shazli/provider/fezunoor_provider.dart';
import 'package:naqashbandi_shazli/provider/ismezat_kalmasharif_provider.dart';
import 'package:naqashbandi_shazli/provider/progressbar_provider.dart';
import 'package:naqashbandi_shazli/registrations_screens/login.dart';
import 'package:naqashbandi_shazli/registrations_screens/welcome.dart';
import 'package:naqashbandi_shazli/screens/GNav.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background message handle karne ke liye
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
  final user = FirebaseAuth.instance.currentUser; // check user login

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CounterProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => IsmezatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FezuNoorProvider(),
        ),
        ChangeNotifierProvider(create: (_)=>ProgressProvider(),),
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

  const MyApp(
      {super.key, required this.isFirstLaunch, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    Widget homeWidget;

    if (isFirstLaunch) {
      homeWidget = Welcome(); // Pehli dafa open
    } else if (isLoggedIn) {
      homeWidget = BottomNavBar(
        selectedIndex: 0,
        onTabChange: (index) {},
      ); // User already login hai
    } else {
      homeWidget = Login(); // Logout hone ke baad
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeWidget,
    );
  }
}

