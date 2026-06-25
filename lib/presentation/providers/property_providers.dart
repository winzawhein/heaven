import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/property_local_datasource.dart';
import '../../data/repositories/property_repository_impl.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/property_filter.dart';
import '../../domain/repositories/property_repository.dart';

final propertyLocalDataSourceProvider = Provider<PropertyLocalDataSource>((
  ref,
) {
  return PropertyLocalDataSource();
});

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  final dataSource = ref.watch(propertyLocalDataSourceProvider);
  return PropertyRepositoryImpl(dataSource);
});

final propertiesProvider = FutureProvider<List<Property>>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.getProperties();
});

final featuredPropertiesProvider = FutureProvider<List<Property>>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.getFeaturedProperties();
});

final propertyFilterProvider =
    StateNotifierProvider<PropertyFilterNotifier, PropertyFilter>((ref) {
      return PropertyFilterNotifier();
    });

class PropertyFilterNotifier extends StateNotifier<PropertyFilter> {
  PropertyFilterNotifier() : super(const PropertyFilter());

  void setQuery(String query) => state = state.copyWith(query: query);
  void setType(String? type) => state = state.copyWith(type: type);
  void setMinPrice(double? price) => state = state.copyWith(minPrice: price);
  void setMaxPrice(double? price) => state = state.copyWith(maxPrice: price);
  void setMinBedrooms(int? bedrooms) =>
      state = state.copyWith(minBedrooms: bedrooms);
  void setSortBy(String? sortBy) => state = state.copyWith(sortBy: sortBy);
  void reset() => state = const PropertyFilter();
}

final filteredPropertiesProvider = FutureProvider<List<Property>>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  final filter = ref.watch(propertyFilterProvider);
  return repository.getProperties(filter: filter);
});

final searchProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Property>>((ref) {
  final query = ref.watch(searchProvider);
  if (query.isEmpty) return Future.value([]);
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.searchProperties(query);
});

final propertyDetailProvider = FutureProvider.family<Property?, String>((
  ref,
  id,
) {
  final repository = ref.watch(propertyRepositoryProvider);
  return repository.getPropertyById(id);
});

final selectedTabProvider = StateProvider<int>((ref) => 0);
