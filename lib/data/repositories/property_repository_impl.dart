import '../../domain/entities/property.dart';
import '../../domain/entities/property_filter.dart';
import '../../domain/repositories/property_repository.dart';
import '../datasources/property_local_datasource.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyLocalDataSource _localDataSource;

  PropertyRepositoryImpl(this._localDataSource);

  @override
  Future<List<Property>> getProperties({PropertyFilter? filter}) async {
    final models = await _localDataSource.getProperties();
    var properties = models.map((m) => m.toEntity()).toList();

    if (filter != null) {
      if (filter.type != null) {
        properties = properties.where((p) => p.type == filter.type).toList();
      }
      if (filter.minPrice != null) {
        properties = properties.where((p) => p.price >= filter.minPrice!).toList();
      }
      if (filter.maxPrice != null) {
        properties = properties.where((p) => p.price <= filter.maxPrice!).toList();
      }
      if (filter.minBedrooms != null) {
        properties = properties.where((p) => p.bedrooms >= filter.minBedrooms!).toList();
      }
      if (filter.query != null && filter.query!.isNotEmpty) {
        final query = filter.query!.toLowerCase();
        properties = properties.where((p) =>
            p.title.toLowerCase().contains(query) ||
            p.location.toLowerCase().contains(query)).toList();
      }

      switch (filter.sortBy) {
        case 'price_asc':
          properties.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'price_desc':
          properties.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'newest':
          properties.sort((a, b) => b.listedDate.compareTo(a.listedDate));
          break;
        case 'area':
          properties.sort((a, b) => b.area.compareTo(a.area));
          break;
      }
    }

    return properties;
  }

  @override
  Future<Property?> getPropertyById(String id) async {
    final model = await _localDataSource.getPropertyById(id);
    return model?.toEntity();
  }

  @override
  Future<List<Property>> getFeaturedProperties() async {
    final models = await _localDataSource.getFeaturedProperties();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Property>> searchProperties(String query) async {
    final models = await _localDataSource.searchProperties(query);
    return models.map((m) => m.toEntity()).toList();
  }
}
