import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naqashbandi_shazli/core/app_colors.dart';
import '../../core/app_theme_colors.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.emeraldDeepColor,
        title: Text(
          'Help & Support',
          style: TextStyle(
            color: colors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Amiri',
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: FaIcon(FontAwesomeIcons.angleLeft, color: colors.gold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
        children: [
          _buildIntroBanner(colors),
          const SizedBox(height: 24),
          _sectionLabel('TROUBLESHOOTING', Icons.build_rounded, colors),
          const SizedBox(height: 10),
          _buildTroubleshootCard(
            colors: colors,
            icon: Icons.refresh_rounded,
            title: 'App Crashes',
            body:
            'Try restarting the app. If the problem persists, check for updates to make sure you have the latest version installed.',
          ),
          _buildTroubleshootCard(
            colors: colors,
            icon: Icons.touch_app_rounded,
            title: 'Button Not Responding',
            body:
            'Make sure your screen is clean and functioning properly. A screen protector can sometimes interfere with touch sensitivity.',
          ),
          _buildTroubleshootCard(
            colors: colors,
            icon: Icons.app_registration_rounded,
            title: 'Registration Issues',
            body:
            'Check your internet connection and make sure all required fields are filled in correctly, then try again.',
          ),
          _buildTroubleshootCard(
            colors: colors,
            icon: Icons.lock_reset_rounded,
            title: 'Password Reset Issues',
            body:
            'Double-check you\'re using your registered email address and follow the reset instructions carefully. Contact support if it still doesn\'t work.',
          ),
          const SizedBox(height: 24),
          _sectionLabel('STAY UPDATED', Icons.campaign_rounded, colors),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'Stay updated with the latest features and bug fixes by following our social channels or visiting our website. Regular updates ensure you always have the best experience with the Naqashbandi Shazli app.',
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: colors.textPrimary,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionLabel('NEED MORE HELP', Icons.support_agent_rounded, colors),
          const SizedBox(height: 10),
          _buildContactTile(
            colors: colors,
            icon: FontAwesomeIcons.envelope,
            label: 'Email us',
            value: 'support@naqashbandishazli.app',
          ),
          const SizedBox(height: 10),
          _buildContactTile(
            colors: colors,
            icon: FontAwesomeIcons.whatsapp,
            label: 'WhatsApp support',
            value: 'Chat with our team',
          ),
        ],
      ),
    );
  }

  Widget _buildIntroBanner(AppThemeColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.headerGradientEnd,colors.headerGradientEnd],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.headset_mic_rounded, color: colors.gold, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'We\'re here to help',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Find quick fixes below, or reach out to our team directly.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: 12,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, IconData icon, AppThemeColors colors) {
    return Row(
      children: [
        Icon(icon, size: 15, color: colors.emeraldDeep),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: colors.textSecondary,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
      ],
    );
  }

  Widget _buildTroubleshootCard({
    required AppThemeColors colors,
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: colors.gold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: colors.emeraldDeep),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: colors.textPrimary,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: colors.textSecondary,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required AppThemeColors colors,
    required FaIconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.emeraldDeep.withValues(alpha: 0.1),
            ),
            child: Center(child: FaIcon(icon, size: 17, color: colors.emeraldDeep)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                    color: colors.textPrimary,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 20, color: colors.textSecondary),
        ],
      ),
    );
  }
}