class AppUser {
  final String uid;
  final String email;
  final String username;

  const AppUser({
    required this.uid,
    required this.email,
    required this.username,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      username: map['username'] as String? ?? '',
    );
  }
}
