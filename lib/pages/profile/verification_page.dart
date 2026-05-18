import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/enums.dart';
import '../../providers/marketplace_provider.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool _isLoading = false;

  Color _statusColor(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.approved:
        return const Color(0xFF0D7E71);
      case VerificationStatus.pending:
        return const Color(0xFFF6A11A);
      case VerificationStatus.rejected:
        return const Color(0xFFD64545);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, _) {
        final request = provider.verificationRequest;
        final statusColor = _statusColor(request.status);
        final canSubmit = request.documentUploaded &&
            request.selfieCaptured &&
            !_isLoading;
        return Scaffold(
          appBar: AppBar(title: const Text('Verificacao facial (demo)')),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fluxo simulado para demonstracao de KYC',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sem integracao com AWS. Status gerado localmente para fins de prototipo.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _ActionCard(
                title: '1. Upload de documento',
                subtitle: request.documentUploaded
                    ? 'Documento enviado com sucesso.'
                    : 'Simular upload de RG ou CNH.',
                isDone: request.documentUploaded,
                icon: Icons.badge_outlined,
                onPressed: request.documentUploaded
                    ? null
                    : () {
                        provider.uploadDocument();
                      },
              ),
              const SizedBox(height: 10),
              _ActionCard(
                title: '2. Captura de selfie',
                subtitle: request.selfieCaptured
                    ? 'Selfie capturada com sucesso.'
                    : 'Simular captura facial no app.',
                isDone: request.selfieCaptured,
                icon: Icons.camera_front_outlined,
                onPressed: request.selfieCaptured
                    ? null
                    : () {
                        provider.captureSelfie();
                      },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: canSubmit
                      ? () async {
                          setState(() => _isLoading = true);
                          await provider.submitVerification();
                          if (!mounted) return;
                          setState(() => _isLoading = false);
                        }
                      : null,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.verified_user_rounded),
                  label: Text(_isLoading ? 'Processando...' : 'Enviar para analise'),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: statusColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Status atual: ${request.status.label}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  provider.resetVerificationFlow();
                },
                child: const Text('Reiniciar fluxo'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.isDone,
    required this.icon,
    this.onPressed,
  });

  final String title;
  final String subtitle;
  final bool isDone;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
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
              Icon(icon, color: const Color(0xFF0D7E71)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.titleMedium),
              ),
              if (isDone)
                const Icon(Icons.check_circle_rounded, color: Color(0xFF0D7E71)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: onPressed,
            child: Text(isDone ? 'Concluido' : 'Executar'),
          ),
        ],
      ),
    );
  }
}
