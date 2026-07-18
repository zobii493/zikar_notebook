import 'package:flutter/material.dart';
import '../../../core/app_theme_colors.dart';

class ContributionHeatmap extends StatelessWidget {
  final Map<DateTime, int> dailyTotals;
  final void Function(DateTime day, int count)? onDayTap;

  const ContributionHeatmap({
    super.key,
    required this.dailyTotals,
    this.onDayTap,
  });

  static const List<String> _weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);

    final firstOfMonth = DateTime(today.year, today.month, 1);
    final daysInMonth = DateTime(today.year, today.month + 1, 0).day;
    final leadingBlanks = firstOfMonth.weekday % 7;

    final monthCounts = <int>[];
    for (int d = 1; d <= daysInMonth; d++) {
      final key = DateTime(today.year, today.month, d);
      final c = dailyTotals[key] ?? 0;
      if (c > 0) monthCounts.add(c);
    }
    final maxCount =
    monthCounts.isEmpty ? 0 : monthCounts.reduce((a, b) => a > b ? a : b);

    final totalCells = leadingBlanks + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _monthYearLabel(today),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: _weekdayLabels
              .map((label) => Expanded(
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ),
          ))
              .toList(),
        ),
        const SizedBox(height: 6),
        for (int r = 0; r < rows; r++) ...[
          if (r > 0) const SizedBox(height: 6),
          Row(
            children: List.generate(7, (c) {
              final cellIndex = r * 7 + c;
              final dayNumber = cellIndex - leadingBlanks + 1;
              final isValidDay = dayNumber >= 1 && dayNumber <= daysInMonth;

              if (!isValidDay) {
                return const Expanded(child: SizedBox(height: 34));
              }

              final dayKey = DateTime(today.year, today.month, dayNumber);
              final isFuture = dayKey.isAfter(todayKey);
              final count = dailyTotals[dayKey] ?? 0;
              final isToday = dayKey == todayKey;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: GestureDetector(
                    onTap: isFuture ? null : () => onDayTap?.call(dayKey, count),
                    child: Tooltip(
                      message:
                      isFuture ? '' : '${_formatDate(dayKey)} · $count zikar',
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isFuture
                                ? Colors.transparent
                                : _colorFor(count, maxCount, colors),
                            borderRadius: BorderRadius.circular(8),
                            border: isToday
                                ? Border.all(color: colors.gold, width: 1.6)
                                : (isFuture
                                ? Border.all(color: colors.border)
                                : null),
                          ),
                          child: Text(
                            '$dayNumber',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight:
                              isToday ? FontWeight.bold : FontWeight.w500,
                              fontFamily: 'PlusJakartaSans',
                              color: isFuture
                                  ? colors.textSecondary
                                  : (count > 0 && _isDark(count, maxCount)
                                  ? Colors.white
                                  : colors.textPrimary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  bool _isDark(int count, int maxCount) {
    if (maxCount <= 0) return false;
    return (count / maxCount) >= 0.5;
  }

  Color _colorFor(int count, int maxCount, AppThemeColors colors) {
    if (count <= 0) return colors.border;
    if (maxCount <= 0) return colors.border;

    final ratio = count / maxCount;
    if (ratio < 0.25) return colors.emerald.withValues(alpha: 0.3);
    if (ratio < 0.5) return colors.emerald.withValues(alpha: 0.55);
    if (ratio < 0.75) return colors.emerald.withValues(alpha: 0.8);
    return colors.emeraldDeep;
  }

  String _monthYearLabel(DateTime d) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${names[d.month - 1]} ${d.year}';
  }

  String _monthAbbrev(int month) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[month - 1];
  }

  String _formatDate(DateTime d) => '${d.day} ${_monthAbbrev(d.month)} ${d.year}';
}