import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  EmailVerificationViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  User? user;
  bool isEmailVerified = false;
  bool isLoading = false;
  bool isCheckingInitialStatus = true;
  bool _disposed = false;

  /// Was previously synchronous and trusted the *locally cached*
  /// `emailVerified` flag, which stays false until Firebase reloads the
  /// user — so reopening the app after verifying showed "not verified"
  /// for up to 4s (or forever, if this widget got rebuilt before that
  /// timer fired). Now it reloads the user immediately on start.
  Future<void> init() async {
    user = _repository.currentUser;

    if (user == null) {
      // Session lost / signed out while away — nothing to check.
      isCheckingInitialStatus = false;
      notifyListeners();
      return;
    }

    isEmailVerified = user?.emailVerified ?? false;
    notifyListeners();

    // Reload right away instead of trusting the cached flag.
    isEmailVerified = await _repository.reloadAndCheckVerified();
    user = _repository.currentUser;
    isCheckingInitialStatus = false;
    if (_disposed) return;
    notifyListeners();

    if (!isEmailVerified) {
      _scheduleVerificationCheck();
    }
  }

  void _scheduleVerificationCheck() {
    Future.delayed(const Duration(seconds: 4), _checkEmailVerified);
  }

  Future<void> _checkEmailVerified() async {
    if (_disposed) return;
    isEmailVerified = await _repository.reloadAndCheckVerified();
    user = _repository.currentUser;
    if (_disposed) return;
    notifyListeners();
    if (!isEmailVerified) {
      _scheduleVerificationCheck();
    }
  }

  /// Manual fallback for the "I've verified — check again" button, in
  /// case the automatic 4-second polling hasn't caught up yet.
  Future<void> checkNow() => _checkEmailVerified();

  Future<bool> resendEmail() async {
    isLoading = true;
    notifyListeners();
    bool success = true;
    try {
      await _repository.resendVerificationEmail();
    } catch (e) {
      success = false;
    }
    if (!_disposed) {
      isLoading = false;
      notifyListeners();
    }
    return success;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}