import 'package:flutter/material.dart';

import '../core/utils/currency_utils.dart';
import '../models/service_item.dart';

class ServiceTile extends StatelessWidget {
  const ServiceTile({
    super.key,
    required this.service,
    this.trailing,
    this.onTap,
  });

  final ServiceItem service;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: service.isActive ? Colors.white : const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    service.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        CurrencyUtils.format(service.price),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.schedule_rounded, size: 14),
                      const SizedBox(width: 4),
                      Text('${service.durationMinutes} min'),
                    ],
                  ),
                ],
              ),
            ),
            ...(trailing == null ? const <Widget>[] : <Widget>[trailing!]),
          ],
        ),
      ),
    );
  }
}
