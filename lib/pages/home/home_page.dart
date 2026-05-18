import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_utils.dart';
import '../../models/enums.dart';
import '../../providers/marketplace_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/professional_card.dart';
import '../../widgets/section_title.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onOpenProfessional});

  final ValueChanged<String> onOpenProfessional;

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketplaceProvider>(
      builder: (context, provider, _) {
        final professionals = provider.filteredProfessionals;
        return RefreshIndicator(
          onRefresh: () async {
            provider.resetFilters();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(18),
            children: [
              TextField(
                onChanged: provider.updateSearchQuery,
                decoration: const InputDecoration(
                  hintText: 'Buscar por nome ou especialidade',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: 'Filtros'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _FilterDropdown<String>(
                          label: 'Cidade',
                          value: provider.selectedCity,
                          items: provider.cityOptions,
                          itemLabel: (item) => item,
                          onChanged: (city) {
                            if (city != null) provider.updateCityFilter(city);
                          },
                        ),
                        _FilterDropdown<ServiceCategory?>(
                          label: 'Categoria',
                          value: provider.selectedCategory,
                          items: provider.categoryOptions,
                          itemLabel: (item) => item?.label ?? 'Todas',
                          onChanged: provider.updateCategoryFilter,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Avaliacao minima: ${provider.selectedMinRating.toStringAsFixed(1)}',
                    ),
                    Slider(
                      value: provider.selectedMinRating,
                      max: 5,
                      divisions: 10,
                      label: provider.selectedMinRating.toStringAsFixed(1),
                      onChanged: provider.updateMinRating,
                    ),
                    Text(
                      'Preco medio maximo: ${CurrencyUtils.format(provider.selectedMaxPrice)}',
                    ),
                    Slider(
                      value: provider.selectedMaxPrice.clamp(
                        0,
                        AppConstants.maxFilterPrice,
                      ),
                      min: 30,
                      max: AppConstants.maxFilterPrice,
                      divisions: 47,
                      onChanged: provider.updateMaxPrice,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: provider.resetFilters,
                        child: const Text('Limpar filtros'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SectionTitle(
                title: 'Profissionais (${professionals.length})',
                actionLabel: 'Resetar',
                onAction: provider.resetFilters,
              ),
              const SizedBox(height: 10),
              if (professionals.isEmpty)
                const EmptyStateWidget(
                  icon: Icons.person_search_rounded,
                  title: 'Nenhum profissional encontrado',
                  message:
                      'Ajuste os filtros ou mude o termo de busca para ver mais resultados.',
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 1180
                        ? 3
                        : constraints.maxWidth > 760
                        ? 2
                        : 1;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: professionals.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: crossAxisCount == 1 ? 2.25 : 1.52,
                      ),
                      itemBuilder: (context, index) {
                        final professional = professionals[index];
                        return ProfessionalCard(
                          professional: professional,
                          rating: provider.averageRatingFor(professional.id),
                          reviewCount: provider.reviewCountFor(professional.id),
                          averagePrice: provider.averagePriceFor(professional.id),
                          isFavorite: provider.isFavorite(professional.id),
                          onTap: () => onOpenProfessional(professional.id),
                          onToggleFavorite: () {
                            provider.toggleFavorite(professional.id);
                          },
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 190, maxWidth: 260),
      child: DropdownButtonFormField<T>(
        key: ValueKey<Object?>(value),
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(itemLabel(item)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
