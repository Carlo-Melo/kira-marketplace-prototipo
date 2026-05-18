import 'package:flutter/material.dart';

import '../core/utils/currency_utils.dart';
import '../core/utils/date_utils.dart';
import '../models/booking.dart';
import '../models/enums.dart';
import 'status_chip.dart';

class BookingTile extends StatelessWidget {
  const BookingTile({
    super.key,
    required this.booking,
    this.onCancel,
    this.onConfirm,
    this.onComplete,
  });

  final Booking booking;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.serviceName,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StatusChip(status: booking.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            booking.professionalName,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.event, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(DateUtilsKira.formatDateTime(booking.dateTime)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            CurrencyUtils.format(booking.price),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (booking.status == BookingStatus.pending ||
              booking.status == BookingStatus.confirmed) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (booking.status == BookingStatus.pending && onConfirm != null)
                  FilledButton.tonal(
                    onPressed: onConfirm,
                    child: const Text('Confirmar'),
                  ),
                if (booking.status == BookingStatus.confirmed &&
                    onComplete != null)
                  FilledButton.tonal(
                    onPressed: onComplete,
                    child: const Text('Concluir'),
                  ),
                if (onCancel != null)
                  OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD64545),
                    ),
                    child: const Text('Cancelar'),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
