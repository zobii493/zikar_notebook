import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  String? username;
  String? email;
  String selectedAvatarId = kAvatarOptions.first.asset;
  ThemeMode themeMode = ThemeMode.system;
  bool isLoading = true;

  static const _kAvatarKey = 'profile_avatar_id';
  static const _kThemeKey = 'app_theme_mode';
  static const _kUsernameKey = 'username';

  AvatarOption get selectedAvatar => kAvatarOptions.firstWhere(
        (a) => a.asset == selectedAvatarId,
    orElse: () => kAvatarOptions.first,
  );

  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    await _loadLocalPrefs();
    await _fetchFirebaseUser();

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadLocalPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    selectedAvatarId = prefs.getString(_kAvatarKey) ?? kAvatarOptions.first.asset;
    username = prefs.getString(_kUsernameKey);
    final themeStr = prefs.getString(_kThemeKey) ?? 'system';
    themeMode = _themeModeFromString(themeStr);
  }

  Future<void> _fetchFirebaseUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    email = user.email;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data?['username'] != null) username = data!['username'];
        if (data?['avatarId'] != null) selectedAvatarId = data!['avatarId'];

        final prefs = await SharedPreferences.getInstance();
        if (username != null) {
          await prefs.setString(_kUsernameKey, username!);
        }
        await prefs.setString(_kAvatarKey, selectedAvatarId);
      }
    } catch (e) {
      debugPrint('ProfileViewModel: failed to fetch user doc -> $e');
    }
  }


  Future<void> selectAvatar(String avatarId) async {
    selectedAvatarId = avatarId;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAvatarKey, avatarId);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'avatarId': avatarId}, SetOptions(merge: true));
      } catch (e) {
        debugPrint('ProfileViewModel: failed to sync avatar -> $e');
      }
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, _themeModeToString(mode));
  }

  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}