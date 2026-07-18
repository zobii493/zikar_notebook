import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/auth_gradient_button.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/auth_header.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/auth_textfield.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/bismillah_banner.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../core/app_theme_colors.dart';
import '../GNav.dart';
import '../utils/responsive.dart';
import '../utils/snackbar_utils.dart';
import '../viewmodel/auth_viewmodels/login_viewmodel.dart';
import '../viewmodel/bottom_nav_provider.dart';
import 'forget_password.dart';
import 'signup.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel()..init(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  Future<void> _signIn(BuildContext context) async {
    final colors = context.appColors;
    final viewModel = context.read<LoginViewModel>();
    final result = await viewModel.signIn();

    if (!context.mounted) return;

    if (result.success) {
      context.read<BottomNavProvider>().changeIndex(0);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
      context.showTopSnackBar('Successfully signed in!', colors.gold);
    } else if (result.message != null) {
      context.showTopSnackBar(result.message!, AppColors.maroonColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: RefreshIndicator(
        onRefresh: viewModel.refreshProfileData,
        color: colors.emeraldDeep,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const AuthHeader(label: 'WELCOME BACK', title: 'Login'),
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
                          controller: viewModel.emailController,
                          hint: 'Email',
                          icon: FontAwesomeIcons.solidEnvelope,
                          iconBg: Colors.blue,
                          keyboardType: TextInputType.emailAddress,
                          errorText: viewModel.emailError,
                          validator: viewModel.validateEmail,
                        ),
                        const SizedBox(height: 16),

                        AuthTextField(
                          controller: viewModel.passwordController,
                          hint: 'Password',
                          icon: FontAwesomeIcons.lock,
                          iconBg: colors.gold,
                          obscureText: !viewModel.passwordVisible,
                          errorText: viewModel.passwordError,
                          suffixIcon: IconButton(
                            onPressed: viewModel.togglePasswordVisibility,
                            icon: FaIcon(
                              viewModel.passwordVisible
                                  ? FontAwesomeIcons.solidEye
                                  : FontAwesomeIcons.solidEyeSlash,
                              color: colors.textSecondary,
                              size: 18,
                            ),
                          ),
                          validator: viewModel.validatePassword,
                        ),

                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.9,
                              child: Checkbox(
                                value: viewModel.rememberMe,
                                activeColor: colors.emeraldDeep,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (newValue) =>
                                    viewModel.toggleRememberMe(newValue!),
                              ),
                            ),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 13,
                                color: colors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Forgotpassword(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colors.emeraldDeep,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        AuthGradientButton(
                          label: 'Login',
                          isLoading: viewModel.isLoading,
                          onTap: () => _signIn(context),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                color: colors.textSecondary,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Signup(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontWeight: FontWeight.bold,
                                  color: colors.emeraldDeep,
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
      ),
    );
  }
}
