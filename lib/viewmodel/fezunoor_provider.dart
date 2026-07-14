import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FezuNoorProvider with ChangeNotifier {
  List<bool> isCheckedList = [];
  int? lastCompletedTaskIndex;

  final List<String> checkboxLabels = [
    'آيَة ٱلْكُرْسِيّ',
    'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
    'سورة الملك',
    'سورة يس',
    'سورة الرحمن',
    'سورة الکھف',
    'حسبنا الله ونعم الوكيل',
    'وَجَعَلْنَا مِن بَيْنِ أَيْدِيهِمْ سَدًّا وَمِنْ خَلْفِهِمْ سَدًّا فَأَغْشَيْنَـهُمْ فَهُمْ لَا يُبْصِرُونَ',
    'سَلَامٌ قَوْلًا مِّن رَّبٍّ رَّحِيمٍ',
    'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم',
    'أسماء الحسنى يا رحمن تا آخر',
    'منزل',
    'حزب البحر',
    'صلى الله على البي الأمي',
    'يا الله',
    '- يَا لطيفاً بِخَلْقِهِ يَا عَلِيماً بِخَلْقِهِ يَا خَبِيراً بِخَلْقِهِ الْطف بِنَا يَا لَطِيفُ يَا عَلِيمُ يَا خَبِيرُ ',
    'سورة الفاتحه',
    ' سورۃ فلق اور سورۃ الناس',
    'سورة اخلاص',
    'سورة الكوثر',
    'سورة قریش',
    'إِنَّا لِلّهِ وَإِنَّـا إِلَيْهِ رَاجِعونَ',
    'صُمٌّ بُكْمٌ عُمْيٌ فَهُمْ لَا يَرْجِعُونَ',
    'لا إلهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِن الظَّالِمِينَ',
    'پورا قرآن مجید',
    'لاحَوْلَ وَ لا قُوَّةَ إِلَّا بِاللهِ الْعَلِي الْعَظِيمُ',
    'لاحَولَ وَلَا قُوَّةَ إِلَّا بِاللهِ لَا مَلْجَأَ وَ لَا مَنْجَأَ مِنَ اللهِ إِلَّا إِلَيْكَ',
    'اسْتَغْفِرُ الله رَبِّي مِنْ كُلِّ ذَنْبٍ وَاتُوْبُ إِلَيْهِ',
    'مُحمَّد حَامِدٌ مَحْمُودَ دَاع',
    'أَحْمَدُ حَامِد مَحْمُود داع',
    'اللهم صلي على سَيِّدِنا محمد و على آلِ مُحَمَّد صَلوةٌ دَائِمَةً مَقْبُولَةٌ تُوَدِى بِهَا عَنَّا حَقَّهُ الْعَظِيمَ',
    'اَلّلهُمَّ صَلِّ عَلَى مُحَمَّد النَّبي الأمّي وَعَلَى الِهِ وَسَلَّمْ تَسْلِيمًا',
    'اللهم صلِي عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آله وسلّم',
    'اللهم صلي عَلَى سَيِّدِنَا مُحَمَّدٍ بِعَدَدِ حُسنِهِ وَجَمَالِه',
    'اللَّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ بِعَدَدِ كُلِّ دَاءٍ وَدَوَاءٍِ وَبَارِكَ وَسَلَّمْ',
    'صَلَّى اللهُ عَلَيْهِ وَسَلَّمْ',
    'درودِ ابراہیمی',
    'کلمہ شریف',
    'اسم ذات الله',
    'فَلَمَّا الْقَوْا قَالَ مُوسى .. الْمُجْرِمُونَ',
    'سورۃ الفاتحہ کے بعد الم ذلِكَ الْكِتَابُ لأَرَيْبَ فِيهِ هُدًى لِلْمُتَّقِينَ',
    'تیسرا کلمہ',
    // Add more labels here
  ];

  FezuNoorProvider() {
    isCheckedList = List.generate(checkboxLabels.length, (_) => false);
    loadProgress();
  }

  bool areAllTasksCompleted() => isCheckedList.every((isChecked) => isChecked);

  Future<void> loadProgress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .collection('fezu_noor')
          .doc('progress')
          .get();

      if (doc.exists) {
        isCheckedList = List.generate(
          checkboxLabels.length,
          (index) => doc.data()!['checkbox_$index'] ?? false,
        );
      } else {
        isCheckedList = List.generate(checkboxLabels.length, (_) => false);
      }
      notifyListeners();
    }
  }

  Future<void> saveProgress(int index) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var now = DateTime.now();
      String date = "${now.day}-${now.month}-${now.year}";
      String time = "${now.hour}:${now.minute}";
      String day =
          ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][now.weekday - 1];

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('fezu_noor')
          .doc('progress')
          .set({
        'checkbox_$index': isCheckedList[index],
        'checkbox_${index}_date': date,
        'checkbox_${index}_time': time,
        'checkbox_${index}_day': day,
      }, SetOptions(merge: true));
    }
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('fezu_noor')
          .doc('progress')
          .update({
        for (int i = 0; i < isCheckedList.length; i++)
          if (isCheckedList[i]) 'checkbox_$i': false,
      });

      isCheckedList = List.generate(checkboxLabels.length, (_) => false);
      lastCompletedTaskIndex = null;
      notifyListeners();
    }
  }

  double calculateProgress() {
    int completedCount = isCheckedList.where((isChecked) => isChecked).length;
    return (completedCount / checkboxLabels.length) * 100;
  }

  Future<void> saveProgressBar(double progress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('progress', progress);
  }

  ///  Dialog ke liye helper function
  Future<void> completeTaskWithDialog(BuildContext context, int index) async {
    bool initialState = isCheckedList[index];

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Have you completed this task?'),
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green,
              ),
              child: TextButton(
                onPressed: () {
                  isCheckedList[index] = initialState;
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
              child: TextButton(
                onPressed: () async {
                  isCheckedList[index] = true;
                  lastCompletedTaskIndex = index;
                  await saveProgress(index);
                  Navigator.of(ctx).pop();

                  if (areAllTasksCompleted()) {
                    showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                        title: Text("🎉 Congratulations"),
                        content: Text("You have completed all Wazaif!"),
                      ),
                    );
                  }
                  notifyListeners();
                },
                child: const Text('Yes',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Completion history fetch
  Future<List<Map<String, dynamic>>> getCompletionHistory() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user.uid)
        .collection('fezu_noor')
        .doc('progress')
        .get();

    if (!doc.exists) return [];

    List<Map<String, dynamic>> history = [];
    for (int i = 0; i < checkboxLabels.length; i++) {
      if (doc.data()!['checkbox_$i'] == true) {
        history.add({
          "label": "🎉 " + checkboxLabels[i],
          "day": doc.data()!['checkbox_${i}_day'] ?? "N/A",
          "date": doc.data()!['checkbox_${i}_date'] ?? "N/A",
          "time": doc.data()!['checkbox_${i}_time'] ?? "N/A",
        });
      }
    }
    return history;
  }
}
