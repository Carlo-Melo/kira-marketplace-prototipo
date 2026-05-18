import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/marketplace_provider.dart';
import '../../widgets/stat_card.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Painel administrativo')),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Text(
                'Metricas gerais (mockadas)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 980 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.55,
                    children: [
                      StatCard(
                        title: 'Usuarios',
                        value: '${provider.totalUsers}',
                        icon: Icons.people_alt_rounded,
                        color: const Color(0xFF2667FF),
                      ),
                      StatCard(
                        title: 'Profissionais',
                        value: '${provider.totalProfessionals}',
                        icon: Icons.work_rounded,
                        color: const Color(0xFF0D7E71),
                      ),
                      StatCard(
                        title: 'Agendamentos',
                        value: '${provider.totalBookings}',
                        icon: Icons.calendar_month_rounded,
                        color: const Color(0xFFF28E2B),
                      ),
                      StatCard(
                        title: 'Servicos ativos',
                        value: '${provider.totalActiveServices}',
                        icon: Icons.design_services_rounded,
                        color: const Color(0xFFB071F9),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              _MetricLine(
                title: 'Taxa de conclusao',
                value:
                    '${(provider.completedBookingsCount / provider.totalBookings * 100).toStringAsFixed(1)}%',
                progress:
                    provider.completedBookingsCount / provider.totalBookings,
              ),
              _MetricLine(
                title: 'Agendamentos pendentes',
                value: '${provider.pendingBookingsCount}',
                progress:
                    provider.pendingBookingsCount / provider.totalBookings,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({
    required this.title,
    required this.value,
    required this.progress,
  });

  final String title;
  final String value;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title)),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress.clamp(0, 1)),
        ],
      ),
    );
  }
}
