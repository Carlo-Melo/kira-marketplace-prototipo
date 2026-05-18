import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/app_provider.dart';
import '../../providers/marketplace_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_bootstrap);
  }

  Future<void> _bootstrap() async {
    final appProvider = context.read<AppProvider>();
    final marketplaceProvider = context.read<MarketplaceProvider>();
    if (!appProvider.initialized) {
      await appProvider.initialize();
    }
    if (!marketplaceProvider.initialized) {
      await marketplaceProvider.initialize();
    }
    await Future<void>.delayed(AppConstants.splashDuration);
    if (!mounted) return;
    final nextRoute = appProvider.onboardingCompleted
        ? AppRoutes.shell
        : AppRoutes.onboarding;
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D7E71), Color(0xFF0A5E55)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.7, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.cut_rounded, size: 46, color: Color(0xFF0D7E71)),
                ),
                SizedBox(height: 18),
                Text(
                  'Kira Marketplace',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Beleza sob demanda',
                  style: TextStyle(color: Color(0xFFD7FFF8), fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
