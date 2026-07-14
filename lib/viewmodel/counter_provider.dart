import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CounterProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _counter = 0;
  int _maxValue = 10000;
  User? _user;

  int get counter => _counter;
  int get maxValue => _maxValue;

  CounterProvider() {
    _init();
  }

  Future<void> _init() async {
    _user = _auth.currentUser;
    if (_user != null) {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection('CounterData')
          .doc('DailyZikar')
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
        _maxValue = data?['maxValue'] ?? 10000;
        _counter = data?['counter'] ?? 0;
        notifyListeners();
      }
    }
  }

  Future<bool> _saveUserData() async {
    if (_user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(_user!.uid)
            .collection('CounterData')
            .doc('DailyZikar')
            .set({
          'maxValue': _maxValue,
          'counter': _counter,
        }, SetOptions(merge: true));
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  void incrementCounter() {
    if (_counter < _maxValue) {
      _counter++;
      _saveUserData();
      notifyListeners();
    }
  }

  void resetCounter() {
    _counter = 0;
    _maxValue = 10000;
    _saveUserData();
    notifyListeners();
  }

  void updateMaxValue(int newMaxValue) {
    if (newMaxValue > 0) {
      _maxValue = newMaxValue;
      if (_counter > _maxValue) {
        _counter = _maxValue;
      }
      _saveUserData();
      notifyListeners();
    }
  }

  Future<bool> saveData() async {
    return await _saveUserData();
  }
}
