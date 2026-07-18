import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme_colors.dart';
import '../../viewmodel/ismezat_kalmasharif_provider.dart';
import '../history/ismezat_history.dart';

class IsmezatAndkalmaSarif extends StatefulWidget {
  final String title;
  final String subtitle;
  final String collectionName;
  final String historyCollection;

  const IsmezatAndkalmaSarif({
    super.key,
    required this.title,
    required this.subtitle,
    required this.collectionName,
    required this.historyCollection,
  });

  @override
  State<IsmezatAndkalmaSarif> createState() => _IsmezatAndkalmaSharifState();
}

class _IsmezatAndkalmaSharifState extends State<IsmezatAndkalmaSarif> {
  final TextEditingController mondayController = TextEditingController();
  final TextEditingController tuesdayController = TextEditingController();
  final TextEditingController wednesdayController = TextEditingController();
  final TextEditingController thursdayController = TextEditingController();
  final TextEditingController fridayController = TextEditingController();
  final TextEditingController saturdayController = TextEditingController();
  final TextEditingController sundayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<IsmezatProvider>(context, listen: false);
      provider.loadData(widget.collectionName, widget.historyCollection);
    });
  }

  void updateDailyZikar() {
    final provider = Provider.of<IsmezatProvider>(context, listen: false);
    final now = DateTime.now();
    final today = DateFormat('EEEE').format(now);

    if (!provider.isMondayAdded && mondayController.text.isNotEmpty) {
      provider.mondayZikar = int.parse(mondayController.text);
      provider.isMondayAdded = true;
      provider.updateDailyZikar(
        value: provider.mondayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }
    if (!provider.isTuesdayAdded && tuesdayController.text.isNotEmpty) {
      provider.tuesdayZikar = int.parse(tuesdayController.text);
      provider.isTuesdayAdded = true;
      provider.updateDailyZikar(
        value: provider.tuesdayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }
    if (!provider.isWednesdayAdded && wednesdayController.text.isNotEmpty) {
      provider.wednesdayZikar = int.parse(wednesdayController.text);
      provider.isWednesdayAdded = true;
      provider.updateDailyZikar(
        value: provider.wednesdayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }
    if (!provider.isThursdayAdded && thursdayController.text.isNotEmpty) {
      provider.thursdayZikar = int.parse(thursdayController.text);
      provider.isThursdayAdded = true;
      provider.updateDailyZikar(
        value: provider.thursdayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }
    if (!provider.isFridayAdded && fridayController.text.isNotEmpty) {
      provider.fridayZikar = int.parse(fridayController.text);
      provider.isFridayAdded = true;
      provider.updateDailyZikar(
        value: provider.fridayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }
    if (!provider.isSaturdayAdded && saturdayController.text.isNotEmpty) {
      provider.saturdayZikar = int.parse(saturdayController.text);
      provider.isSaturdayAdded = true;
      provider.updateDailyZikar(
        value: provider.saturdayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }
    if (!provider.isSundayAdded && sundayController.text.isNotEmpty) {
      provider.sundayZikar = int.parse(sundayController.text);
      provider.isSundayAdded = true;
      provider.updateDailyZikar(
        value: provider.sundayZikar,
        day: today,
        collectionName: widget.collectionName,
        historyCollection: widget.historyCollection,
      );
    }

    // Clear text fields
    mondayController.clear();
    tuesdayController.clear();
    wednesdayController.clear();
    thursdayController.clear();
    fridayController.clear();
    saturdayController.clear();
    sundayController.clear();
  }

  void resetWeek() {
    final provider = Provider.of<IsmezatProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final colors = context.appColors;
        return AlertDialog(
          backgroundColor: colors.cardBackground,
          title: Text(
            'Confirm Reset',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          content: Text(
            'Do you want to reset weekly Zikar?',
            style: TextStyle(fontFamily: 'PlusJakartaSans',
                height: 1.4,
                color: colors.textSecondary),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColors.maroonColor,
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: colors.emeraldDeep,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  provider.resetWeek(
                    widget.collectionName,
                    widget.historyCollection,
                  );

                  // Clear controllers
                  mondayController.clear();
                  tuesdayController.clear();
                  wednesdayController.clear();
                  thursdayController.clear();
                  fridayController.clear();
                  saturdayController.clear();
                  sundayController.clear();
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<IsmezatProvider>(context);
    int remainingZikar = provider.totalZikarGoal - provider.completedZikar;
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: AppColors.emeraldDeepColor,
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              color: colors.gold,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: 'Amiri',
            ),
          ),
        ),
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.angleLeft, color: colors.gold),
          onPressed: () {
            Navigator.pop(context, provider.completedPercentage);
            provider.loadData(widget.collectionName, widget.historyCollection);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ZikarHistoryScreen(history: provider.zikarHistory),
                  ),
                );
              },
              icon: FaIcon(
                FontAwesomeIcons.clockRotateLeft,
                color: colors.gold,
                size: 18,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.headingPrimary,
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colors.emerald.withValues(alpha: 0.15),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Zikar Tracker',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlusJakartaSans',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        label: 'TOTAL',
                        value: provider.completedZikar,
                        total: provider.totalZikarGoal,
                        dotColor: colors.emeraldDeep,
                        barColor: colors.emerald,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildStatCard(
                        label: 'REMAINING',
                        value: remainingZikar,
                        total: provider.totalZikarGoal,
                        dotColor: colors.gold,
                        barColor: colors.gold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    _buildDayZikarInput(
                      'Day 1',
                      mondayController,
                      provider.mondayZikar,
                      provider.isMondayAdded,
                    ),
                    _buildDayZikarInput(
                      'Day 2',
                      tuesdayController,
                      provider.tuesdayZikar,
                      provider.isTuesdayAdded,
                    ),
                    _buildDayZikarInput(
                      'Day 3',
                      wednesdayController,
                      provider.wednesdayZikar,
                      provider.isWednesdayAdded,
                    ),
                    _buildDayZikarInput(
                      'Day 4',
                      thursdayController,
                      provider.thursdayZikar,
                      provider.isThursdayAdded,
                    ),
                    _buildDayZikarInput(
                      'Day 5',
                      fridayController,
                      provider.fridayZikar,
                      provider.isFridayAdded,
                    ),
                    _buildDayZikarInput(
                      'Day 6',
                      saturdayController,
                      provider.saturdayZikar,
                      provider.isSaturdayAdded,
                    ),
                    _buildDayZikarInput(
                      'Day 7',
                      sundayController,
                      provider.sundayZikar,
                      provider.isSundayAdded,
                    ),
                    _buildTotalRow(
                      'Total Weekly Zikar    :  ',
                      provider.weeklyTotal,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: resetWeek,
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: colors.gold,
                            size: 22,
                          ),
                          label: const Text(
                            "Reset Week",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor,
                              fontFamily: "PlusJakartaSans",
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.maroonColor,
                            elevation: 6,
                            shadowColor: AppColors.maroonColor.withValues(alpha: .35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: updateDailyZikar,
                          icon: Icon(
                            Icons.add_circle_outline_rounded,
                            color: colors.gold,
                            size: 22,
                          ),
                          label: const Text(
                            "Add Zikar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor,
                              fontFamily: "PlusJakartaSans",
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emeraldDeepColor,
                            elevation: 6,
                            shadowColor: colors.emeraldDeep.withValues(alpha: .35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayZikarInput(String label,
      TextEditingController controller,
      int zikarValue,
      bool isAdded,) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: isAdded
              ? colors.emerald.withValues(alpha: 0.08)
              : colors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isAdded
                ? colors.emerald.withValues(alpha: 0.4)
                : colors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isAdded
                    ? colors.emerald
                    : colors.emeraldDeep.withValues(alpha: 0.1),
              ),
              child: isAdded
                  ? const Icon(
                  Icons.check, color: AppColors.whiteColor, size: 18)
                  : Text(
                label
                    .split(' ')
                    .last,
                style: TextStyle(
                  color: colors.emeraldDeep,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: isAdded
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      NumberFormat('#,###').format(zikarValue),
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.bold,
                        color: colors.headingPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
                  : TextField(
                cursorColor: colors.emeraldDeep,
                keyboardType: TextInputType.number,
                controller: controller,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  labelText: label,
                  labelStyle: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 13,
                  ),
                  hintText: 'Enter zikar count',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, int total) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.emeraldDeepColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.summarize_rounded,
                color: AppColors.whiteColor.withValues(alpha: 0.70), size: 22),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Total Weekly Zikar',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  fontFamily: 'PlusJakartaSans',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  NumberFormat('#,###').format(total),
                  style: TextStyle(
                    color: colors.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'SpaceGrotesk',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required int value,
    required int total,
    required Color dotColor,
    required Color barColor,
  }) {
    final formattedValue = NumberFormat('#,###').format(value);
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            formattedValue,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: total > 0 ? value / total : 0,
              backgroundColor: barColor.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }
}
