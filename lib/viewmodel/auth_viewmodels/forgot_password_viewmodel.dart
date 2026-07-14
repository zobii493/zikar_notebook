import 'package:flutter/material.dart';
import '../../repositories/auth_repository.dart';
import 'auth_action_result.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  ForgotPasswordViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<AuthActionResult> resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return const AuthActionResult(success: false);
    }

    isLoading = true;
    notifyListeners();

    try {
      await _repository.sendPasswordResetEmail(emailController.text.trim());
      return const AuthActionResult(success: true);
    } catch (e) {
      return AuthActionResult(
        success: false,
        message: 'Error: ${e.toString()}',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
