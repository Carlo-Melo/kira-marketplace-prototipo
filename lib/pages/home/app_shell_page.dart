import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../booking/bookings_page.dart';
import '../professional/professional_dashboard_page.dart';
import '../profile/profile_page.dart';
import 'home_page.dart';

class AppShellPage extends StatefulWidget {
  const AppShellPage({super.key});

  @override
  State<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends State<AppShellPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final titles = <String>[
      'Kira Marketplace',
      'Agendamentos',
      'Dashboard Profissional',
      'Meu Perfil',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index]),
        actions: [
          IconButton(
            tooltip: 'Painel admin',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.admin),
            icon: const Icon(Icons.admin_panel_settings_outlined),
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          HomePage(
            onOpenProfessional: (professionalId) {
              Navigator.of(context).pushNamed(
                AppRoutes.professionalDetails,
                arguments: professionalId,
              );
            },
          ),
          const BookingsPage(),
          const ProfessionalDashboardPage(),
          ProfilePage(
            onOpenVerification: () {
              Navigator.of(context).pushNamed(AppRoutes.verification);
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded),
            label: 'Marketplace',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note_rounded),
            label: 'Agenda',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics_rounded),
            label: 'Profissional',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
