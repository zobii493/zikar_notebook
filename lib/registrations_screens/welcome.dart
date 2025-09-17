import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/top_curve_shade.dart';
import 'signup.dart';
import 'login.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool _isLoading = false;

  void _navigateTo(BuildContext context, Widget page) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Simulate a delay to show loading, remove in production
    await Future.delayed(Duration(seconds: 2));

    Navigator.push(context, MaterialPageRoute(builder: (context) => page))
        .then((_) {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('isFirstLaunch', false);});
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight*0.23,
            child: ClipPath(
              clipper: FullWidthWavyTopRightClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical:screenHeight * 0.11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AutourOne',
                    ),
                  ),
                  DefaultTextStyle(style: TextStyle(fontSize: 16,fontFamily: 'AutourOne',color: Colors.black),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText('Hi, Welcome to Zikar NoteBook!'),
                      ],
                      isRepeatingAnimation: true,
                    ),),
                  Container(
                    height: screenHeight * 0.31,
                    width: double.infinity,
                    child: Lottie.asset('assets/web-design-layout.json'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: MaterialButton(
                      height: 60,
                      minWidth: double.infinity,
                      onPressed: () => _navigateTo(context, Login()),
                      // Use the navigation method
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: MaterialButton(
                      height: 60,
                      color: Colors.blue,
                      minWidth: double.infinity,
                      onPressed: () => _navigateTo(context, Signup()),
                      // Use the navigation method
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) // Show the loading indicator if isLoading is true
            Center(
              child: SizedBox(
                width: 70,
                height: 70,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballSpinFadeLoader,
                  // Required, The loading type of the widget
                  colors: const [Colors.blue, Colors.purple],
                  // Optional, The color collections
                  strokeWidth:
                      0, // Optional, The stroke of the line, only applicable to widget which contains line
                ),
              ),
            ),
        ],
      ),
    );
  }
}
