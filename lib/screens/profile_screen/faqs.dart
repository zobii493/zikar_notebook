import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app_theme_colors.dart';

class FAQsPage extends StatefulWidget {
  const FAQsPage({super.key});

  @override
  State<FAQsPage> createState() => _FAQsPageState();
}

class _FAQItem {
  final String question;
  final String answer;
  const _FAQItem(this.question, this.answer);
}

class _FAQSection {
  final String title;
  final FaIconData icon;
  final List<_FAQItem> items;
  const _FAQSection(this.title, this.icon, this.items);
}

class _FAQsPageState extends State<FAQsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<_FAQSection> _sections = const [
    _FAQSection('Account', FontAwesomeIcons.person, [
      _FAQItem(
        'How do I register for an account?',
        'To register for an account, open the app and navigate to the registration page. Enter your details including name, email, and password, then submit the form to create your account.',
      ),
      _FAQItem(
        'I forgot my password. How can I reset it?',
        'If you forget your password, go to the login page and tap "Forgot Password". Follow the instructions to reset your password using your registered email address.',
      ),
      _FAQItem(
        'Can I update my registration details?',
        'Yes, you can update your registration details by accessing the profile settings in the app. Here, you can modify your personal information and email address.',
      ),
    ]),
    _FAQSection('Zikar Counter', FontAwesomeIcons.handPointUp, [
      _FAQItem(
        'What is the CounterApp?',
        'The CounterApp is a simple and easy-to-use tool that allows you to count daily zikar. It features a counter that can be incremented, reset, and saved for future reference.',
      ),
      _FAQItem(
        'How do I increment the counter?',
        'Simply tap the large counter button in the center of the screen. Each tap increases the count by one.',
      ),
      _FAQItem(
        'Can I reset the counter to zero?',
        'Yes, press the "Reset" button below the counter display. A confirmation dialog will appear before it resets.',
      ),
      _FAQItem(
        'How do I set a target value?',
        'Tap "Edit" in the Goal Progress section to enter a new target value.',
      ),
      _FAQItem(
        'What happens if I exceed the target value?',
        'The counter stops incrementing once it reaches the target value you\'ve set.',
      ),
      _FAQItem(
        'How is my daily Zikar stored?',
        'Your daily Zikar entries are stored securely in Firebase, so you can keep a record of your activity and track your spiritual progress.',
      ),
      _FAQItem(
        'Can I view my past Zikar entries?',
        'Yes — open the history icon on the Ism-e-Zaat or Kalma Sharif page to review your past entries and track your progress over time.',
      ),
    ]),
    _FAQSection('Home & Reading', FontAwesomeIcons.bookOpen, [
      _FAQItem(
        'What can I do on the Home Page?',
        'The Home Page lets you read featured books directly within the app, and shows practice cards like Fayzunoor with checkboxes and wazaif.',
      ),
      _FAQItem(
        'How do I read the PDF book on the Home Page?',
        'Navigate to the Home Page and tap on any featured book card — it opens directly inside the app so you can scroll through the pages.',
      ),
      _FAQItem(
        'How do I navigate to different pages like Home or Profile?',
        'Use the bottom navigation bar to switch between Home, Counter, and Profile.',
      ),
    ]),
    _FAQSection('Profile & Notifications', FontAwesomeIcons.gear, [
      _FAQItem(
        'What features are available on the Profile Page?',
        'You can view and update your profile information, change your avatar, switch appearance themes, and access help & support.',
      ),
      _FAQItem(
        'How do I update my profile picture?',
        'Tap on your avatar on the Profile Page and choose a new one from the available options.',
      ),
      _FAQItem(
        'How can I manage notifications?',
        'Open notification settings from the Profile Page to customize which reminders you receive.',
      ),
      _FAQItem(
        'Can I receive daily notifications for Zikar?',
        'Yes, you\'ll receive daily reminders to enter your Zikar, helping you stay consistent with your practice.',
      ),
    ]),
  ];

  List<_FAQSection> get _filteredSections {
    if (_query.trim().isEmpty) return _sections;
    final q = _query.toLowerCase();
    return _sections
        .map((section) {
      final matches = section.items
          .where((i) =>
      i.question.toLowerCase().contains(q) ||
          i.answer.toLowerCase().contains(q))
          .toList();
      return _FAQSection(section.title, section.icon, matches);
    })
        .where((section) => section.items.isNotEmpty)
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sections = _filteredSections;
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          _buildHeader(colors),
          Expanded(
            child: sections.isEmpty
                ? _buildNoResults(colors)
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return _buildSection(section, colors);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppThemeColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.headerGradientEnd, colors.headerGradientEnd],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How can we help?',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Answers to common questions about your practice and account',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 12,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: colors.textPrimary,
                ),
                decoration: InputDecoration(
                  // border: InputBorder.none,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colors.emerald,width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: colors.emerald,width: 1),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  prefixIcon: Icon(Icons.search_rounded, color: colors.emeraldDeep),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                    icon: Icon(Icons.close_rounded, size: 18, color: colors.textSecondary),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  ),
                  hintText: 'Search a question…',
                  hintStyle: TextStyle(
                    color: colors.textSecondary,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(_FAQSection section, AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: colors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FaIcon(section.icon, size: 15, color: colors.emeraldDeep),
              ),
              const SizedBox(width: 10),
              Text(
                section.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: colors.emeraldDeep,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...section.items.map((item) => _buildFAQItem(item, colors)),
        ],
      ),
    );
  }

  Widget _buildFAQItem(_FAQItem item, AppThemeColors colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 14),
              childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
              iconColor: colors.emeraldDeep,
              collapsedIconColor: colors.textSecondary,
              title: Text(
                item.question,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                  color: colors.textPrimary,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_down_rounded, size: 22, color: colors.textSecondary),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.answer,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: colors.textSecondary,
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoResults(AppThemeColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 84,
              width: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.emerald.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                color: colors.emeraldDeep,
                size: 36,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No matching questions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colors.textPrimary,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try a different search term.',
              style: TextStyle(
                fontSize: 13,
                color: colors.textSecondary,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
          ],
        ),
      ),
    );
  }
}