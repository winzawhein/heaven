class BrokerListingInput {
  final String title;
  final String description;
  final num price;
  final num area;
  final num bedrooms;
  final num bathrooms;
  final String location;
  final num yearBuilt;
  final String? listedDate; // YYYY-MM-DD (optional)

  final String type; // sale | rent
  final String status; // available | pending | sold
  final bool isFurnished;

  final List<String> amenities;
  final List<String> imageUrls;

  const BrokerListingInput({
    required this.title,
    required this.description,
    required this.price,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.location,
    required this.yearBuilt,
    required this.listedDate,
    required this.type,
    required this.status,
    required this.isFurnished,
    required this.amenities,
    required this.imageUrls,
  });
}

