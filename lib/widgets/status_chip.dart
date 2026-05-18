import 'package:flutter/material.dart';

import '../models/enums.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final BookingStatus status;

  Color _colorForStatus(BookingStatus value) {
    switch (value) {
      case BookingStatus.pending:
        return const Color(0xFFF6A11A);
      case BookingStatus.confirmed:
        return const Color(0xFF0D7E71);
      case BookingStatus.completed:
        return const Color(0xFF2667FF);
      case BookingStatus.canceled:
        return const Color(0xFFD64545);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForStatus(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
