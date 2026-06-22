class PropertyFilter {
  final String? query;
  final String? type; // 'sale', 'rent', or null for all
  final double? minPrice;
  final double? maxPrice;
  final int? minBedrooms;
  final int? maxBedrooms;
  final List<String> amenities;
  final String? sortBy; // 'price_asc', 'price_desc', 'newest', 'area'

  const PropertyFilter({
    this.query,
    this.type,
    this.minPrice,
    this.maxPrice,
    this.minBedrooms,
    this.maxBedrooms,
    this.amenities = const [],
    this.sortBy,
  });

  PropertyFilter copyWith({
    String? query,
    String? type,
    double? minPrice,
    double? maxPrice,
    int? minBedrooms,
    int? maxBedrooms,
    List<String>? amenities,
    String? sortBy,
  }) {
    return PropertyFilter(
      query: query ?? this.query,
      type: type ?? this.type,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minBedrooms: minBedrooms ?? this.minBedrooms,
      maxBedrooms: maxBedrooms ?? this.maxBedrooms,
      amenities: amenities ?? this.amenities,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters =>
      query != null ||
      type != null ||
      minPrice != null ||
      maxPrice != null ||
      minBedrooms != null ||
      maxBedrooms != null ||
      amenities.isNotEmpty;
}
