import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'asma_ul_husna_provider.dart';
import 'fezunoor_provider.dart';

class ProgressProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double fezuNoorProgress = 0;
  double asmaUlHusnaProgress = 0;
  double ismeZatProgress = 0;
  double kalmaSharifProgress = 0;

  ProgressProvider() {
    _listenFezuNoor();
    _listenAsmaUlHusna();
    _listenIsmeZat();
    _listenKalmaSharif();
  }

  void _listenFezuNoor() {
    final user = _auth.currentUser;
    if (user == null) return;

    _firestore
        .collection("users")
        .doc(user.uid)
        .collection("fezu_noor")
        .doc("progress")
        .snapshots()
        .listen((doc) {

      final total = FezuNoorProvider.kLabels.length;
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        int completed = 0;
        for (int i = 0; i < total; i++) {
          if (data["checkbox_$i"] == true) completed++;
        }
        fezuNoorProgress = completed / total;
      } else {
        fezuNoorProgress = 0;
      }
      notifyListeners();
    });
  }

  void _listenAsmaUlHusna() {
    final user = _auth.currentUser;
    if (user == null) return;

    _firestore
        .collection("users")
        .doc(user.uid)
        .collection("asma_ul_husna")
        .doc("progress")
        .snapshots()
        .listen((doc) {
      final total = AsmaUlHusnaProvider.kLabels.length;
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        int completed = 0;
        for (int i = 0; i < total; i++) {
          if (data["checkbox_$i"] == true) completed++;
        }
        asmaUlHusnaProgress = completed / total;
      } else {
        asmaUlHusnaProgress = 0;
      }
      notifyListeners();
    });
  }

  void _listenIsmeZat() {
    final user = _auth.currentUser;
    if (user == null) return;
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

  void _listenKalmaSharif() {
    final user = _auth.currentUser;
    if (user == null) return;
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