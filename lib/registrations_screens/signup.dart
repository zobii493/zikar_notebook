import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/auth_gradient_button.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/auth_header.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/auth_textfield.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/bismillah_banner.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../utils/responsive.dart';
import '../utils/snackbar_utils.dart';
import '../viewmodel/auth_viewmodels/signup_viewmodel.dart';
import 'email_verification.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupViewModel(),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatelessWidget {
  const _SignupView();

  Future<void> _signUp(BuildContext context) async {
    final viewModel = context.read<SignupViewModel>();
    final result = await viewModel.signUp();

    if (!context.mounted) return;

    if (result.success) {
      context.showTopSnackBar(
        result.message ?? 'Account created successfully!',
        AppColors.antiqueGoldColor,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EmailVerificationPage()),
      );
    }
    // Field-level errorMessage is shown inline below the form by the
    // ViewModel's `errorMessage`, matching the original behaviour.
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignupViewModel>();

    return Scaffold(
      backgroundColor: AppColors.ivoryColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const AuthHeader(label: 'JOIN US', title: 'Create Account'),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.maxContentWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 22),
                      const BismillahBanner(),
                      const SizedBox(height: 26),

                      AuthTextField(
                        controller: viewModel.usernameController,
                        hint: 'Username',
                        icon: FontAwesomeIcons.solidUser,
                        iconBg: AppColors.emeraldDeepColor,
                        keyboardType: TextInputType.name,
                        validator: viewModel.validateUsername,
                      ),
                      const SizedBox(height: 16),

                      AuthTextField(
                        controller: viewModel.emailController,
                        hint: 'Email',
                        icon: FontAwesomeIcons.solidEnvelope,
                        iconBg: Colors.blue,
                        keyboardType: TextInputType.emailAddress,
                        validator: viewModel.validateEmail,
                      ),
                      const SizedBox(height: 16),

                      AuthTextField(
                        controller: viewModel.passwordController,
                        hint: 'Password',
                        icon: FontAwesomeIcons.lock,
                        iconBg: AppColors.antiqueGoldColor,
                        obscureText: !viewModel.passwordVisible,
                        suffixIcon: IconButton(
                          onPressed: viewModel.togglePasswordVisibility,
                          icon: FaIcon(
                            viewModel.passwordVisible
                                ? FontAwesomeIcons.solidEye
                                : FontAwesomeIcons.solidEyeSlash,
                            color: Colors.black26,
                            size: 18,
                          ),
                        ),
                        validator: viewModel.validatePassword,
                      ),
                      const SizedBox(height: 16),

                      AuthTextField(
                        controller: viewModel.confirmPasswordController,
                        hint: 'Confirm Password',
                        icon: FontAwesomeIcons.lock,
                        iconBg: AppColors.maroonColor,
                        obscureText: !viewModel.confirmPasswordVisible,
                        suffixIcon: IconButton(
                          onPressed: viewModel.toggleConfirmPasswordVisibility,
                          icon: FaIcon(
                            viewModel.confirmPasswordVisible
                                ? FontAwesomeIcons.solidEye
                                : FontAwesomeIcons.solidEyeSlash,
                            color: Colors.black26,
                            size: 18,
                          ),
                        ),
                        validator: viewModel.validateConfirmPassword,
                      ),

                      if (viewModel.errorMessage != null) ...[
                        const SizedBox(height: 14),
                        Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(
                            color: AppColors.maroonColor,
                            fontFamily: 'PlusJakartaSans',
                          ),
                        ),
                      ],

                      const SizedBox(height: 26),
                      AuthGradientButton(
                        label: 'Sign up',
                        isLoading: viewModel.isLoading,
                        onTap: () => _signUp(context),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: Colors.black54,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.bold,
                                color: AppColors.emeraldDeepColor,
                              ),
                            ),
                          ),
                        ],
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
