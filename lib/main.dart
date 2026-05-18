import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'pages/admin/admin_dashboard_page.dart';
import 'pages/auth/onboarding_page.dart';
import 'pages/auth/splash_page.dart';
import 'pages/home/app_shell_page.dart';
import 'pages/professional/professional_detail_page.dart';
import 'pages/profile/verification_page.dart';
import 'providers/app_provider.dart';
import 'providers/marketplace_provider.dart';
import 'services/local_storage_service.dart';

void main() {
  runApp(const KiraApp());
}

class KiraApp extends StatelessWidget {
  const KiraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localStorageService = LocalStorageService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProvider(localStorageService),
        ),
        ChangeNotifierProvider(
          create: (_) => MarketplaceProvider(localStorageService),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AppRoutes.splash:
              return MaterialPageRoute(builder: (_) => const SplashPage());
            case AppRoutes.onboarding:
              return MaterialPageRoute(builder: (_) => const OnboardingPage());
            case AppRoutes.shell:
              return MaterialPageRoute(builder: (_) => const AppShellPage());
            case AppRoutes.professionalDetails:
              final professionalId = settings.arguments as String? ?? '';
              return MaterialPageRoute(
                builder: (_) => ProfessionalDetailPage(
                  professionalId: professionalId,
                ),
              );
            case AppRoutes.verification:
              return MaterialPageRoute(builder: (_) => const VerificationPage());
            case AppRoutes.admin:
              return MaterialPageRoute(builder: (_) => const AdminDashboardPage());
            default:
              return MaterialPageRoute(builder: (_) => const SplashPage());
          }
        },
      ),
    );
  }
}
