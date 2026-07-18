import 'package:flutter/material.dart';
import 'package:naqashbandi_shazli/screens/journey_screen/widgets/contribution_heatmap.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme_colors.dart';
import '../../viewmodel/journey_provider.dart';

class JourneyPage extends StatelessWidget {
  const JourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<JourneyProvider>(
      create: (_) => JourneyProvider()..loadJourney(),
      child: const _JourneyView(),
    );
  }
}

class _JourneyView extends StatelessWidget {
  const _JourneyView();

  static const Map<String, IconData> _categoryIcons = {
    'شازلی ازکار': Icons.checklist_rounded,
    'اَسْمَاءُ الْحُسْنٰی': Icons.auto_stories_rounded,
    'اسم ذات الله': Icons.auto_awesome_rounded,
    'لَا إِلٰهَ إِلَّا اللهُ': Icons.mosque,
  };

  static const Map<String, int> _categoryGoals = {
    'شازلی ازکار': 42,
    'اَسْمَاءُ الْحُسْنٰی': 99,
    'اسم ذات الله': 12500000,
    'لَا إِلٰهَ إِلَّا اللهُ': 12500000,
  };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JourneyProvider>();
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: provider.isLoading
          ? Center(
        child: CircularProgressIndicator(color: colors.emeraldDeep),
      )
          : RefreshIndicator(
        color: colors.emeraldDeep,
        onRefresh: provider.loadJourney,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(provider, colors),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStatsRow(provider, colors),
                  const SizedBox(height: 24),
                  _sectionLabel('YOUR CONTRIBUTIONS', colors),
                  const SizedBox(height: 12),
                  _buildHeatmapCard(provider, colors),
                  const SizedBox(height: 24),
                  _sectionLabel('BREAKDOWN', colors),
                  const SizedBox(height: 12),
                  _buildBreakdown(provider, colors),
                  const SizedBox(height: 24),
                  _sectionLabel('MILESTONES', colors),
                  const SizedBox(height: 12),
                  _buildMilestones(provider, colors),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(JourneyProvider provider, AppThemeColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.headerGradientStart, colors.headerGradientEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Journey',
            style: TextStyle(
              color: colors.goldLight,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'PlusJakartaSans',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Every day of Zikar is a step closer',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
              fontFamily: 'PlusJakartaSans',
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              _buildStreakBadge(
                icon: Icons.local_fire_department_rounded,
                value: '${provider.currentStreak}',
                label: 'Day streak',
                highlighted: true,
                colors: colors,
              ),
              const SizedBox(width: 12),
              _buildStreakBadge(
                icon: Icons.emoji_events_rounded,
                value: '${provider.longestStreak}',
                label: 'Best streak',
                highlighted: false,
                colors: colors,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBadge({
    required IconData icon,
    required String value,
    required String label,
    required bool highlighted,
    required AppThemeColors colors,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: highlighted ? 0.18 : 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: highlighted ? colors.gold : Colors.white70,
              size: 26,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'SpaceGrotesk',
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(JourneyProvider provider, AppThemeColors colors) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.calendar_month_rounded,
            value: '${provider.totalActiveDays}',
            label: 'Active days',
            accent: colors.emerald,
            colors: colors,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            icon: Icons.auto_awesome_rounded,
            value: _formatCount(provider.totalZikar),
            label: 'Total zikar',
            accent: colors.gold,
            colors: colors,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color accent,
    required AppThemeColors colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: accent),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: colors.textSecondary,
              fontFamily: 'PlusJakartaSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, AppThemeColors colors) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w700,
            color: colors.textSecondary,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Divider(color: colors.border, thickness: 1)),
      ],
    );
  }

  Widget _buildHeatmapCard(JourneyProvider provider, AppThemeColors colors) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last 26 weeks',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
              fontFamily: 'PlusJakartaSans',
            ),
          ),
          const SizedBox(height: 12),
          ContributionHeatmap(
            dailyTotals: provider.dailyTotals,
            onDayTap: (day, count) {},
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Less', style: TextStyle(fontSize: 10, color: colors.textSecondary)),
              const SizedBox(width: 6),
              ..._legendSwatches(colors),
              const SizedBox(width: 6),
              Text('More', style: TextStyle(fontSize: 10, color: colors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _legendSwatches(AppThemeColors colors) {
    final alphas = [0.0, 0.35, 0.6, 0.85, 1.0];
    return alphas.map((a) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: a == 0 ? colors.border : colors.emerald.withValues(alpha: a),
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBreakdown(JourneyProvider provider, AppThemeColors colors) {
    if (provider.categoryTotals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.insights_rounded, size: 20, color: colors.textSecondary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Start any practice to see your breakdown here.',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 13,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ),
          ],
        ),
      );
    }

    final entries = provider.categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: entries.map((e) {
        final color = colors.emerald;
        final icon = _categoryIcons[e.key] ?? Icons.auto_awesome_rounded;
        final goal = _categoryGoals[e.key] ?? e.value;
        final ratio = goal > 0 ? (e.value / goal).clamp(0.0, 1.0) : 0.0;
        final percent = (ratio * 100).toStringAsFixed(ratio >= 1 ? 0 : 1);

        return _ProgressTile(
          colors: colors,
          accent: color,
          icon: icon,
          title: e.key,
          badgeText: '$percent%',
          subtitle: '${_formatCount(e.value)} of ${_formatCount(goal)} completed',
          ratio: ratio,
        );
      }).toList(),
    );
  }

  Widget _buildMilestones(JourneyProvider provider, AppThemeColors colors) {
    final milestones = [7, 30, 100, 365];
    return Column(
      children: milestones.map((target) {
        final achieved = provider.longestStreak >= target;
        final progress = (provider.longestStreak / target).clamp(0, 1).toDouble();
        final accent = achieved ? colors.gold : colors.emerald;
        final percent = (progress * 100).toStringAsFixed(progress >= 1 ? 0 : 1);

        return _ProgressTile(
          colors: colors,
          accent: accent,
          icon: achieved ? Icons.emoji_events_rounded : Icons.lock_outline_rounded,
          title: '$target-day streak',
          badgeText: '$percent%',
          subtitle: achieved
              ? 'Achieved — MashaAllah'
              : '${provider.longestStreak} of $target days',
          ratio: progress,
        );
      }).toList(),
    );
  }

  String _formatCount(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return '$value';
  }
}

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({
    required this.colors,
    required this.accent,
    required this.icon,
    required this.title,
    required this.badgeText,
    required this.subtitle,
    required this.ratio,
  });

  final AppThemeColors colors;
  final Color accent;
  final IconData icon;
  final String title;
  final String badgeText;
  final String subtitle;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'PlusJakartaSans',
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SpaceGrotesk',
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: colors.textSecondary,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    minHeight: 7,
                    value: ratio,
                    backgroundColor: accent.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(accent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}







