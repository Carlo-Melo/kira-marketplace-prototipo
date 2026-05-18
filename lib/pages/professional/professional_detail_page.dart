import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/date_utils.dart';
import '../../providers/marketplace_provider.dart';
import '../../widgets/booking_form_sheet.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/review_form_dialog.dart';
import '../../widgets/section_title.dart';
import '../../widgets/service_tile.dart';

class ProfessionalDetailPage extends StatelessWidget {
  const ProfessionalDetailPage({super.key, required this.professionalId});

  final String professionalId;

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, _) {
        final professional = provider.professionalById(professionalId);
        if (professional == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profissional')),
            body: const Padding(
              padding: EdgeInsets.all(18),
              child: EmptyStateWidget(
                icon: Icons.person_off_rounded,
                title: 'Profissional nao encontrado',
                message: 'Volte para a home e selecione outro profissional.',
              ),
            ),
          );
        }
        final services = provider.activeServicesForProfessional(professional.id);
        final reviews = provider.reviewsForProfessional(professional.id);
        final averageRating = provider.averageRatingFor(professional.id);
        final reviewCount = provider.reviewCountFor(professional.id);
        final theme = Theme.of(context);

        Future<void> openBooking() async {
          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return BookingFormSheet(
                services: services,
                onSubmit: (service, dateTime) {
                  provider.createBooking(
                    professional: professional,
                    service: service,
                    dateTime: dateTime,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Agendamento criado para ${DateUtilsKira.formatDateTime(dateTime)}',
                      ),
                    ),
                  );
                },
              );
            },
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil profissional'),
            actions: [
              IconButton(
                onPressed: () => provider.toggleFavorite(professional.id),
                icon: Icon(
                  provider.isFavorite(professional.id)
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  color: const Color(0xFFD64545),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'pro-photo-${professional.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.network(
                              professional.imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                professional.name,
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                professional.specialty,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 15,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(professional.city),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  RatingStars(rating: averageRating),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${averageRating.toStringAsFixed(1)} ($reviewCount)',
                                    style: theme.textTheme.labelLarge,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      professional.bio,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: services.isEmpty ? null : openBooking,
                            icon: const Icon(Icons.calendar_month_rounded),
                            label: const Text('Agendar'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await showDialog<void>(
                              context: context,
                              builder: (context) => ReviewFormDialog(
                                onSubmit: (rating, comment) {
                                  provider.addReview(
                                    professionalId: professional.id,
                                    rating: rating,
                                    comment: comment,
                                  );
                                },
                              ),
                            );
                          },
                          icon: const Icon(Icons.reviews_rounded),
                          label: const Text('Avaliar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const SectionTitle(title: 'Servicos oferecidos'),
              const SizedBox(height: 10),
              if (services.isEmpty)
                const EmptyStateWidget(
                  icon: Icons.design_services_outlined,
                  title: 'Sem servicos ativos',
                  message: 'Este profissional ainda nao publicou servicos ativos.',
                )
              else
                ...services.map(
                  (service) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ServiceTile(service: service),
                  ),
                ),
              const SizedBox(height: 12),
              const SectionTitle(title: 'Avaliacoes'),
              const SizedBox(height: 10),
              if (reviews.isEmpty)
                const EmptyStateWidget(
                  icon: Icons.rate_review_outlined,
                  title: 'Sem avaliacoes no momento',
                  message: 'As avaliacoes dos clientes vao aparecer aqui.',
                )
              else
                ...reviews.map(
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
                            Expanded(
                              child: Text(
                                review.userName,
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                            RatingStars(rating: review.rating, size: 14),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(review.comment),
                        const SizedBox(height: 6),
                        Text(
                          DateUtilsKira.formatDate(review.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
