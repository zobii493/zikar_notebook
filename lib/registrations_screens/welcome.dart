import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/auth_gradient_button.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/auth_outlined_button.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/gradient_crosshatch_background.dart';
import 'package:naqashbandi_shazli/registrations_screens/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../core/app_colors.dart';
import '../utils/responsive.dart';
import '../viewmodel/auth_viewmodels/welcome_viewmodel.dart';
import 'signup.dart';
import 'login.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WelcomeViewModel(),
      child: const _WelcomeView(),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  Future<void> _navigateTo(BuildContext context, Widget page) async {
    final viewModel = context.read<WelcomeViewModel>();
    await viewModel.beginNavigation();

    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );

    if (!context.mounted) return;
    await viewModel.onReturnFromNavigation();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<WelcomeViewModel>().isLoading;
    final headerHeight = context.responsiveHeight(0.16).clamp(90.0, 160.0);
    final sidePadding = context.horizontalPadding.horizontal / 2;

    return Scaffold(
      backgroundColor: AppColors.ivoryColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // ===== Header =====
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerHeight,
            child: const GradientCrosshatchBackground(darkenBottom: true),
          ),

          // ===== Signature badge (half in / half out of header) =====
          Positioned(
            top: headerHeight - 34,
            left: 0,
            right: 0,
            child: const Center(child: _SignatureBadge()),
          ),

          SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: context.maxContentWidth),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: headerHeight + 46,
                    left: sidePadding,
                    right: sidePadding,
                    bottom: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: context.responsiveFont(40),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'AutourOne',
                          color: AppColors.emeraldDeepColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 3,
                        width: 56,
                        decoration: BoxDecoration(
                          color: AppColors.antiqueGoldColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your companion for daily Zikr',
                        style: TextStyle(
                          fontSize: context.responsiveFont(15),
                          fontFamily: 'PlusJakartaSans',
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: context.responsiveHeight(0.03)),

                      const _HadithCard(),

                      SizedBox(height: context.responsiveHeight(0.04)),

                      AuthOutlinedButton(
                        label: 'Login',
                        onTap: () => _navigateTo(context, const Login()),
                      ),
                      const SizedBox(height: 16),

                      AuthGradientButton(
                        label: 'Sign up',
                        borderRadius: 30,
                        onTap: () => _navigateTo(context, const Signup()),
                      ),
                      const SizedBox(height: 22),

                      Text(
                        'By continuing, you agree to our Terms & Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: context.responsiveFont(12),
                          fontFamily: 'PlusJakartaSans',
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (isLoading) const LoadingOverlay(),
        ],
      ),
    );
  }
}

class _SignatureBadge extends StatelessWidget {
  const _SignatureBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.ivoryColor,
        border: Border.all(color: AppColors.antiqueGoldColor, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: const Center(
        child: FaIcon(
          FontAwesomeIcons.solidMoon,
          color: AppColors.emeraldDeepColor,
          size: 28,
        ),
      ),
    );
  }
}

/// ==========================================================
/// Elegant Hadith card about the virtue of Dhikr.
/// Source verified: Sahih al-Bukhari 6407 (also Sahih Muslim 779),
/// narrated by Abu Musa (may Allah be pleased with him).
/// ==========================================================
class _HadithCard extends StatelessWidget {
  const _HadithCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.emeraldDeepColor.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.emeraldDeepColor.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          FaIcon(
            FontAwesomeIcons.quoteRight,
            color: AppColors.antiqueGoldColor.withOpacity(0.5),
            size: 22,
          ),
          const SizedBox(height: 14),
          Text(
            'مَثَلُ الَّذِي يَذْكُرُ رَبَّهُ وَالَّذِي لَا يَذْكُرُ رَبَّهُ، مَثَلُ الْحَيِّ وَالْمَيِّتِ',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.responsiveFont(20),
              height: 1.9,
              fontWeight: FontWeight.w600,
              color: AppColors.emeraldDeepColor,
              fontFamily: 'Amiri',
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            width: 50,
            color: AppColors.antiqueGoldColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '"The example of the one who remembers his Lord and the one '
                'who does not remember his Lord is like that of the living '
                'and the dead."',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.responsiveFont(14.5),
              fontStyle: FontStyle.italic,
              fontFamily: 'PlusJakartaSans',
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.antiqueGoldColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Ṣaḥīḥ al-Bukhārī 6407',
              style: TextStyle(
                fontSize: context.responsiveFont(12),
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w600,
                color: AppColors.antiqueGoldColor,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
