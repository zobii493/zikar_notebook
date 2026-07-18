import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../core/app_theme_colors.dart';
import '../../widgets/custom_paint.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.nextScreenBuilder,
    this.minDuration = const Duration(milliseconds: 2200),
  });

  final Widget Function() nextScreenBuilder;
  final Duration minDuration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineFade;
  late final Animation<double> _beadsProgress;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _beadsProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
      ),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
      ),
    );
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
    _scheduleNavigation();
  }

  Future<void> _scheduleNavigation() async {
    await Future.wait([
      Future.delayed(widget.minDuration),
      _controller.forward().orCancel.catchError((_) {}),
    ]);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: widget.nextScreenBuilder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.headerGradientStart, colors.headerGradientEnd],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.5,
                child: CustomPaint(painter: CrosshatchPainter()),
              ),
            ),

            // Soft radial glow behind the badge for depth.
            Align(
              alignment: const Alignment(0, -0.15),
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.gold.withValues(alpha: 0.16),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // ===== Tasbih (prayer bead) badge =====
                  Center(
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: AnimatedBuilder(
                          animation: _beadsProgress,
                          builder: (context, child) {
                            return SizedBox(
                              width: 132,
                              height: 132,
                              child: CustomPaint(
                                painter: _TasbihBadgePainter(
                                  progress: _beadsProgress.value,
                                  beadColor: colors.goldLight,
                                  trackColor: colors.gold.withValues(alpha: 0.18),
                                ),
                                child: child,
                              ),
                            );
                          },
                          child: Center(
                            child: Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [colors.goldLight, colors.gold],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'الله',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: colors.headerGradientStart,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== App name =====
                  Center(
                    child: FadeTransition(
                      opacity: _textFade,
                      child: SlideTransition(
                        position: _textSlide,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'نقشبندی شاذلی',
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: colors.goldLight,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'ZIKAR NOTEBOOK',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 12.5,
                                letterSpacing: 4,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===== Divider =====
                  Center(
                    child: FadeTransition(
                      opacity: _taglineFade,
                      child: Container(
                        width: 46,
                        height: 2,
                        decoration: BoxDecoration(
                          color: colors.gold,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ===== Tagline =====
                  Center(
                    child: FadeTransition(
                      opacity: _taglineFade,
                      child: Text(
                        'Your companion for daily Zikr',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 4),

                  // ===== Loading indicator =====
                  Center(
                    child: FadeTransition(
                      opacity: _taglineFade,
                      child: SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colors.gold.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Decorative tasbih (prayer bead) ring drawn around the central badge.
/// Beads fill in clockwise as [progress] animates from 0 to 1, giving a
/// subtle "counting" motion that ties directly into the app's zikar
/// theme — more distinctive here than a generic icon.
class _TasbihBadgePainter extends CustomPainter {
  _TasbihBadgePainter({
    required this.progress,
    required this.beadColor,
    required this.trackColor,
  });

  final double progress;
  final Color beadColor;
  final Color trackColor;
  static const int beadCount = 28;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final filledBeads = (beadCount * progress).round();

    for (int i = 0; i < beadCount; i++) {
      final angle = (2 * math.pi * i / beadCount) - math.pi / 2;
      final beadCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final bool isFilled = i < filledBeads;
      final paint = Paint()
        ..color = isFilled ? beadColor : trackColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(beadCenter, isFilled ? 4.2 : 3.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TasbihBadgePainter oldDelegate) =>
      oldDelegate.progress != progress ||
          oldDelegate.beadColor != beadColor ||
          oldDelegate.trackColor != trackColor;
}