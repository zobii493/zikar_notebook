import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/app_colors.dart';
import '../../viewmodel/fezunoor_provider.dart';

class FezuNoor extends StatelessWidget {
  const FezuNoor({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FezuNoorProvider>(context);
    final double progress = provider.calculateProgress(); // 0-100
    final int completed = provider.isCheckedList.where((c) => c).length;
    final int total = provider.checkboxLabels.length;

    return Scaffold(
      backgroundColor: AppColors.ivoryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.emeraldDeepColor,
        centerTitle: true,
        title: const Text(
          'فیوض النور',
          style: TextStyle(
            color: AppColors.antiqueGoldColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Amiri',
          ),
        ),
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.angleLeft,
            color: AppColors.antiqueGoldColor,
          ),
          onPressed: () {
            provider.saveProgressBar(progress);
            Navigator.of(context).pop(progress);
          },
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.ellipsisVertical,
              color: AppColors.antiqueGoldColor,
              size: 20,
            ),
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
                  'YOUR WAZAIF',
                  style: TextStyle(
                    color: AppColors.emeraldDeepColor.withValues(alpha: .55),
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
                    color: AppColors.emeraldDeepColor.withValues(alpha: .55),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(provider.checkboxLabels.length, (index) {
            final bool isChecked = provider.isCheckedList[index];
            return _WazifaTile(
              index: index,
              label: provider.checkboxLabels[index],
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

  void _showOptionsMenu(BuildContext context, FezuNoorProvider provider) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 16, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      elevation: 6,
      items: [
        _menuItem(
          'undo',
          FontAwesomeIcons.rotateLeft,
          'Undo last task',
          AppColors.emeraldDeepColor,
        ),
        _menuItem(
          'history',
          FontAwesomeIcons.clockRotateLeft,
          'History',
          AppColors.emeraldDeepColor,
        ),
        _menuItem(
          'delete',
          FontAwesomeIcons.trash,
          'Delete all completed',
          AppColors.maroonColor,
        ),
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

  void _showDeleteConfirmation(
    BuildContext context,
    FezuNoorProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete completed tasks?',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.bold,
            color: AppColors.emeraldDeepColor,
          ),
        ),
        content: const Text(
          'This will clear every wazifa you have marked as completed. This cannot be undone.',
          style: TextStyle(fontFamily: 'PlusJakartaSans', height: 1.4),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.emeraldDeepColor,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.removeAllCompleted();
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.maroonColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _showHistoryDialog(
    BuildContext context,
    List<Map<String, dynamic>> history,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 6),
        contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        title: const Text(
          'Completion history',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.bold,
            color: AppColors.emeraldDeepColor,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: history.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  child: Text(
                    'Nothing completed yet.',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: Colors.black54,
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: history.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (_, i) => ListTile(
                    dense: true,
                    title: Text(
                      history[i]["label"],
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w600,
                        color: AppColors.emeraldDeepColor,
                      ),
                    ),
                    subtitle: Text(
                      "${history[i]["day"]}, ${history[i]["date"]} at ${history[i]["time"]}",
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

/// Header card: tasbih-style bead ring + completion summary.
/// This is the screen's signature element — ties the progress metaphor
/// back to the physical counting-beads practice the app is built around.
class _ProgressHeaderCard extends StatelessWidget {
  const _ProgressHeaderCard({
    required this.completed,
    required this.total,
    required this.percentage,
  });

  final int completed;
  final int total;
  final double percentage; // 0-100

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.emeraldDeepColor, AppColors.emeraldColor],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.emeraldDeepColor.withValues(alpha: .25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 84,
            width: 84,
            child: CustomPaint(
              painter: _TasbihRingPainter(fraction: percentage / 100),
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
                const Text(
                  'YOUR PROGRESS',
                  style: TextStyle(
                    color: Colors.white70,
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
                      ? 'All wazaif completed — MashaAllah'
                      : '${total - completed} remaining',
                  style: TextStyle(
                    color: AppColors.antiqueGoldColor,
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

/// Draws a ring of small bead-like dots (tasbih), filling gold→emerald
/// as more dots complete, instead of a plain circular progress arc.
class _TasbihRingPainter extends CustomPainter {
  _TasbihRingPainter({required this.fraction});

  final double fraction; // 0.0 - 1.0
  static const int beadCount = 33; // traditional tasbih count

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
        ..color = isFilled ? AppColors.antiqueGoldColor : Colors.white24
        ..style = PaintingStyle.fill;

      canvas.drawCircle(beadCenter, isFilled ? 3.2 : 2.4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TasbihRingPainter oldDelegate) =>
      oldDelegate.fraction != fraction;
}

class _WazifaTile extends StatelessWidget {
  const _WazifaTile({
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isChecked
              ? AppColors.emeraldDeepColor.withValues(alpha: .06)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isChecked
                ? AppColors.emeraldColor.withValues(alpha: .35)
                : Colors.grey.shade200,
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
                        color: isChecked
                            ? AppColors.emeraldDeepColor.withValues(alpha: .55)
                            : AppColors.emeraldDeepColor,
                        decoration: isChecked
                            ? TextDecoration.lineThrough
                            : null,
                        decorationColor: AppColors.emeraldDeepColor.withValues(
                          alpha: .35,
                        ),
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
                          ? AppColors.antiqueGoldColor.withValues(alpha: .18)
                          : AppColors.antiqueGoldColor.withValues(alpha: .12),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontFamily: 'SpaceGrotesk',
                        color: AppColors.emeraldDeepColor,
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

/// Custom checkbox — replaces Flutter's built-in Checkbox so the
/// completed state always shows emeraldDeepColor + gold check, with no
/// grey "disabled" fallback.
class _CircleCheckbox extends StatelessWidget {
  const _CircleCheckbox({required this.isChecked});

  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isChecked ? AppColors.emeraldDeepColor : Colors.white,
        border: Border.all(color: AppColors.emeraldDeepColor, width: 1.6),
      ),
      child: isChecked
          ? const Icon(Icons.check, size: 17, color: AppColors.antiqueGoldColor)
          : null,
    );
  }
}
