import 'package:flutter/material.dart';
import '../../repositories/auth_repository.dart';

class WelcomeViewModel extends ChangeNotifier {
  WelcomeViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  bool isLoading = false;

  Future<void> beginNavigation() async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 900));
  }

  Future<void> onReturnFromNavigation() async {
    isLoading = false;
    notifyListeners();
    await _repository.setFirstLaunchDone();
  }
}
