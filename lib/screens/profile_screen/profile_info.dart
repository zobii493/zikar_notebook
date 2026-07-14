import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:naqashbandi_shazli/screens/profile_screen/faqs.dart';
import '../../core/app_colors.dart';
import '../../model/profile_model.dart';
import '../../provider/profile_vm.dart';
import '../../registrations_screens/login.dart';
import '../../widgets/custom_paint.dart';
import 'helps_supports.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileViewModel>(
      create: (_) => ProfileViewModel()..init(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  Future<void> _confirmLogout(BuildContext context, ProfileViewModel vm) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            color: AppColors.emeraldDeepColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontFamily: 'PlusJakartaSans'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(foregroundColor: Colors.black54),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.maroonColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await vm.logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
              (route) => false,
        );
      }
    }
  }

  void _openAvatarPicker(BuildContext context, ProfileViewModel vm) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Choose Your Avatar',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.emeraldDeepColor,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: kAvatarOptions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final avatar = kAvatarOptions[index];
                    final bool isSelected = avatar.asset == vm.selectedAvatarId;

                    return GestureDetector(
                      onTap: () {
                        vm.selectAvatar(avatar.asset);
                        Navigator.pop(ctx);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // ============ selected = gold, default = emeraldDeep ============
                          color: isSelected
                              ? AppColors.antiqueGoldColor
                              : AppColors.emeraldColor,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.antiqueGoldColor
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: AppColors.antiqueGoldColor
                                  .withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                              : null,
                        ),
                        child: Image.asset(avatar.asset),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.ivoryColor,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.emeraldDeepColor),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.ivoryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ================= HEADER (matches counter page style) =================
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: double.infinity,
                  height: 190,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.emeraldDeepColor,
                        AppColors.emeraldColor,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(painter: CrosshatchPainter()),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'My Profile',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'PlusJakartaSans',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ================= MAIN SELECTED AVATAR (half in/out of header) =================
                Positioned(
                  top: 130,
                  child: GestureDetector(
                    onTap: () => _openAvatarPicker(context, vm),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // Selected avatar's circle = gold background
                            color: AppColors.ivoryColor,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Image.asset(vm.selectedAvatar.asset,),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.emeraldDeepColor,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 70), // room for the overlapping avatar

            Center(
              child: Text(
                vm.username ?? 'Username',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlusJakartaSans',
                  color: AppColors.emeraldDeepColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                vm.email ?? 'example@email.com',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'PlusJakartaSans',
                  color: Colors.black54,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ================= APPEARANCE SECTION =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appearance',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.emeraldDeepColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _ThemeOption(
                          label: 'Light',
                          icon: Icons.wb_sunny_rounded,
                          isSelected: vm.themeMode == ThemeMode.light,
                          onTap: () => vm.setThemeMode(ThemeMode.light),
                        ),
                        const SizedBox(width: 10),
                        _ThemeOption(
                          label: 'Dark',
                          icon: Icons.nightlight_round,
                          isSelected: vm.themeMode == ThemeMode.dark,
                          onTap: () => vm.setThemeMode(ThemeMode.dark),
                        ),
                        const SizedBox(width: 10),
                        _ThemeOption(
                          label: 'System',
                          icon: Icons.settings_suggest_rounded,
                          isSelected: vm.themeMode == ThemeMode.system,
                          onTap: () => vm.setThemeMode(ThemeMode.system),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= OPTIONS LIST =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ProfileOption(
                    icon: FontAwesomeIcons.circleQuestion,
                    text: 'FAQs',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FAQsPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  ProfileOption(
                    icon: FontAwesomeIcons.circleInfo,
                    text: 'Help & Support',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelpSupportPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  ProfileOption(
                    icon: FontAwesomeIcons.arrowRightFromBracket,
                    text: 'Logout',
                    iconColor: AppColors.maroonColor,
                    onPressed: () => _confirmLogout(context, vm),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/// Small selectable chip used in the Appearance section.
class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.emeraldDeepColor
                : AppColors.ivoryColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.emeraldDeepColor : Colors.black12,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.emeraldDeepColor,
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                  isSelected ? Colors.white : AppColors.emeraldDeepColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Modern list item card used for FAQs / Help & Support / Logout etc.
class ProfileOption extends StatelessWidget {
  final FaIconData icon;
  final String text;
  final Color? iconColor;
  final VoidCallback? onPressed;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
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
                color: (iconColor ?? AppColors.emeraldDeepColor)
                    .withOpacity(0.1),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  size: 18,
                  color: iconColor ?? AppColors.emeraldDeepColor,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}