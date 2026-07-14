import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import 'auth_action_result.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool passwordVisible = false;
  bool rememberMe = false;
  bool isLoading = false;
  String? emailError;
  String? passwordError;
  String? userName;

  Future<void> init() async {
    final creds = await _repository.loadRememberedCredentials();
    rememberMe = creds['remember_me'] as bool;
    if (rememberMe) {
      emailController.text = creds['email'] as String;
      passwordController.text = creds['password'] as String;
    }
    userName = await _repository.loadUsernameLocally();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    return null;
  }

  Future<AuthActionResult> signIn() async {
    emailError = null;
    passwordError = null;

    if (!formKey.currentState!.validate()) {
      return const AuthActionResult(success: false);
    }

    isLoading = true;
    notifyListeners();

    try {
      final user = await _repository.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      userName = await _repository.fetchUsername(user.uid);
      if (userName != null) {
        await _repository.saveUsernameLocally(userName!);
      }

      await _repository.saveRememberedCredentials(
        remember: rememberMe,
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      return const AuthActionResult(
        success: true,
        message: 'Successfully signed in!',
      );
    } on FirebaseAuthException catch (e) {
      final message = _repository.mapAuthError(e.code, e.message);
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        emailError = message;
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        passwordError = message;
      }
      return AuthActionResult(
        success: false,
        message: 'Error: ${e.message}',
        emailError: emailError,
        passwordError: passwordError,
      );
    } catch (e) {
      return AuthActionResult(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshProfileData() async {
    final user = _repository.currentUser;
    if (user != null) {
      userName = await _repository.fetchUsername(user.uid);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
