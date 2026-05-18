import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/currency_utils.dart';
import '../../models/service_item.dart';
import '../../providers/marketplace_provider.dart';
import '../../widgets/booking_tile.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/section_title.dart';
import '../../widgets/service_form_dialog.dart';
import '../../widgets/service_tile.dart';
import '../../widgets/stat_card.dart';

class ProfessionalDashboardPage extends StatelessWidget {
  const ProfessionalDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, _) {
        final professional = provider.loggedProfessional;
        final services = provider.servicesForProfessional(professional.id);
        final agenda = provider.loggedProfessionalAgenda;
        final reviews = provider.reviewsForProfessional(professional.id);
        final average = provider.averageRatingFor(professional.id);

        Future<void> openServiceDialog({ServiceItem? service}) async {
          await showDialog<void>(
            context: context,
            builder: (context) => ServiceFormDialog(
              initialService: service,
              onSubmit: (name, description, price, durationMinutes) {
                if (service == null) {
                  provider.createService(
                    professionalId: professional.id,
                    name: name,
                    description: description,
                    price: price,
                    durationMinutes: durationMinutes,
                  );
                } else {
                  provider.updateService(
                    service.copyWith(
                      name: name,
                      description: description,
                      price: price,
                      durationMinutes: durationMinutes,
                    ),
                  );
                }
              },
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(professional.imageUrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard profissional',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        professional.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
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
                      title: 'Ganhos simulados',
                      value: CurrencyUtils.format(provider.simulatedEarnings),
                      icon: Icons.payments_rounded,
                      color: const Color(0xFF0D7E71),
                    ),
                    StatCard(
                      title: 'Agendamentos ativos',
                      value: '${agenda.length}',
                      icon: Icons.calendar_month_rounded,
                      color: const Color(0xFF2667FF),
                    ),
                    StatCard(
                      title: 'Servicos',
                      value: '${services.length}',
                      icon: Icons.design_services_rounded,
                      color: const Color(0xFFF28E2B),
                    ),
                    StatCard(
                      title: 'Avaliacao media',
                      value: average == 0 ? '-' : average.toStringAsFixed(1),
                      icon: Icons.star_rounded,
                      color: const Color(0xFFB071F9),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            const SectionTitle(title: 'Agenda'),
            const SizedBox(height: 10),
            if (agenda.isEmpty)
              const EmptyStateWidget(
                icon: Icons.calendar_today_outlined,
                title: 'Sem agenda futura',
                message: 'Novos agendamentos aparecerao aqui.',
              )
            else
              ...agenda.map(
                (booking) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BookingTile(booking: booking),
                ),
              ),
            const SizedBox(height: 18),
            SectionTitle(
              title: 'Servicos',
              actionLabel: 'Novo servico',
              onAction: () => openServiceDialog(),
            ),
            const SizedBox(height: 10),
            if (services.isEmpty)
              EmptyStateWidget(
                icon: Icons.add_box_outlined,
                title: 'Sem servicos cadastrados',
                message: 'Adicione o primeiro servico para comecar.',
                actionLabel: 'Criar servico',
                onAction: () => openServiceDialog(),
              )
            else
              ...services.map(
                (service) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ServiceTile(
                    service: service,
                    trailing: Column(
                      children: [
                        Switch(
                          value: service.isActive,
                          onChanged: (_) => provider.toggleServiceStatus(service.id),
                        ),
                        PopupMenuButton<String>(
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Editar')),
                            PopupMenuItem(value: 'delete', child: Text('Excluir')),
                          ],
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await openServiceDialog(service: service);
                            }
                            if (value == 'delete' && context.mounted) {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Excluir servico'),
                                  content: const Text(
                                    'Tem certeza que deseja remover este servico?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Excluir'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                provider.deleteService(service.id);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 18),
            const SectionTitle(title: 'Avaliacoes recentes'),
            const SizedBox(height: 10),
            if (reviews.isEmpty)
              const EmptyStateWidget(
                icon: Icons.reviews_outlined,
                title: 'Sem avaliacoes',
                message: 'Quando clientes avaliarem, os comentarios aparecerao aqui.',
              )
            else
              ...reviews.take(4).map(
                (review) => Container(
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
                          Expanded(child: Text(review.userName)),
                          RatingStars(rating: review.rating, size: 14),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(review.comment),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
