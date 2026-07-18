import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_colors.dart';
import '../core/app_theme_colors.dart';

class ChecklistProvider with ChangeNotifier {
  ChecklistProvider({
    required this.collectionName,
    required this.labels,
    this.completionMessage = 'You have completed everything!',
  }) {
    isCheckedList = List.generate(labels.length, (_) => false);
    loadProgress();
  }

  final String collectionName;
  final List<String> labels;
  final String completionMessage;

  late List<bool> isCheckedList;
  int? lastCompletedTaskIndex;

  bool areAllTasksCompleted() => isCheckedList.every((isChecked) => isChecked);

  Future<void> loadProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection(collectionName)
        .doc('progress')
        .get();

    if (doc.exists) {
      isCheckedList = List.generate(
        labels.length,
        (index) => doc.data()!['checkbox_$index'] ?? false,
      );
    } else {
      isCheckedList = List.generate(labels.length, (_) => false);
    }
    notifyListeners();
  }

  Future<void> saveProgress(int index) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final date = "${now.day}-${now.month}-${now.year}";
    final time = "${now.hour}:${now.minute}";
    final day = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ][now.weekday - 1];

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection(collectionName)
        .doc('progress')
        .set({
          'checkbox_$index': isCheckedList[index],
          'checkbox_${index}_date': date,
          'checkbox_${index}_time': time,
          'checkbox_${index}_day': day,
        }, SetOptions(merge: true));
  }

  Future<void> undoLastTask() async {
    if (lastCompletedTaskIndex != null) {
      isCheckedList[lastCompletedTaskIndex!] = false;
      await saveProgress(lastCompletedTaskIndex!);
      lastCompletedTaskIndex = null;
      notifyListeners();
    }
  }

  Future<void> removeAllCompleted() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection(collectionName)
        .doc('progress')
        .update({
          for (int i = 0; i < isCheckedList.length; i++)
            if (isCheckedList[i]) 'checkbox_$i': false,
        });

    isCheckedList = List.generate(labels.length, (_) => false);
    lastCompletedTaskIndex = null;
    notifyListeners();
  }

  double calculateProgress() {
    final completedCount = isCheckedList.where((c) => c).length;
    return (completedCount / labels.length) * 100;
  }

  Future<void> saveProgressBar(double progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('progress_$collectionName', progress);
  }

  Future<void> completeTaskWithDialog(BuildContext context, int index) async {
    final initialState = isCheckedList[index];
    final colors = context.appColors;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: colors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Confirmation',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          content: Text(
            'Have you completed this task?',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: colors.textPrimary,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            OutlinedButton(
              onPressed: () {
                isCheckedList[index] = initialState;
                Navigator.of(ctx).pop();
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                side: BorderSide(color: colors.emeraldDeep),
                foregroundColor: colors.emeraldDeep,
              ),
              child: const Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emeraldDeepColor,
                // emeraldDeepColor
                foregroundColor: AppColors.whiteColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                isCheckedList[index] = true;
                lastCompletedTaskIndex = index;

                notifyListeners();

                Navigator.of(ctx).pop();

                saveProgress(index);

                if (areAllTasksCompleted()) {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text("🎉 Congratulations"),
                          content: Text(completionMessage),
                        ),
                      );
                    }
                  });
                }
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> getCompletionHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection(collectionName)
        .doc('progress')
        .get();

    if (!doc.exists) return [];

    final history = <Map<String, dynamic>>[];
    for (int i = 0; i < labels.length; i++) {
      if (doc.data()!['checkbox_$i'] == true) {
        history.add({
          "label": "🎉 ${labels[i]}",
          "day": doc.data()!['checkbox_${i}_day'] ?? "N/A",
          "date": doc.data()!['checkbox_${i}_date'] ?? "N/A",
          "time": doc.data()!['checkbox_${i}_time'] ?? "N/A",
        });
      }
    }
    return history;
  }
}
