import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme_colors.dart';
import '../../viewmodel/checklist_provider.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({
    super.key,
    required this.appBarTitle,
    required this.itemsLabel,
    required this.createProvider,
  });

  final String appBarTitle;
  final String itemsLabel;
  final ChecklistProvider Function() createProvider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChecklistProvider>(
      create: (_) => createProvider(),
      child: _ChecklistView(appBarTitle: appBarTitle, itemsLabel: itemsLabel),
    );
  }
}

class _ChecklistView extends StatelessWidget {
  const _ChecklistView({required this.appBarTitle, required this.itemsLabel});

  final String appBarTitle;
  final String itemsLabel;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChecklistProvider>(context);
    final double progress = provider.calculateProgress();
    final int completed = provider.isCheckedList.where((c) => c).length;
    final int total = provider.labels.length;
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.emeraldDeepColor,
        centerTitle: true,
        title: Text(
          appBarTitle,
          style: TextStyle(
            color: colors.gold,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Amiri',
          ),
        ),
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.angleLeft, color: colors.gold),
          onPressed: () {
            provider.saveProgressBar(progress);
            Navigator.of(context).pop(progress);
          },
        ),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.ellipsisVertical, color: colors.gold, size: 20),
            onPressed: () => _showOptionsMenu(context, provider),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _ProgressHeaderCard(
              completed: completed,
              total: total,
              percentage: progress,
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'YOUR ${itemsLabel.toUpperCase()}',
                  style: TextStyle(
                    color: colors.textPrimary.withValues(alpha: .55),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                const Spacer(),
                Text(
                  '$completed / $total',
                  style: TextStyle(
                    color: colors.textPrimary.withValues(alpha: .55),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(provider.labels.length, (index) {
            final bool isChecked = provider.isCheckedList[index];
            return _ChecklistTile(
              index: index,
              label: provider.labels[index],
              isChecked: isChecked,
              onTap: isChecked
                  ? null
                  : () => provider.completeTaskWithDialog(context, index),
            );
          }),
        ],
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, ChecklistProvider provider) {
    final colors = context.appColors;
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: colors.cardBackground,
      elevation: 6,
      items: [
        _menuItem('undo', FontAwesomeIcons.rotateLeft, 'Undo last task', colors.textPrimary),
        _menuItem('history', FontAwesomeIcons.clockRotateLeft, 'History', colors.textPrimary),
        PopupMenuItem<String>(
          enabled: false,
          height: 1,
          child: Divider(color: colors.gold.withValues(alpha: 0.5), thickness: 1),
        ),
        _menuItem('delete', FontAwesomeIcons.trash, 'Delete all completed', colors.maroon),
      ],
    ).then((value) async {
      if (!context.mounted || value == null) return;

      if (value == 'undo') {
        provider.undoLastTask();
      } else if (value == 'delete') {
        _showDeleteConfirmation(context, provider);
      } else if (value == 'history') {
        final history = await provider.getCompletionHistory();
        if (!context.mounted) return;
        _showHistoryDialog(context, history);
      }
    });
  }

  PopupMenuItem<String> _menuItem(
      String value,
      FaIconData icon,
      String label,
      Color color,
      ) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          FaIcon(icon, size: 15, color: color),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ChecklistProvider provider) {
    final colors = context.appColors;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete completed tasks?',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        content: Text(
          'This will clear every item you have marked as completed. This cannot be undone.',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            height: 1.4,
            color: colors.textPrimary,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: BorderSide(color: colors.emeraldDeep),
              foregroundColor: colors.emeraldDeep,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'PlusJakartaSans'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.removeAllCompleted();
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.maroon,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'PlusJakartaSans'),
            ),
          ),
        ],
      ),
    );
  }

  void _showHistoryDialog(BuildContext context, List<Map<String, dynamic>> history) {
    final colors = context.appColors;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 6),
        contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        title: Text(
          'Completion history',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: history.isEmpty
              ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Text(
              'Nothing completed yet.',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: colors.textSecondary,
              ),
            ),
          )
              : ListView.separated(
            shrinkWrap: true,
            itemCount: history.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: colors.border),
            itemBuilder: (_, i) => ListTile(
              dense: true,
              title: Text(
                history[i]["label"],
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              subtitle: Text(
                "${history[i]["day"]}, ${history[i]["date"]} at ${history[i]["time"]}",
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  color: colors.textPrimary.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressHeaderCard extends StatelessWidget {
  const _ProgressHeaderCard({
    required this.completed,
    required this.total,
    required this.percentage,
  });

  final int completed;
  final int total;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.headerGradientEnd, colors.headerGradientEnd],
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 84,
            width: 84,
            child: CustomPaint(
              painter: _TasbihRingPainter(
                fraction: percentage / 100,
                filledColor: colors.gold,
                emptyColor: Colors.white.withValues(alpha: 0.24),
              ),
              child: Center(
                child: Text(
                  '${percentage.round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR PROGRESS',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    fontSize: 11,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$completed of $total completed',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  completed == total
                      ? 'All completed — MashaAllah'
                      : '${total - completed} remaining',
                  style: TextStyle(
                    color: colors.gold,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
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
}

class _TasbihRingPainter extends CustomPainter {
  // CustomPainter has no BuildContext, so the colors it needs must be
  // passed in through the constructor instead of `context.appColors`.
  _TasbihRingPainter({
    required this.fraction,
    required this.filledColor,
    required this.emptyColor,
  });

  final double fraction;
  final Color filledColor;
  final Color emptyColor;
  static const int beadCount = 33;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final filledBeads = (beadCount * fraction).round();

    for (int i = 0; i < beadCount; i++) {
      final angle = (2 * math.pi * i / beadCount) - math.pi / 2;
      final beadCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final bool isFilled = i < filledBeads;
      final paint = Paint()
        ..color = isFilled ? filledColor : emptyColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(beadCenter, isFilled ? 3.2 : 2.4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TasbihRingPainter oldDelegate) =>
      oldDelegate.fraction != fraction ||
          oldDelegate.filledColor != filledColor ||
          oldDelegate.emptyColor != emptyColor;
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({
    required this.index,
    required this.label,
    required this.isChecked,
    required this.onTap,
  });

  final int index;
  final String label;
  final bool isChecked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isChecked
              ? colors.emeraldDeep.withValues(alpha: .06)
              : colors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isChecked ? colors.emerald.withValues(alpha: .35) : colors.border,
            width: 1.2,
          ),
          boxShadow: isChecked
              ? []
              : [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  _CircleCheckbox(isChecked: isChecked),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        color: isChecked
                            ? colors.textPrimary.withValues(alpha: .55)
                            : colors.textPrimary,
                        decoration: isChecked ? TextDecoration.lineThrough : null,
                        decorationColor: colors.emeraldDeep.withValues(alpha: .35),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 26,
                    width: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isChecked
                          ? colors.gold.withValues(alpha: .18)
                          : colors.gold.withValues(alpha: .12),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontFamily: 'SpaceGrotesk',
                        color: colors.emeraldDeep,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleCheckbox extends StatelessWidget {
  const _CircleCheckbox({required this.isChecked});

  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isChecked ? colors.emeraldDeep : colors.cardBackground,
        border: Border.all(color: colors.emeraldDeep, width: 1.6),
      ),
      child: isChecked ? Icon(Icons.check, size: 17, color: colors.gold) : null,
    );
  }
}