import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/auth_gradient_button.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/auth_header.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/auth_textfield.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../utils/responsive.dart';
import '../utils/snackbar_utils.dart';
import '../viewmodel/auth_viewmodels/forgot_password_viewmodel.dart';

class Forgotpassword extends StatelessWidget {
  const Forgotpassword({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordViewModel(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView();

  Future<void> _submit(BuildContext context) async {
    final viewModel = context.read<ForgotPasswordViewModel>();
    final result = await viewModel.resetPassword();

    if (!context.mounted) return;

    if (result.success) {
      _showResetPasswordDialog(context);
    } else if (result.message != null) {
      context.showTopSnackBar(result.message!, AppColors.maroonColor);
    }
  }

  void _showResetPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Email Sent',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.bold,
              color: AppColors.emeraldDeepColor,
            ),
          ),
          content: const Text(
            'We have sent a password reset email. Please check your inbox and follow the instructions to reset your password.',
            style: TextStyle(fontFamily: 'PlusJakartaSans'),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(dialogContext).pop(); // back to Login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emeraldDeepColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ForgotPasswordViewModel>();

    return Scaffold(
      backgroundColor: AppColors.ivoryColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const AuthHeader(
            label: 'RESET ACCESS',
            title: 'Forgot Password',
            showBack: false,
          ),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.maxContentWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Form(
                  key: viewModel.formKey,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 35,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emeraldDeepColor.withOpacity(.08),
                          blurRadius: 35,
                          spreadRadius: 3,
                          offset: const Offset(0, 15),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.emeraldDeepColor.withOpacity(.08),
                      ),
                    ),
                    child: Column(
                      children: [
                        /// Icon
                        Container(
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.emeraldDeepColor,
                                AppColors.antiqueGoldColor,
                              ],
                            ),
                          ),
                          child: Center(
                            child: const FaIcon(
                              FontAwesomeIcons.envelopeOpenText,
                              color: Colors.white,
                              size: 34,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          "Reset Your Account Access",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: AppColors.emeraldDeepColor,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          width: 60,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.antiqueGoldColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "Enter the email address associated with your account. "
                          "We'll send you a secure link to reset your password and restore access.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "PlusJakartaSans",
                            fontSize: 15,
                            height: 1.7,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 35),

                        AuthTextField(
                          controller: viewModel.emailController,
                          hint: "Email Address",
                          icon: FontAwesomeIcons.solidEnvelope,
                          iconBg: AppColors.antiqueGoldColor,
                          keyboardType: TextInputType.emailAddress,
                          validator: viewModel.validateEmail,
                        ),

                        const SizedBox(height: 38),

                        AuthGradientButton(
                          label: "Send Reset Link",
                          isLoading: viewModel.isLoading,
                          onTap: () => _submit(context),
                        ),
                      ],
                    ),
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
