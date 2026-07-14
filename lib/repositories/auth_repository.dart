import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Sign In
  Future<User> signIn({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!;
  }

  // Sign Up
  Future<User> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user!;

    if (!email.endsWith('@gmail.com')) {
      await user.delete();
      throw Exception('Please use a Gmail address.');
    }

    await user.sendEmailVerification();
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': email,
      'username': username,
      'created_at': FieldValue.serverTimestamp(),
    });

    return user;
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  // Email Verification
  Future<void> resendVerificationEmail() async {
    await currentUser?.sendEmailVerification();
  }

  Future<bool> reloadAndCheckVerified() async {
    await currentUser?.reload();
    return currentUser?.emailVerified ?? false;
  }

  // Firestore
  Future<String?> fetchUsername(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc['username'] as String?;
    }
    return null;
  }

  // Local Storage
  Future<void> saveRememberedCredentials({
    required bool remember,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (remember) {
      await prefs.setBool('remember_me', true);
      await prefs.setString('email', email);
      await prefs.setString('password', password);
    } else {
      await prefs.setBool('remember_me', false);
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  Future<Map<String, dynamic>> loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'remember_me': prefs.getBool('remember_me') ?? false,
      'email': prefs.getString('email') ?? '',
      'password': prefs.getString('password') ?? '',
    };
  }

  Future<void> saveUsernameLocally(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<String?> loadUsernameLocally() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> setFirstLaunchDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
  }

  String mapAuthError(String code, String? fallbackMessage) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'invalid-credential':
        return 'The supplied credentials are incorrect or expired.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      default:
        return fallbackMessage ?? 'An error occurred. Please try again.';
    }
  }
}
