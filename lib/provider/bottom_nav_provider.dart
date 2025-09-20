import 'package:flutter/foundation.dart';

class BottomNavProvider with ChangeNotifier {
  int _selectedIndex = 0;
  DateTime? _lastPressedTime;

  int get selectedIndex => _selectedIndex;

  void changeIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  /// Handle back button logic
  Future<bool> handleWillPop(Function showSnackBar) async {
    if (_selectedIndex != 0) {
      // agar HomePage par nahi ho to HomePage par le jao
      changeIndex(0);
      return false;
    } else {
      // agar already HomePage par ho
      final now = DateTime.now();
      if (_lastPressedTime == null ||
          now.difference(_lastPressedTime!) > Duration(seconds: 2)) {
        _lastPressedTime = now;
        showSnackBar();
        return false; // abhi exit mat karo
      }
      return true; // 2 second ke andar dobara press → exit app
    }
  }
}
