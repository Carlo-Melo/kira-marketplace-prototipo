import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_routes.dart';
import '../../providers/app_provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _index = 0;

  static const _items = <_OnboardingItem>[
    _OnboardingItem(
      title: 'Encontre profissionais em segundos',
      message:
          'Busque por cidade, categoria e avaliacao para descobrir os melhores servicos de estetica perto de voce.',
      icon: Icons.search_rounded,
    ),
    _OnboardingItem(
      title: 'Agende com seguranca',
      message:
          'Compare valores, veja comentarios reais e monte sua rotina de beleza com poucos toques.',
      icon: Icons.event_available_rounded,
    ),
    _OnboardingItem(
      title: 'Profissionais crescem no Kira',
      message:
          'Gerencie servicos, agenda, ganhos e verificacao facial em uma experiencia simples e moderna.',
      icon: Icons.trending_up_rounded,
    ),
  ];

  Future<void> _finishOnboarding() async {
    await context.read<AppProvider>().completeOnboarding();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.shell);
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _items.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text('Pular'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _items.length,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE8F7F4), Color(0xFFFDFBF3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF0D7E71,
                              ).withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Icon(
                              item.icon,
                              size: 40,
                              color: const Color(0xFF0D7E71),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            item.message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(_items.length, (index) {
                  final active = _index == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 26 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFF0D7E71) : Colors.black26,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    if (isLast) {
                      await _finishOnboarding();
                      return;
                    }
                    await _pageController.nextPage(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Text(isLast ? 'Comecar' : 'Continuar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.title,
    required this.message,
    required this.icon,
  });

  final String title;
  final String message;
  final IconData icon;
}
