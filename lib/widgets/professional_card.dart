import 'package:flutter/material.dart';

import '../core/utils/currency_utils.dart';
import '../models/professional.dart';
import 'rating_stars.dart';

class ProfessionalCard extends StatelessWidget {
  const ProfessionalCard({
    super.key,
    required this.professional,
    required this.rating,
    required this.reviewCount,
    required this.averagePrice,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Professional professional;
  final double rating;
  final int reviewCount;
  final double averagePrice;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Colors.white, Color(0xFFF8FCFB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'pro-photo-${professional.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    professional.imageUrl,
                    width: 92,
                    height: 92,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            professional.name,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: onToggleFavorite,
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorite
                                ? const Color(0xFFD64545)
                                : theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
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
                          size: 16,
                          color: Colors.black45,
                        ),
                        const SizedBox(width: 4),
                        Text(professional.city),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        RatingStars(rating: rating, size: 15),
                        const SizedBox(width: 6),
                        Text(
                          '${rating.toStringAsFixed(1)} ($reviewCount)',
                          style: theme.textTheme.labelLarge,
                        ),
                        const Spacer(),
                        Text(
                          CurrencyUtils.format(averagePrice),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
