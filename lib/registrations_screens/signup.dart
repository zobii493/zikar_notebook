import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:naqashbandi_shazli/widgets/top_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/top_curve_shade.dart';
import 'email_verification.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _ConfirmpasswordVisible = false;
  bool _isLoading = false; // Loading state

  String? _errorMessage;

  Future<bool> isEmailValid(String email) async {
    final apiKey = '1e0e9911817b47c69d39d7b9b6a13616';  // Replace with your email verification API key
    final response = await http.get(
      Uri.parse('https://emailvalidation.abstractapi.com/v1/?api_key=$apiKey&email=$email'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['deliverable'];  // true if the email exists
    } else {
      return false;  // Something went wrong, assume email is invalid
    }
  }

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
            child: Padding(
              padding: const EdgeInsets.only(top: 80.0, right: 20, left: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AutourOne',
                      ),
                    ),
                    SizedBox(height: 10),
                    DefaultTextStyle(style: TextStyle(fontSize: 16,fontFamily: 'AutourOne',color: Colors.black),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          WavyAnimatedText('Create an account..'),
                        ],
                        isRepeatingAnimation: true,
                      ),),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10),
                          child: FaIcon(
                            FontAwesomeIcons.solidUser,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 12),
                          child: FaIcon(
                            FontAwesomeIcons.solidEnvelope,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        if(!value.endsWith('@gmail.com')){
                          return 'Please use a Gmail address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusColor: Colors.black,
                        floatingLabelStyle: TextStyle(color: Colors.black),
                        labelText: 'Password',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: FaIcon(
                            FontAwesomeIcons.lock,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: FaIcon(
                              _passwordVisible
                                  ? FontAwesomeIcons.solidEye
                                  : FontAwesomeIcons.solidEyeSlash,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmpasswordController,
                      cursorColor: Colors.black,
                      obscureText: !_ConfirmpasswordVisible,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusColor: Colors.black,
                        floatingLabelStyle: TextStyle(color: Colors.black),
                        labelText: 'Confirm Password',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: FaIcon(
                            FontAwesomeIcons.lock,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _ConfirmpasswordVisible =
                                    !_ConfirmpasswordVisible;
                              });
                            },
                            icon: FaIcon(
                              _ConfirmpasswordVisible
                                  ? FontAwesomeIcons.solidEye
                                  : FontAwesomeIcons.solidEyeSlash,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 80),
                    if (_errorMessage != null) ...[
                      // SizedBox(height: 20),
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                    MaterialButton(
                      elevation: 10,
                      height: 60,
                      minWidth: double.infinity,
                      color: Colors.blue,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true; // Show loading indicator
                          });

                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          String username = _usernameController.text.trim();

                          try {
                            /*bool isValidEmail = await isEmailValid(email);
                            if (!isValidEmail) {
                              // Step 2: If email is invalid, show an error and return
                              setState(() {
                                _errorMessage = 'This email does not exist. Please enter a valid email.';
                              });
                              setState(() {
                                _isLoading = false; // Hide loading indicator
                              });
                              return;
                            }*/
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            User? user = userCredential.user;
                            if (user != null) {
                              if(!email.endsWith('@gmail.com')){
                                await user.delete();
                                setState(() {
                                  _errorMessage='Please use a Gmail address.';
                                });
                                return;
                              }
                              await user.sendEmailVerification();
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .set({
                                'uid': user.uid,
                                'email': email,
                                'username': username,
                                'created_at': FieldValue.serverTimestamp(),
                              });
                              _showSnackBar('Account created successfully!',
                                  Colors.amber.shade300);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EmailVerificationPage()), // Navigate to Login page
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              setState(() {
                                _errorMessage =
                                    'The password provided is too weak.';
                              });
                            } else if (e.code == 'email-already-in-use') {
                              setState(() {
                                _errorMessage =
                                    'The account already exists for that email.';
                              });
                            }
                          } catch (e) {
                            setState(() {
                              _errorMessage =
                                  'An error occurred. Please try again.';
                            });
                          } finally {
                            setState(() {
                              _isLoading = false; // Hide loading indicator
                            });
                          }
                        }
                      },
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
                              'Sign up',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    SizedBox(height: 70),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
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
}