import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class IsmezatProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int totalZikarGoal = 12500000;
  int completedZikar = 0;
  int weeklyTotal = 0;
  double completedPercentage = 0;

  int mondayZikar = 0;
  int tuesdayZikar = 0;
  int wednesdayZikar = 0;
  int thursdayZikar = 0;
  int fridayZikar = 0;
  int saturdayZikar = 0;
  int sundayZikar = 0;

  bool isMondayAdded = false;
  bool isTuesdayAdded = false;
  bool isWednesdayAdded = false;
  bool isThursdayAdded = false;
  bool isFridayAdded = false;
  bool isSaturdayAdded = false;
  bool isSundayAdded = false;

  List<Map<String, dynamic>> zikarHistory = [];

  Future<void> loadData(String collectionName, String historyCollection) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    _resetToDefaults(); // ensure no leftover data from another collection

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection(collectionName)
        .doc('weeklyData')
        .get();

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      totalZikarGoal = data['totalZikarGoal'] ?? totalZikarGoal;
      completedZikar = data['completedZikar'] ?? completedZikar;
      weeklyTotal = data['weeklyTotal'] ?? weeklyTotal;
      mondayZikar = data['mondayZikar'] ?? mondayZikar;
      tuesdayZikar = data['tuesdayZikar'] ?? tuesdayZikar;
      wednesdayZikar = data['wednesdayZikar'] ?? wednesdayZikar;
      thursdayZikar = data['thursdayZikar'] ?? thursdayZikar;
      fridayZikar = data['fridayZikar'] ?? fridayZikar;
      saturdayZikar = data['saturdayZikar'] ?? saturdayZikar;
      sundayZikar = data['sundayZikar'] ?? sundayZikar;

      isMondayAdded = data['isMondayAdded'] ?? isMondayAdded;
      isTuesdayAdded = data['isTuesdayAdded'] ?? isTuesdayAdded;
      isWednesdayAdded = data['isWednesdayAdded'] ?? isWednesdayAdded;
      isThursdayAdded = data['isThursdayAdded'] ?? isThursdayAdded;
      isFridayAdded = data['isFridayAdded'] ?? isFridayAdded;
      isSaturdayAdded = data['isSaturdayAdded'] ?? isSaturdayAdded;
      isSundayAdded = data['isSundayAdded'] ?? isSundayAdded;

      if (data[historyCollection] != null) {
        zikarHistory = List<Map<String, dynamic>>.from(data[historyCollection]);
      }
      _calculatePercentage();
    }

    notifyListeners();
  }

  void _resetToDefaults() {
    totalZikarGoal = 12500000;
    completedZikar = 0;
    weeklyTotal = 0;
    completedPercentage = 0;

    mondayZikar = 0;
    tuesdayZikar = 0;
    wednesdayZikar = 0;
    thursdayZikar = 0;
    fridayZikar = 0;
    saturdayZikar = 0;
    sundayZikar = 0;

    isMondayAdded = false;
    isTuesdayAdded = false;
    isWednesdayAdded = false;
    isThursdayAdded = false;
    isFridayAdded = false;
    isSaturdayAdded = false;
    isSundayAdded = false;

    zikarHistory = [];
  }

  void _calculatePercentage() {
    completedPercentage = completedZikar / totalZikarGoal;
  }

  Future<void> saveData(String collectionName, String historyCollection) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection(collectionName)
        .doc('weeklyData')
        .set({
      'totalZikarGoal': totalZikarGoal,
      'completedZikar': completedZikar,
      'weeklyTotal': weeklyTotal,
      'mondayZikar': mondayZikar,
      'tuesdayZikar': tuesdayZikar,
      'wednesdayZikar': wednesdayZikar,
      'thursdayZikar': thursdayZikar,
      'fridayZikar': fridayZikar,
      'saturdayZikar': saturdayZikar,
      'sundayZikar': sundayZikar,
      'isMondayAdded': isMondayAdded,
      'isTuesdayAdded': isTuesdayAdded,
      'isWednesdayAdded': isWednesdayAdded,
      'isThursdayAdded': isThursdayAdded,
      'isFridayAdded': isFridayAdded,
      'isSaturdayAdded': isSaturdayAdded,
      'isSundayAdded': isSundayAdded,
      historyCollection: zikarHistory,
      'completedPercentage': completedPercentage,
    });

    notifyListeners();
  }

  void updateDailyZikar(
      {required int value,
        required String day,
        required String collectionName,
        required String historyCollection}) {
    final now = DateTime.now();
    zikarHistory.add({
      'day': day,
      'zikar': value,
      'date': now.toLocal().toString(),
    });

    weeklyTotal += value;
    completedZikar += value;
    if (completedZikar > totalZikarGoal) {
      completedZikar = totalZikarGoal;
    }
    _calculatePercentage();
    saveData(collectionName, historyCollection);
    notifyListeners();
  }

  void resetWeek(String collectionName, String historyCollection) {
    mondayZikar = 0;
    tuesdayZikar = 0;
    wednesdayZikar = 0;
    thursdayZikar = 0;
    fridayZikar = 0;
    saturdayZikar = 0;
    sundayZikar = 0;

    isMondayAdded = false;
    isTuesdayAdded = false;
    isWednesdayAdded = false;
    isThursdayAdded = false;
    isFridayAdded = false;
    isSaturdayAdded = false;
    isSundayAdded = false;

    weeklyTotal = 0;
    saveData(collectionName, historyCollection);
    notifyListeners();
  }
}
