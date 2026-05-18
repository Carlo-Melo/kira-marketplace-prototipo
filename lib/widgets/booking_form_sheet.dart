import 'package:flutter/material.dart';

import '../core/utils/date_utils.dart';
import '../models/service_item.dart';

typedef BookingFormSubmit = void Function(ServiceItem service, DateTime dateTime);

class BookingFormSheet extends StatefulWidget {
  const BookingFormSheet({
    super.key,
    required this.services,
    required this.onSubmit,
  });

  final List<ServiceItem> services;
  final BookingFormSubmit onSubmit;

  @override
  State<BookingFormSheet> createState() => _BookingFormSheetState();
}

class _BookingFormSheetState extends State<BookingFormSheet> {
  ServiceItem? _selectedService;
  DateTime? _selectedDateTime;

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 120)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 14, minute: 0),
    );
    if (time == null) return;
    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _selectedService != null && _selectedDateTime != null;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Novo agendamento', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          DropdownButtonFormField<ServiceItem>(
            key: ValueKey<String?>(_selectedService?.id),
            initialValue: _selectedService,
            items: widget.services
                .map(
                  (service) => DropdownMenuItem(
                    value: service,
                    child: Text(service.name),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedService = value),
            decoration: const InputDecoration(labelText: 'Servico'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickDateTime,
            icon: const Icon(Icons.event_note_rounded),
            label: Text(
              _selectedDateTime == null
                  ? 'Selecionar data e horario'
                  : DateUtilsKira.formatDateTime(_selectedDateTime!),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: canSubmit
                  ? () {
                      widget.onSubmit(_selectedService!, _selectedDateTime!);
                      Navigator.of(context).pop();
                    }
                  : null,
              child: const Text('Agendar'),
            ),
          ),
        ],
      ),
    );
  }
}
