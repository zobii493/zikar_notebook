import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:naqashbandi_shazli/core/app_colors.dart';

import '../../core/app_theme_colors.dart';
import '../../utils/responsive.dart';

class ZikarHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const ZikarHistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    // Latest entries first
    final entries = history.reversed.toList();
    final colors = context.appColors;

    // Total zikar across all history, shown as a quick summary header.
    final int totalZikar = entries.fold<int>(0, (sum, e) {
      final z = e['zikar'];
      return sum + (z is String ? int.parse(z) : (z as int));
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.emeraldDeepColor,
        centerTitle: true,
        title: Text(
          'Zikar History',
          style: TextStyle(
            color: colors.gold,
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFont(22),
            fontFamily: 'PlusJakartaSans',
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: FaIcon(
            FontAwesomeIcons.angleLeft,
            color: colors.gold,
          ),
        ),
      ),
      body: entries.isEmpty
          ? _buildEmptyState(context)
          : Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.maxContentWidth),
          child: Column(
            children: [
              _buildSummaryBanner(context, entries.length, totalZikar),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(
                    left: context.horizontalPadding.left,
                    right: context.horizontalPadding.right,
                    top: 16,
                    bottom: 24,
                  ),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _buildHistoryCard(context, entries[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBanner(BuildContext context, int count, int totalZikar) {
    final colors = context.appColors;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        left: context.horizontalPadding.left,
        right: context.horizontalPadding.right,
        top: 16,
        bottom: 4,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.headerGradientEnd, colors.headerGradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colors.headingPrimary.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_rounded,
              color: colors.gold,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count ${count == 1 ? 'entry' : 'entries'} recorded',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: context.responsiveFont(14),
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${NumberFormat.decimalPattern().format(totalZikar)} total zikar',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.whiteColor.withValues(alpha: 0.8),
                    fontSize: context.responsiveFont(12),
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

  Widget _buildHistoryCard(BuildContext context, Map<String, dynamic> entry) {
    DateTime dateTime;
    if (entry['date'] is String) {
      dateTime = DateTime.parse(entry['date']);
    } else {
      dateTime = entry['date'] as DateTime;
    }

    final formattedZikar = NumberFormat.decimalPattern().format(
      entry['zikar'] is String ? int.parse(entry['zikar']) : entry['zikar'],
    );

    final formattedDate = DateFormat('MMM d, yyyy').format(dateTime);
    final formattedTime = DateFormat('hh:mm a').format(dateTime);
    final day = (entry['day'] ?? '').toString();
    final colors = context.appColors;

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 42,
            width: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.emerald.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: colors.emeraldDeep,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.isEmpty ? 'Zikar' : day,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(15),
                    color: colors.textPrimary,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 12, color: colors.textSecondary),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: context.responsiveFont(12),
                        color: colors.textSecondary,
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.access_time_rounded,
                        size: 12, color: colors.textSecondary),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: context.responsiveFont(12),
                        color: colors.textSecondary,
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                formattedZikar,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(17),
                  color: colors.headingPrimary,
                  fontFamily: 'SpaceGrotesk',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.appColors;
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
                Icons.history_rounded,
                color: colors.emeraldDeep,
                size: 36,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No history yet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(18),
                color: colors.textPrimary,
                fontFamily: 'PlusJakartaSans',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Zikar entries you add will show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.responsiveFont(13),
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