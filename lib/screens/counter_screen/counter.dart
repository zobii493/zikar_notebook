import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naqashbandi_shazli/screens/counter_screen/widgets/dotted_progress_circle.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../core/app_theme_colors.dart';
import '../../utils/snackbar_utils.dart';
import '../../viewmodel/counter_provider.dart';
import '../../widgets/custom_paint.dart';
import 'package:vibration/vibration.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  void _showEditDialog(BuildContext context) {
    final provider = Provider.of<CounterProvider>(context, listen: false);
    final TextEditingController controller = TextEditingController(
      text: provider.maxValue.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final colors = context.appColors;
        return AlertDialog(
          backgroundColor: colors.cardBackground,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Target Value',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'TARGET VALUE',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: colors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              color: colors.headingPrimary,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: colors.background, width: 2),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.background,
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: colors.background, width: 2),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.bold,
                ),
                foregroundColor: colors.emeraldDeep,
              ),
              child: const Text('Cancel', style: TextStyle(color: AppColors.maroonColor)),
            ),
            ElevatedButton(
              onPressed: () {
                final int newValue =
                    int.tryParse(controller.text) ?? provider.maxValue;
                if (newValue > 0) {
                  provider.updateMaxValue(newValue);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  _showErrorDialog(context);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 50),
                backgroundColor: colors.emeraldDeep,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: colors.emeraldDeep, width: 2),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.bold,
                ),
                foregroundColor: AppColors.whiteColor,
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    final colors = context.appColors;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.cardBackground,
        title: Text(
          'Invalid Value',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        content: Text(
          'Target must be greater than 0',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            height: 1.4,
            color: colors.textSecondary,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 50),
              backgroundColor: colors.emeraldDeep,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              side: BorderSide(color: colors.emeraldDeep, width: 2),
              textStyle: const TextStyle(
                fontSize: 18,
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.bold,
              ),
              foregroundColor: AppColors.whiteColor,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  double getProportionateScreenWidth(double inputWidth) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (inputWidth / 375.0) * screenWidth;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CounterProvider>(context);
    final colors = context.appColors;
    double percent = provider.maxValue > 0
        ? provider.counter / provider.maxValue
        : 0;
    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                ClipRRect(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colors.headerGradientStart,
                          colors.headerGradientEnd,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: CrosshatchPainter()),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 50,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Goal Progress',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'PlusJakartaSans',
                                      color: colors.headingSecondary,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _showEditDialog(context),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 10,
                                      backgroundColor: colors.gold,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: const Text(
                                      'Set Target',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: -15,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.maroonColor,
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Target',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: AppColors.maroonColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.circle,
                            size: 4,
                            color: AppColors.maroonColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            provider.maxValue.toString(),
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              color: AppColors.maroonColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: DottedProgressCircle(
                percent: percent.clamp(0, 1).toDouble(),
                current: provider.counter,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 190,
                      height: 190,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.gold.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colors.emeraldDeep.withValues(alpha: 0.35),
                            blurRadius: 24,
                            spreadRadius: 2,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Material(
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          splashColor: colors.gold.withValues(alpha: 0.3),
                          onTap: () async {
                            if (await Vibration.hasVibrator() ?? false) {
                              Vibration.vibrate(duration: 40, amplitude: 150);
                            }
                            provider.incrementCounter();
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colors.headerGradientStart,
                                  colors.headerGradientEnd,
                                ],
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned.fill(
                                  child: ClipOval(
                                    child: Opacity(
                                      opacity: 0.4,
                                      child: CustomPaint(
                                        painter: CrosshatchPainter(),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.whiteColor.withValues(alpha: 
                                        0.15,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.fingerprint,
                                  size: 52,
                                  color: colors.gold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'TAP TO COUNT',
                      style: TextStyle(
                        color: colors.emeraldDeep,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: colors.cardBackground,
                        title: Text(
                          'Confirm Reset',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: colors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          'Do you want to reset the counter?',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: colors.textSecondary,
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(
                                color: colors.background,
                                width: 2,
                              ),
                              foregroundColor: colors.emeraldDeep,
                              backgroundColor: colors.background,
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('No', style: TextStyle(color: AppColors.maroonColor)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              provider.resetCounter();
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(
                                color: colors.emeraldDeep,
                                width: 2,
                              ),
                              foregroundColor: AppColors.whiteColor,
                              backgroundColor: colors.emeraldDeep,
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: AppColors.maroonColor, width: 2),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.bold,
                    ),
                    foregroundColor: AppColors.maroonColor,
                  ),
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool success = await provider.saveData();
                      if (!context.mounted) return;

                      context.showTopSnackBar(
                        success
                            ? 'Record saved successfully!'
                            : 'Failed to save record.',
                        success
                            ? AppColors.antiqueGoldColor
                            : AppColors.maroonColor,
                      );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: AppColors.emeraldDeepColor,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

