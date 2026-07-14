import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../repositories/auth_repository.dart';
import 'auth_action_result.dart';

class SignupViewModel extends ChangeNotifier {
  SignupViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool isLoading = false;
  String? errorMessage;

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your username';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    if (!value.endsWith('@gmail.com')) return 'Please use a Gmail address';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<AuthActionResult> signUp() async {
    errorMessage = null;
    if (!formKey.currentState!.validate()) {
      return const AuthActionResult(success: false);
    }

    isLoading = true;
    notifyListeners();

    try {
      await _repository.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        username: usernameController.text.trim(),
      );
      return const AuthActionResult(
        success: true,
        message: 'Account created successfully!',
      );
    } on FirebaseAuthException catch (e) {
      errorMessage = _repository.mapAuthError(e.code, e.message);
      return AuthActionResult(success: false, message: errorMessage);
    } catch (e) {
      errorMessage = e.toString().contains('Gmail')
          ? 'Please use a Gmail address.'
          : 'An error occurred. Please try again.';
      return AuthActionResult(success: false, message: errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
