import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:naqashbandi_shazli/widgets/top_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/home_screen/homepage.dart';
import '../widgets/top_curve_shade.dart';
import 'forget_password.dart';
import 'signup.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _rememberMe = false; // Add this line
  String? _emailError;
  String? _passwordError;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials(); // Load saved credentials on start
    _loadStoredUsername();
  }

  Future<void> _loadRememberedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _fetchUserName(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        print('User document data: ${userDoc.data()}');
        final username = userDoc['username'];

        // Save username in SharedPreferences for later use
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        setState(() {
          _userName = username;
        });
      } else {
        print('No user document found for this userId.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _loadStoredUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('username'); // Load username if available
    });
  }

  Future<void> _refreshProfileData() async {
    try {
      // Fetch the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Pass the user ID to _fetchUserName
        await _fetchUserName(user.uid);

        setState(() {
          // Update the UI with the new data
        });
      } else {
        print('No user is currently signed in.');
      }
    } catch (e) {
      print('Error refreshing profile data: $e');
    }
  }



  void _signIn() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              width: 70,
              height: 70,
              child: LoadingIndicator(
                indicatorType: Indicator.ballSpinFadeLoader,
                colors: const [Colors.blue, Colors.purple],
                strokeWidth: 0,
              ),
            ),
          );
        },
      );

      try {
        // Attempt to sign in with email and password
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await _fetchUserName(userCredential.user!.uid);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setBool('remember_me', true);
          await prefs.setString('email', _emailController.text.trim());
          await prefs.setString('password', _passwordController.text.trim());
        } else {
          await prefs.setBool('remember_me', false);
          await prefs.remove('email');
          await prefs.remove('password');
        }

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyFrontPage(),
          ),
        );

        _showSnackBar('Successfully signed in!', Colors.amber.shade300);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        print('Firebase Auth Exception: ${e.code} - ${e.message}');
        // Error handling within signIn
        // Display appropriate error message based on Firebase error code
        if (e.code == 'user-not-found') {
          setState(() {
            _emailError = 'No user found for this email.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _passwordError = 'Incorrect password. Please try again.';
          });
        } else if (e.code == 'invalid-email') {
          setState(() {
            _emailError = 'Invalid email address format.';
          });
        } else if (e.code == 'user-disabled') {
          setState(() {
            _emailError = 'This user account has been disabled.';
          });
        } else if (e.code == 'invalid-credential') {
          setState(() {
            _emailError = 'The supplied credentials are incorrect or expired.';
          });
        } else {
          setState(() {
            _emailError = 'An error occurred: ${e.message}';
          });
        }
        _showSnackBar('Error: ${e.message}', Colors.red);
      } catch (e) {
        Navigator.pop(context);
        print('Unexpected error: $e');
        _showSnackBar('An unexpected error occurred: $e', Colors.red);
      }
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
          RefreshIndicator(
            backgroundColor: Colors.black,
            color: Colors.white,
            onRefresh: _refreshProfileData,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80.0, right: 20, left: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Login',
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
                                WavyAnimatedText(_userName != null
                                    ? 'Welcome, $_userName!'
                                    : 'Login to your account...',),
                              ],
                              isRepeatingAnimation: true,
                            ),),
                        Container(
                          height: 300,
                          width: double.infinity,
                          child: Lottie.asset('assets/signin.json'),
                        ),
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
                                child: FaIcon(
                                  FontAwesomeIcons.solidEnvelope,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              errorText: _emailError),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordController,
                          cursorColor: Colors.black,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
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
                                padding: const EdgeInsets.only(top: 10.0),
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
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                              ),
                              errorText: _passwordError),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: Colors.black,
                              onChanged: (newValue) {
                                setState(() {
                                  _rememberMe = newValue!;
                                });
                              },
                            ),
                            Text(
                              'Remember Me',
                              style: TextStyle(color: Colors.black),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextButton(
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Forgotpassword(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        MaterialButton(
                          elevation: 10,
                          height: 60,
                          minWidth: double.infinity,
                          color: Colors.blue,
                          onPressed: _signIn,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Signup(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}