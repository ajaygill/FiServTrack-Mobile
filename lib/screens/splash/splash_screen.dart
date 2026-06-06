import 'dart:async';
import 'dart:math';
import 'package:fiservtrack/screens/auth/welcome_screen.dart';
import 'package:flutter/material.dart';

class _C {
  static const brand      = Color(0xFF134372);
  static const brandDeep  = Color(0xFF0C2E52);
  static const brandMid   = Color(0xFF1D5A9A);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _iconCtrl;
  late Animation<double> _iconScale;
  late Animation<double> _iconOpacity;

  late AnimationController _textCtrl;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  late AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();

    // 1. Icon Animation (Scales up and fades in)
    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _iconScale = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: Curves.easeOutBack),
    );
    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: Curves.easeIn),
    );

    // 2. Text Animation (Slides up slightly and fades in after icon)
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic),
    );

    // 3. Background Glow Animation (Slow rotation)
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Start Sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    // Start icon animation
    _iconCtrl.forward();

    // Wait slightly, then start text animation
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) _textCtrl.forward();

    // Hold the splash screen for a moment, then navigate
    await Future.delayed(const Duration(milliseconds: 2400));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Smooth fade transition to the main app
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    _textCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_C.brandMid, _C.brandDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── 1. Layered Background Glows (Clockwise & Counter-Clockwise) ──
            AnimatedBuilder(
              animation: _glowCtrl,
              builder: (context, child) {
                final angleClockwise = _glowCtrl.value * 2 * pi;
                final angleCounterClockwise = -_glowCtrl.value * 2 * pi;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Clockwise Sweep
                    Transform.rotate(
                      angle: angleClockwise,
                      child: Container(
                        width: size.width * 1.5,
                        height: size.width * 1.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.06),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Inner Counter-Clockwise Sweep (Creates Depth)
                    Transform.rotate(
                      angle: angleCounterClockwise,
                      child: Container(
                        width: size.width * 1.1,
                        height: size.width * 1.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.04),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // ── 2. Foreground Elements ──
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dynamic Pulsating Backdrop Glow behind the Logo Card
                    AnimatedBuilder(
                      animation: _glowCtrl,
                      builder: (context, child) {
                        final double pulse = 1.0 + 0.12 * sin(_glowCtrl.value * 2 * pi);
                        return Container(
                          width: 100 * pulse,
                          height: 100 * pulse,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.09),
                                blurRadius: 30,
                                spreadRadius: 6,
                              )
                            ],
                          ),
                        );
                      },
                    ),

                    // Animated App Icon Container
                    ScaleTransition(
                      scale: _iconScale,
                      child: FadeTransition(
                        opacity: _iconOpacity,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 28,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              'assets/icons/app_icon.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback icon with a subtle gradient matching the theme colors
                                return ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [_C.brand, _C.brandMid],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                                  child: const Icon(
                                    Icons.account_balance_wallet_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Animated Title with Slide & Dynamic Letter Spacing Expand
                FadeTransition(
                  opacity: _textOpacity,
                  child: SlideTransition(
                    position: _textSlide,
                    child: AnimatedBuilder(
                      animation: _textCtrl,
                      builder: (context, child) {
                        // Expands letter spacing gently from 5.0 to -1.0 as it fades in
                        final double spacing = (1.0 - _textCtrl.value) * 6.0 - 1.0;
                        return Text(
                          "FiservTrack",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: spacing,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}