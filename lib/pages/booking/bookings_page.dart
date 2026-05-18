import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/enums.dart';
import '../../providers/marketplace_provider.dart';
import '../../widgets/booking_tile.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/section_title.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  bool _showHistory = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, _) {
        final list = _showHistory
            ? provider.customerHistory
            : provider.customerUpcomingBookings;
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const SectionTitle(title: 'Meus agendamentos'),
            const SizedBox(height: 10),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(value: false, label: Text('Ativos')),
                ButtonSegment<bool>(value: true, label: Text('Historico')),
              ],
              selected: {_showHistory},
              onSelectionChanged: (values) {
                setState(() => _showHistory = values.first);
              },
            ),
            const SizedBox(height: 14),
            if (list.isEmpty)
              EmptyStateWidget(
                icon: _showHistory
                    ? Icons.history_toggle_off_rounded
                    : Icons.calendar_today_outlined,
                title: _showHistory
                    ? 'Sem historico por enquanto'
                    : 'Sem agendamentos ativos',
                message: _showHistory
                    ? 'Conforme voce concluir agendamentos, eles aparecerao aqui.'
                    : 'Agende um servico na home para visualizar nesta tela.',
              )
            else
              ...list.map(
                (booking) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BookingTile(
                    booking: booking,
                    onCancel: booking.status == BookingStatus.completed ||
                            booking.status == BookingStatus.canceled
                        ? null
                        : () => provider.cancelBooking(booking.id),
                    onConfirm: booking.status == BookingStatus.pending
                        ? () => provider.updateBookingStatus(
                            booking.id,
                            BookingStatus.confirmed,
                          )
                        : null,
                    onComplete: booking.status == BookingStatus.confirmed
                        ? () => provider.updateBookingStatus(
                            booking.id,
                            BookingStatus.completed,
                          )
                        : null,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
