import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/fade_in_animation.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween:
            Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
            begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
            begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
            begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
    ]).animate(_gradientController);

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(
            begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
            begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
      TweenSequenceItem(
        tween:
            Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
            begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
    ]).animate(_gradientController);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color(0xFF4A148C), // Deep Purple 900
                  Color(0xFF7B1FA2), // Purple 700
                  Color(0xFFAB47BC), // Purple 400
                  Color(0xFF1A237E), // Indigo 900 (for depth)
                ],
                begin: _topAlignmentAnimation.value,
                end: _bottomAlignmentAnimation.value,
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInAnimation(
                  delay: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo_bookwise_new.jpg', // New Logo
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeInAnimation(
                  delay: 4,
                  child: Column(
                    children: [
                      Text(
                        'BookWise',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 56,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          shadows: [
                            const Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          "Révélez votre prochain coup de cœur",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.95),
                            fontStyle: FontStyle.italic,
                            letterSpacing: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                FadeInAnimation(
                  delay: 6,
                  child: Text(
                    'L’excellence littéraire à portée de main.\nDécouvrez, gérez et partagez vos lectures.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 60),
                FadeInAnimation(
                  delay: 8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4A148C),
                      elevation: 10,
                      shadowColor: Colors.black.withValues(alpha: 0.5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'COMMENCER',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
