import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_indicator/loading_indicator.dart'; // Import the loading indicator package
import 'package:naqashbandi_shazli/widgets/top_snack_bar.dart';
import '../widgets/top_curve_shade.dart';
import 'login.dart';

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isEmailVerified = false;
  bool isLoading = false;

  void _showSnackBar(String message, Color color) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top,
        left: 8,
        right: 8,
        child: TopSnackBar(
          message: message,
          backgroundColor: color,
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    isEmailVerified = user?.emailVerified ?? false;

    if (!isEmailVerified) {
      // Start periodic check if email has been verified
      Future.delayed(Duration(seconds: 5), checkEmailVerified);
    }
  }

  Future<void> checkEmailVerified() async {
    user = _auth.currentUser;
    await user?.reload(); // Reload the user to get updated info
    setState(() {
      isEmailVerified = user?.emailVerified ?? false;
    });

    if (!isEmailVerified) {
      // Recheck after some time
      Future.delayed(Duration(seconds: 5), checkEmailVerified);
    }
  }

  void _resendVerificationEmail() async {
    setState(() {
      isLoading = true;
    });
    try {
      await user?.sendEmailVerification();
      _showSnackBar('Verification email sent again!', Colors.amber.shade300);
    } catch (e) {
      _showSnackBar('Failed to resend email verification.', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            // Adjust height as needed
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Email Verification',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'AutourOne'),
                ),
                SizedBox(height: 20),
                Text(
                  isEmailVerified
                      ? 'Your email is verified. You can now continue.'
                      : 'A verification email has been sent to ${user?.email}. Please check your inbox.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                if (isEmailVerified)
                  MaterialButton(
                    height: 60,
                    minWidth: double.infinity,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onPressed: () {
                      // Redirect to login page when verified
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    color: Colors.blue,
                    child: isLoading
                        ? SizedBox(
                            width: 50,
                            height: 50,
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballSpinFadeLoader,
                              colors: [Colors.amber, Colors.purple],
                            ),
                          )
                        : Text(
                            'Continue',
                            style: TextStyle(color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                  )
                else
                  Column(
                    children: [
                      MaterialButton(
                        elevation: 10,
                        height: 60,
                        minWidth: double.infinity,
                        onPressed: _resendVerificationEmail,
                        color: Colors.amber.shade300,
                        child: isLoading
                            ? SizedBox(
                                width: 50,
                                height: 50,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballSpinFadeLoader,
                                  colors: [Colors.blue, Colors.purple],
                                ),
                              )
                            : Text(
                                'Resend Email',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
