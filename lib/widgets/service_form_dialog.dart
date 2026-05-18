import 'package:flutter/material.dart';

import '../models/service_item.dart';

typedef ServiceFormSubmit =
    void Function(
      String name,
      String description,
      double price,
      int durationMinutes,
    );

class ServiceFormDialog extends StatefulWidget {
  const ServiceFormDialog({
    super.key,
    this.initialService,
    required this.onSubmit,
  });

  final ServiceItem? initialService;
  final ServiceFormSubmit onSubmit;

  @override
  State<ServiceFormDialog> createState() => _ServiceFormDialogState();
}

class _ServiceFormDialogState extends State<ServiceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialService;
    _nameController = TextEditingController(text: initial?.name);
    _descriptionController = TextEditingController(text: initial?.description);
    _priceController = TextEditingController(
      text: initial != null ? initial.price.toStringAsFixed(2) : '',
    );
    _durationController = TextEditingController(
      text: initial?.durationMinutes.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialService != null;
    return AlertDialog(
      title: Text(isEdit ? 'Editar servico' : 'Novo servico'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Descricao'),
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                    ? 'Informe a descricao'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Preco'),
                validator: (value) {
                  final parsed = double.tryParse((value ?? '').replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) return 'Preco invalido';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Duracao (min)'),
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) return 'Duracao invalida';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            widget.onSubmit(
              _nameController.text.trim(),
              _descriptionController.text.trim(),
              double.parse(_priceController.text.replaceAll(',', '.')),
              int.parse(_durationController.text),
            );
            Navigator.of(context).pop();
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
