import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JourneyProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = true;

  Map<DateTime, int> dailyTotals = {};
  Map<String, int> categoryTotals = {};

  int currentStreak = 0;
  int longestStreak = 0;
  int totalActiveDays = 0;
  int totalZikar = 0;

  static const List<_ZikarSource> _zikarSources = [
    _ZikarSource(
      collection: 'IsmeZatData',
      historyField: 'ismezatzikarHistory',
      label: 'اسم ذات الله',
    ),
    _ZikarSource(
      collection: 'KalmaSharifData',
      historyField: 'kalmasharifHistory',
      label: 'لَا إِلٰهَ إِلَّا اللهُ',
    ),
  ];

  static const List<_ChecklistSource> _checklistSources = [
    _ChecklistSource(collection: 'fezu_noor', label: 'شازلی ازکار'),
    _ChecklistSource(collection: 'asma_ul_husna', label: 'اَسْمَاءُ الْحُسْنٰی'),
  ];

  Future<void> loadJourney() async {
    isLoading = true;
    notifyListeners();

    final user = _auth.currentUser;
    if (user == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    final Map<DateTime, int> totals = {};
    final Map<String, int> categories = {};

    for (final source in _zikarSources) {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection(source.collection)
          .doc('weeklyData')
          .get();

      if (!doc.exists) continue;
      final data = doc.data();
      if (data == null || data[source.historyField] == null) continue;

      final history = List<Map<String, dynamic>>.from(data[source.historyField]);
      int categoryCount = 0;

      for (final entry in history) {
        final rawDate = entry['date'];
        final rawZikar = entry['zikar'];
        if (rawDate == null || rawZikar == null) continue;

        DateTime dateTime;
        try {
          dateTime = rawDate is String ? DateTime.parse(rawDate) : rawDate as DateTime;
        } catch (_) {
          continue;
        }

        final int zikar = rawZikar is String ? int.parse(rawZikar) : rawZikar as int;
        final dayKey = DateTime(dateTime.year, dateTime.month, dateTime.day);

        totals[dayKey] = (totals[dayKey] ?? 0) + zikar;
        categoryCount += zikar;
      }

      if (categoryCount > 0) {
        categories[source.label] = (categories[source.label] ?? 0) + categoryCount;
      }
    }

    final dateKeyPattern = RegExp(r'^checkbox_(\d+)_date$');

    for (final source in _checklistSources) {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection(source.collection)
          .doc('progress')
          .get();

      if (!doc.exists) continue;
      final data = doc.data();
      if (data == null) continue;

      int categoryCount = 0;

      for (final key in data.keys) {
        final match = dateKeyPattern.firstMatch(key);
        if (match == null) continue;

        final index = match.group(1);
        if (data['checkbox_$index'] != true) continue;

        final rawDate = data[key];
        if (rawDate == null || rawDate is! String) continue;

        final parts = rawDate.split('-');
        if (parts.length != 3) continue;

        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day == null || month == null || year == null) continue;

        final dayKey = DateTime(year, month, day);
        totals[dayKey] = (totals[dayKey] ?? 0) + 1;
        categoryCount += 1;
      }

      if (categoryCount > 0) {
        categories[source.label] = (categories[source.label] ?? 0) + categoryCount;
      }
    }

    dailyTotals = totals;
    categoryTotals = categories;
    _computeStats();

    isLoading = false;
    notifyListeners();
  }

  void _computeStats() {
    totalActiveDays = dailyTotals.length;
    totalZikar = dailyTotals.values.fold(0, (sum, v) => sum + v);

    final today = DateTime.now();
    DateTime cursor = DateTime(today.year, today.month, today.day);
    int streak = 0;

    if (!dailyTotals.containsKey(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    while (dailyTotals.containsKey(cursor) && (dailyTotals[cursor] ?? 0) > 0) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    currentStreak = streak;

    if (dailyTotals.isEmpty) {
      longestStreak = 0;
      return;
    }
    final sortedDays = dailyTotals.keys.toList()..sort();
    int best = 1;
    int running = 1;
    for (int i = 1; i < sortedDays.length; i++) {
      final diff = sortedDays[i].difference(sortedDays[i - 1]).inDays;
      if (diff == 1) {
        running++;
      } else {
        running = 1;
      }
      if (running > best) best = running;
    }
    longestStreak = best;
  }
}

class _ZikarSource {
  final String collection;
  final String historyField;
  final String label;
  const _ZikarSource({
    required this.collection,
    required this.historyField,
    required this.label,
  });
}

class _ChecklistSource {
  final String collection;
  final String label;
  const _ChecklistSource({required this.collection, required this.label});
}