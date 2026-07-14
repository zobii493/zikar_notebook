import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/gradient_crosshatch_background.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../utils/responsive.dart';
import '../utils/snackbar_utils.dart';
import '../viewmodels/email_verification_viewmodel.dart';
import 'login.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmailVerificationViewModel()..init(),
      child: const _EmailVerificationView(),
    );
  }
}

class _EmailVerificationView extends StatelessWidget {
  const _EmailVerificationView();

  Future<void> _resendEmail(BuildContext context) async {
    final viewModel = context.read<EmailVerificationViewModel>();
    final success = await viewModel.resendEmail();

    if (!context.mounted) return;

    context.showTopSnackBar(
      success ? 'Verification email sent successfully.' : 'Unable to send email.',
      success ? Colors.green : Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EmailVerificationViewModel>();
    final headerHeight = context.responsiveHeight(0.32).clamp(220.0, 320.0);

    // Session was lost (app reopened after being signed out, token expired,
    // etc.) — nothing to verify, so send the user back to Login instead of
    // showing a stuck/blank screen.
    if (viewModel.user == null && !viewModel.isCheckingInitialStatus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Checking the real (reloaded) verification status on open — avoids
    // flashing "not verified" / the resend button for an instant before
    // we know the true state.
    if (viewModel.isCheckingInitialStatus) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.ivoryColor,
      body: Stack(
        children: [
          SizedBox(
            height: headerHeight,
            width: double.infinity,
            child: const GradientCrosshatchBackground(darkenBottom: true),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.maxContentWidth),
                  child: Column(
                    children: [
                      const SizedBox(height: 70),

                      Container(
                        height: 110,
                        width: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mark_email_read_rounded,
                          size: 55,
                          color: AppColors.emeraldDeepColor,
                        ),
                      ),

                      const SizedBox(height: 40),

                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.15),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Verify Your Email',
                              style: TextStyle(
                                fontSize: context.responsiveFont(28),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PlusJakartaSans',
                                color: AppColors.emeraldDeepColor,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              viewModel.isEmailVerified
                                  ? 'Alhamdulillah! Your email has been verified successfully.'
                                  : "We've sent a verification email to\n\n${viewModel.user?.email ?? ""}\n\nPlease verify your email before continuing.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: context.responsiveFont(16),
                                height: 1.6,
                                color: Colors.black87,
                                fontFamily: 'PlusJakartaSans',
                              ),
                            ),
                            const SizedBox(height: 35),

                            if (viewModel.isEmailVerified)
                              _VerificationButton(
                                title: 'Continue',
                                color: AppColors.emeraldDeepColor,
                                textColor: Colors.white,
                                isLoading: false,
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Login(),
                                    ),
                                  );
                                },
                              )
                            else ...[
                              _VerificationButton(
                                title: 'Resend Verification Email',
                                color: AppColors.antiqueGoldColor,
                                textColor: Colors.white,
                                isLoading: viewModel.isLoading,
                                onPressed: () => _resendEmail(context),
                              ),
                              const SizedBox(height: 14),
                              TextButton(
                                onPressed: () => context
                                    .read<EmailVerificationViewModel>()
                                    .checkNow(),
                                child: const Text(
                                  "I've verified — check again",
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.emeraldDeepColor,
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 25),
                            const Divider(),
                            const SizedBox(height: 15),

                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.security,
                                  color: AppColors.emeraldColor,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Your account is protected',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 35),

                      const Text(
                        "Please check your Spam or Junk folder if you don't receive the email within a few minutes.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kept local to this screen — its ElevatedButton + LoadingIndicator style
/// is distinct from the shared AuthGradientButton used on Login/Signup.
class _VerificationButton extends StatelessWidget {
  const _VerificationButton({
    required this.title,
    required this.onPressed,
    required this.color,
    required this.textColor,
    required this.isLoading,
  });

  final String title;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
          width: 35,
          height: 35,
          child: LoadingIndicator(
            indicatorType: Indicator.ballSpinFadeLoader,
            colors: [AppColors.ivoryColor, AppColors.antiqueGoldColor],
          ),
        )
            : Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
      ),
    );
  }
}