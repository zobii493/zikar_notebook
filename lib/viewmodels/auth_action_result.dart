/// Generic result returned by every ViewModel action (sign in, sign up,
/// reset password...). Views use this to decide what to show (snackbar
/// text/color, navigation) without the ViewModel ever touching a
/// BuildContext or Navigator — keeps ViewModels UI-framework free,
/// which is the whole point of MVVM.
class AuthActionResult {
  final bool success;
  final String? message;
  final String? emailError;
  final String? passwordError;

  const AuthActionResult({
    required this.success,
    this.message,
    this.emailError,
    this.passwordError,
  });
}
