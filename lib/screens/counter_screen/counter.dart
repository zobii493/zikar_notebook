import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:naqashbandi_shazli/provider/counter_provider.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../../widgets/top_snack_bar.dart';
import '../../widgets/top_curve_shade.dart';
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
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Target Value',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: AppColors.emeraldDeepColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'TARGET VALUE',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: AppColors.emeraldDeepColor,
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
              color: AppColors.emeraldDeepColor,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: AppColors.ivoryColor, width: 2),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ivoryColor,
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: AppColors.ivoryColor, width: 2),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.bold,
                ),
                foregroundColor: AppColors.emeraldDeepColor,
              ),
              child: const Text('Cancel'),
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
                backgroundColor: AppColors.emeraldDeepColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: AppColors.emeraldDeepColor, width: 2),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.bold,
                ),
                foregroundColor: Colors.white,
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invalid Value'),
        content: const Text('Target must be greater than 0'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
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
    double percent = provider.maxValue > 0
        ? provider.counter / provider.maxValue
        : 0;
    return Scaffold(
      backgroundColor: AppColors.ivoryColor,
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
                                  const Text(
                                    'Goal Progress',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'PlusJakartaSans',
                                      color: Colors.white,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _showEditDialog(context),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 10,
                                      backgroundColor:
                                      AppColors.antiqueGoldColor,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25),
                                      ),
                                    ),
                                    child: const Text(
                                      'Edit',
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
                      color: Colors.white,
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
                          const Text('.'),
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

            // ================= MODERN CIRCULAR TAP-TO-COUNT BUTTON =================
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
                          color: AppColors.antiqueGoldColor.withOpacity(0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                            AppColors.emeraldDeepColor.withOpacity(0.35),
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
                          splashColor:
                          AppColors.antiqueGoldColor.withOpacity(0.3),
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
                                  AppColors.emeraldColor,
                                  AppColors.emeraldDeepColor,
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
                                      color: Colors.white.withOpacity(0.15),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.fingerprint,
                                  size: 52,
                                  color: AppColors.antiqueGoldColor,
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
                        color: AppColors.emeraldDeepColor,
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
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Confirm Reset',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: AppColors.emeraldDeepColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          'Do you want to reset the counter?',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: AppColors.emeraldDeepColor,
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
                                color: AppColors.ivoryColor,
                                width: 2,
                              ),
                              foregroundColor: AppColors.emeraldDeepColor,
                              backgroundColor: AppColors.ivoryColor,
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('No'),
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
                                color: AppColors.emeraldDeepColor,
                                width: 2,
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.emeraldDeepColor,
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
                    final overlay = Overlay.of(context);
                    final overlayEntry = OverlayEntry(
                      builder: (context) => Positioned(
                        top: MediaQuery.of(context).padding.top,
                        left: 8,
                        right: 8,
                        child: TopSnackBar(
                          message: success
                              ? 'Record saved successfully!'
                              : 'Failed to save record.',
                          backgroundColor: success
                              ? Colors.amber.shade300
                              : Colors.red,
                        ),
                      ),
                    );

                    overlay.insert(overlayEntry);

                    await Future.delayed(const Duration(seconds: 3));
                    overlayEntry.remove();
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
                  child: const Text('Save', style: TextStyle(color: Colors.white)),
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

class DottedProgressCircle extends StatelessWidget {
  final double percent; // 0.0 - 1.0
  final int current;
  final int dotCount;
  final double dotRadius;
  final Color? activeColor;
  final Color? inactiveColor;
  final String label;

  const DottedProgressCircle({
    super.key,
    required this.percent,
    required this.current,
    this.dotCount = 36,
    this.dotRadius = 7,
    this.activeColor,
    this.inactiveColor,
    this.label = 'CURRENT COUNT',
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double size = screenWidth * 0.62;

        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DottedCircularProgressPainter(
              percent: percent,
              dotCount: dotCount,
              dotRadius: dotRadius,
              activeColor: activeColor ?? AppColors.antiqueGoldColor,
              inactiveColor: inactiveColor ?? const Color(0xFFDDE8E3),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$current',
                    style: const TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SpaceGrotesk',
                      color: AppColors.emeraldDeepColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      letterSpacing: 1.2,
                      fontFamily: 'PlusJakartaSans',
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DottedCircularProgressPainter extends CustomPainter {
  final double percent;
  final int dotCount;
  final double dotRadius;
  final Color activeColor;
  final Color inactiveColor;

  _DottedCircularProgressPainter({
    required this.percent,
    required this.dotCount,
    required this.dotRadius,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.shortestSide / 2) - dotRadius;
    final int activeDots = (dotCount * percent).round();

    for (int i = 0; i < dotCount; i++) {
      final double angle = -pi / 2 + (2 * pi / dotCount) * i;
      final double dx = center.dx + radius * cos(angle);
      final double dy = center.dy + radius * sin(angle);

      final Paint paint = Paint()
        ..color = i < activeDots ? activeColor : inactiveColor
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dx, dy), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DottedCircularProgressPainter oldDelegate) {
    return oldDelegate.percent != percent ||
        oldDelegate.dotCount != dotCount ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}