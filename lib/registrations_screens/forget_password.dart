import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import '../widgets/top_snack_bar.dart';
import '../widgets/top_curve_shade.dart';
import 'login.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  // Function to send password reset email
  Future<void> _resetPassword(String email) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        _isLoading = false;
      });

      // Show success dialog after email is sent
      _showResetPasswordDialog();

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error: ${e.toString()}', Colors.red);
    }
  }

  // Function to validate and handle form submission
  void _submit() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();

      // Trigger password reset
      _resetPassword(email);
    }
  }

  // Function to show a dialog box after email is sent
  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Password Reset Email Sent"),
          content: Text(
              "We have sent a password reset email. Please check your inbox and follow the instructions to reset your password."),
          actions: [
            Center(
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.blue,
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    // Navigate to the login page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Login()), // Replace with your login page
                    );
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
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
          SingleChildScrollView(
            child: Form(
              key: _formKey, // Add form key for validation
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 60,),
                    Row(
                      children: [
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.angleLeft, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(width: 30,),
                        Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'AutourOne',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Lottie.asset('assets/loti2.json'),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 12),
                          child: FaIcon(FontAwesomeIcons.solidEnvelope,
                              color: Colors.grey.shade400),
                        ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50),
                    MaterialButton(
                      height: 60,
                      minWidth: double.infinity,
                      onPressed: _submit,
                      color: Colors.blue,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 50,
                              height: 50,
                              child: LoadingIndicator(
                                indicatorType: Indicator.ballSpinFadeLoader,
                                // Required
                                colors: const [Colors.amber, Colors.purple],
                                // Optional
                                strokeWidth: 0, // Optional
                              ),
                            )
                          : Text(
                              'Send Email',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}