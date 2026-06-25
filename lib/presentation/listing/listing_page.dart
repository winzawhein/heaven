import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/property_filter.dart';
import '../providers/property_providers.dart';
import '../widgets/property_card.dart';
import '../widgets/glass_container.dart';
import '../detail/detail_page.dart';

class ListingPage extends ConsumerWidget {
  const ListingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(propertyFilterProvider);
    final propertiesAsync = ref.watch(filteredPropertiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFilterSheet(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          if (filter.hasActiveFilters)
            _buildActiveFilters(context, ref, filter),
          Expanded(
            child: propertiesAsync.when(
              data: (properties) {
                if (properties.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.home_work_outlined,
                          size: 64,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No properties match your filters',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () =>
                              ref.read(propertyFilterProvider.notifier).reset(),
                          child: const Text('Clear Filters'),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: properties.length,
                  itemBuilder: (_, index) => PropertyCard(
                    property: properties[index],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailPage(propertyId: properties[index].id),
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Failed to load properties')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters(
    BuildContext context,
    WidgetRef ref,
    PropertyFilter filter,
  ) {
    return GlassContainer(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          const Icon(Icons.filter_alt, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _filterDescription(filter),
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () => ref.read(propertyFilterProvider.notifier).reset(),
            child: const Text('Clear', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  String _filterDescription(PropertyFilter filter) {
    final parts = <String>[];
    if (filter.type != null)
      parts.add(filter.type == 'sale' ? 'For Sale' : 'For Rent');
    if (filter.minBedrooms != null) parts.add('${filter.minBedrooms}+ Beds');
    if (filter.minPrice != null) parts.add('\$${filter.minPrice! ~/ 1000}K+');
    if (filter.maxPrice != null)
      parts.add('Up to \$${filter.maxPrice! ~/ 1000}K');
    return parts.isNotEmpty ? parts.join(' · ') : 'Filters active';
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    final filter = ref.read(propertyFilterProvider);
    String? selectedType = filter.type;
    int? selectedBedrooms = filter.minBedrooms;
    String? selectedSort = filter.sortBy;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppTheme.textSecondary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildFilterSection('Type', [
                      _buildFilterChip('All', selectedType == null, () {
                        setSheetState(() => selectedType = null);
                      }),
                      _buildFilterChip('For Sale', selectedType == 'sale', () {
                        setSheetState(() => selectedType = 'sale');
                      }),
                      _buildFilterChip('For Rent', selectedType == 'rent', () {
                        setSheetState(() => selectedType = 'rent');
                      }),
                    ]),
                    const SizedBox(height: 20),
                    _buildFilterSection('Bedrooms', [
                      _buildFilterChip('Any', selectedBedrooms == null, () {
                        setSheetState(() => selectedBedrooms = null);
                      }),
                      _buildFilterChip('1+', selectedBedrooms == 1, () {
                        setSheetState(() => selectedBedrooms = 1);
                      }),
                      _buildFilterChip('2+', selectedBedrooms == 2, () {
                        setSheetState(() => selectedBedrooms = 2);
                      }),
                      _buildFilterChip('3+', selectedBedrooms == 3, () {
                        setSheetState(() => selectedBedrooms = 3);
                      }),
                      _buildFilterChip('4+', selectedBedrooms == 4, () {
                        setSheetState(() => selectedBedrooms = 4);
                      }),
                    ]),
                    const SizedBox(height: 20),
                    _buildFilterSection('Sort By', [
                      _buildFilterChip('Default', selectedSort == null, () {
                        setSheetState(() => selectedSort = null);
                      }),
                      _buildFilterChip(
                        'Price: Low',
                        selectedSort == 'price_asc',
                        () {
                          setSheetState(() => selectedSort = 'price_asc');
                        },
                      ),
                      _buildFilterChip(
                        'Price: High',
                        selectedSort == 'price_desc',
                        () {
                          setSheetState(() => selectedSort = 'price_desc');
                        },
                      ),
                      _buildFilterChip('Newest', selectedSort == 'newest', () {
                        setSheetState(() => selectedSort = 'newest');
                      }),
                    ]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final notifier = ref.read(
                        propertyFilterProvider.notifier,
                      );
                      notifier.setType(selectedType);
                      notifier.setMinBedrooms(selectedBedrooms);
                      notifier.setSortBy(selectedSort);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<Widget> chips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: chips),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.glassBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
