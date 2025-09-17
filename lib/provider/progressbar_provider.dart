import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ProgressProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double fezuNoorProgress = 0;
  double ismeZatProgress = 0;
  double kalmaSharifProgress = 0;

  ProgressProvider() {
    _listenFezuNoor();
    _listenIsmeZat();
    _listenKalmaSharif();
  }

  void _listenFezuNoor() {
    User? user = _auth.currentUser;
    if (user != null) {
      _firestore
          .collection("users")
          .doc(user.uid)
          .collection("fezu_noor")
          .doc("progress")
          .snapshots()
          .listen((doc) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;

          int total = data.keys
              .where((k) =>
          k.startsWith("checkbox_") &&
              !k.contains("_date") &&
              !k.contains("_time") &&
              !k.contains("_day"))
              .length;

          int completed = 0;
          for (int i = 0; i < total; i++) {
            if (data["checkbox_$i"] == true) completed++;
          }

          fezuNoorProgress = total > 0 ? completed / total : 0;
          notifyListeners();
        } else {
          fezuNoorProgress = 0;
          notifyListeners();
        }
      });
    }
  }


  void _listenIsmeZat() {
    User? user = _auth.currentUser;
    if (user != null) {
      _firestore
          .collection('users')
          .doc(user.uid)
          .collection('IsmeZatData')
          .doc('weeklyData')
          .snapshots()
          .listen((doc) {
        if (doc.exists) {
          ismeZatProgress = doc['completedPercentage']?.toDouble() ?? 0;
          notifyListeners();
        }
      });
    }
  }

  void _listenKalmaSharif() {
    User? user = _auth.currentUser;
    if (user != null) {
      _firestore
          .collection('users')
          .doc(user.uid)
          .collection('KalmaSharifData')
          .doc('weeklyData')
          .snapshots()
          .listen((doc) {
        if (doc.exists) {
          kalmaSharifProgress = doc['completedPercentage']?.toDouble() ?? 0;
          notifyListeners();
        }
      });
    }
  }
}
