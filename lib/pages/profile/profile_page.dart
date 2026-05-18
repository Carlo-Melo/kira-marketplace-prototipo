import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/date_utils.dart';
import '../../models/enums.dart';
import '../../providers/marketplace_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/section_title.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.onOpenVerification});

  final VoidCallback onOpenVerification;

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, _) {
        final user = provider.currentUser;
        final favorites = provider.favoriteProfessionals;
        final history = provider.customerHistory;
        final verification = provider.verificationRequest;
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(user.email),
                        Text(user.phone),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7F5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_outlined, size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Verificacao facial: ${verification.status.label}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: onOpenVerification,
                    child: const Text('Abrir'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const SectionTitle(title: 'Favoritos'),
            const SizedBox(height: 10),
            if (favorites.isEmpty)
              const EmptyStateWidget(
                icon: Icons.favorite_border_rounded,
                title: 'Nenhum favorito ainda',
                message: 'Marque profissionais na home para salvar aqui.',
              )
            else
              ...favorites.map(
                (professional) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(professional.imageUrl),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              professional.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(professional.specialty),
                          ],
                        ),
                      ),
                      RatingStars(
                        rating: provider.averageRatingFor(professional.id),
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 18),
            const SectionTitle(title: 'Historico'),
            const SizedBox(height: 10),
            if (history.isEmpty)
              const EmptyStateWidget(
                icon: Icons.history_outlined,
                title: 'Sem historico',
                message: 'Seus agendamentos concluidos aparecerao aqui.',
              )
            else
              ...history.map(
                (booking) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.serviceName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(booking.professionalName),
                      const SizedBox(height: 4),
                      Text(DateUtilsKira.formatDateTime(booking.dateTime)),
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
