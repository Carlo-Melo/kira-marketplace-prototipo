import 'package:flutter/material.dart';

typedef ReviewFormSubmit = void Function(double rating, String comment);

class ReviewFormDialog extends StatefulWidget {
  const ReviewFormDialog({super.key, required this.onSubmit});

  final ReviewFormSubmit onSubmit;

  @override
  State<ReviewFormDialog> createState() => _ReviewFormDialogState();
}

class _ReviewFormDialogState extends State<ReviewFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  double _rating = 5;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova avaliacao'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nota: ${_rating.toStringAsFixed(1)}'),
            Slider(
              min: 1,
              max: 5,
              divisions: 8,
              value: _rating,
              label: _rating.toStringAsFixed(1),
              onChanged: (value) => setState(() => _rating = value),
            ),
            TextFormField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Comentario'),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Escreva um comentario' : null,
            ),
          ],
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
            widget.onSubmit(_rating, _commentController.text.trim());
            Navigator.of(context).pop();
          },
          child: const Text('Enviar'),
        ),
      ],
    );
  }
}
