import '../entities/property.dart';
import '../entities/property_filter.dart';

abstract class PropertyRepository {
  Future<List<Property>> getProperties({PropertyFilter? filter});
  Future<Property?> getPropertyById(String id);
  Future<List<Property>> getFeaturedProperties();
  Future<List<Property>> searchProperties(String query);
}
