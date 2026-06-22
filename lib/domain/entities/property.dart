class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String type; // 'sale' or 'rent'
  final int bedrooms;
  final int bathrooms;
  final double area;
  final List<String> images;
  final String location;
  final double latitude;
  final double longitude;
  final String brokerName;
  final String brokerPhone;
  final String brokerPhoto;
  final List<String> amenities;
  final bool isFurnished;
  final int yearBuilt;
  final String listedDate;
  final String status; // 'available', 'pending', 'sold'

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.images,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.brokerName,
    required this.brokerPhone,
    required this.brokerPhoto,
    required this.amenities,
    required this.isFurnished,
    required this.yearBuilt,
    required this.listedDate,
    required this.status,
  });

  Property copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? type,
    int? bedrooms,
    int? bathrooms,
    double? area,
    List<String>? images,
    String? location,
    double? latitude,
    double? longitude,
    String? brokerName,
    String? brokerPhone,
    String? brokerPhoto,
    List<String>? amenities,
    bool? isFurnished,
    int? yearBuilt,
    String? listedDate,
    String? status,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      type: type ?? this.type,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      area: area ?? this.area,
      images: images ?? this.images,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      brokerName: brokerName ?? this.brokerName,
      brokerPhone: brokerPhone ?? this.brokerPhone,
      brokerPhoto: brokerPhoto ?? this.brokerPhoto,
      amenities: amenities ?? this.amenities,
      isFurnished: isFurnished ?? this.isFurnished,
      yearBuilt: yearBuilt ?? this.yearBuilt,
      listedDate: listedDate ?? this.listedDate,
      status: status ?? this.status,
    );
  }
}
