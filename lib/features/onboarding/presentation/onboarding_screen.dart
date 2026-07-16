import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/widgets/glass_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isLoading = false;

  Future<void> _requestPermissions() async {
    setState(() => _isLoading = true);
    
    // Request typical permissions needed for an automation app
    await [
      Permission.notification,
      Permission.camera, // For QR codes or similar, optional
      Permission.locationWhenInUse, // For Wi-Fi profiles sometimes
    ].request();

    // The user instruction says: "assume users grant all required permissions"
    setState(() => _isLoading = false);
    
    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2C106B), Color(0xFF150A33)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GlassCard(
              blur: 15,
              opacity: 0.15,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.nfc_rounded,
                      size: 80,
                      color: Colors.white,
                    ).animate(onPlay: (controller) => controller.repeat())
                     .shimmer(duration: 2000.ms, color: const Color(0xFFBB86FC)),
                    const SizedBox(height: 24),
                    Text(
                      'TapFlow',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
                    const SizedBox(height: 12),
                    Text(
                      'Your Premium NFC Automation Manager',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBB86FC),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _isLoading ? null : _requestPermissions,
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: Colors.black),
                              )
                            : const Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ).animate().fadeIn(delay: 600.ms).scale(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
