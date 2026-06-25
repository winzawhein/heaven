import '../models/property_model.dart';

class PropertyLocalDataSource {
  List<PropertyModel> _generateMockProperties() {
    return [
      PropertyModel(
        id: '1',
        title: 'Luxury Waterfront Apartment',
        description:
            'Stunning waterfront apartment with panoramic ocean views. Floor-to-ceiling windows, modern finishes, and a private balcony overlooking the marina. State-of-the-art kitchen with premium appliances.',
        price: 2500000,
        type: 'sale',
        bedrooms: 3,
        bathrooms: 2,
        area: 1800,
        images: [
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        ],
        location: 'Marina Bay, San Francisco',
        latitude: 37.7749,
        longitude: -122.4194,
        brokerName: 'Sarah Johnson',
        brokerPhone: '+14155550101',
        brokerPhoto: 'https://randomuser.me/api/portraits/women/44.jpg',
        amenities: [
          'Swimming Pool',
          'Gym',
          'Parking',
          'Security',
          'Garden',
          'Elevator',
          'AC',
        ],
        isFurnished: true,
        yearBuilt: 2022,
        listedDate: '2024-01-15',
        status: 'available',
      ),
      PropertyModel(
        id: '2',
        title: 'Modern Downtown Condo',
        description:
            'Sleek modern condo in the heart of downtown. Walking distance to restaurants, shops, and public transit. Open concept layout with premium hardwood floors and city views.',
        price: 4500,
        type: 'rent',
        bedrooms: 2,
        bathrooms: 1,
        area: 950,
        images: [
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
          'https://images.unsplash.com/photo-1560185893-a55cbc8c57e8?w=800',
        ],
        location: 'Downtown, New York',
        latitude: 40.7128,
        longitude: -74.0060,
        brokerName: 'Michael Chen',
        brokerPhone: '+12125550202',
        brokerPhoto: 'https://randomuser.me/api/portraits/men/32.jpg',
        amenities: ['Gym', 'Parking', 'Security', 'Elevator', 'Laundry'],
        isFurnished: false,
        yearBuilt: 2020,
        listedDate: '2024-02-01',
        status: 'available',
      ),
      PropertyModel(
        id: '3',
        title: 'Elegant Penthouse Suite',
        description:
            'Exquisite penthouse with panoramic skyline views. Private rooftop terrace, gourmet kitchen, spa-like bathrooms, and custom Italian marble finishes throughout.',
        price: 5200000,
        type: 'sale',
        bedrooms: 4,
        bathrooms: 3,
        area: 3200,
        images: [
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
          'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
        ],
        location: 'Beverly Hills, Los Angeles',
        latitude: 34.0736,
        longitude: -118.4004,
        brokerName: 'Emily Davis',
        brokerPhone: '+13105550303',
        brokerPhoto: 'https://randomuser.me/api/portraits/women/68.jpg',
        amenities: [
          'Swimming Pool',
          'Gym',
          'Parking',
          'Security',
          'Garden',
          'Elevator',
          'AC',
          'Storage',
        ],
        isFurnished: true,
        yearBuilt: 2023,
        listedDate: '2024-01-20',
        status: 'available',
      ),
      PropertyModel(
        id: '4',
        title: 'Cozy Studio Apartment',
        description:
            'Charming studio in a quiet neighborhood. Recently renovated with modern fixtures, granite countertops, and hardwood floors. Perfect for young professionals.',
        price: 1800,
        type: 'rent',
        bedrooms: 1,
        bathrooms: 1,
        area: 500,
        images: [
          'https://images.unsplash.com/photo-1536376072261-38c75010e6c9?w=800',
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
          'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
        ],
        location: 'Greenwich Village, New York',
        latitude: 40.7336,
        longitude: -73.9940,
        brokerName: 'Alex Rivera',
        brokerPhone: '+12125550404',
        brokerPhoto: 'https://randomuser.me/api/portraits/men/75.jpg',
        amenities: ['Laundry', 'Storage', 'Elevator'],
        isFurnished: true,
        yearBuilt: 2019,
        listedDate: '2024-02-10',
        status: 'available',
      ),
      PropertyModel(
        id: '5',
        title: 'Beachfront Villa',
        description:
            'Breathtaking beachfront villa with private access to white sand beach. Infinity pool, tropical garden, outdoor kitchen, and floor-to-ceiling glass walls.',
        price: 7800000,
        type: 'sale',
        bedrooms: 5,
        bathrooms: 4,
        area: 4500,
        images: [
          'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=800',
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
          'https://images.unsplash.com/photo-1600585154526-990dced4db0d?w=800',
        ],
        location: 'Malibu, California',
        latitude: 34.0259,
        longitude: -118.7798,
        brokerName: 'Jessica Williams',
        brokerPhone: '+13105550505',
        brokerPhoto: 'https://randomuser.me/api/portraits/women/26.jpg',
        amenities: [
          'Swimming Pool',
          'Gym',
          'Parking',
          'Security',
          'Garden',
          'AC',
          'Heating',
        ],
        isFurnished: true,
        yearBuilt: 2021,
        listedDate: '2024-01-05',
        status: 'available',
      ),
      PropertyModel(
        id: '6',
        title: 'Urban Loft Space',
        description:
            'Industrial-chic loft with exposed brick walls, soaring ceilings, and oversized windows. Located in the vibrant arts district with galleries and cafes steps away.',
        price: 3200,
        type: 'rent',
        bedrooms: 1,
        bathrooms: 1,
        area: 850,
        images: [
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        ],
        location: 'Arts District, Los Angeles',
        latitude: 34.0419,
        longitude: -118.2355,
        brokerName: 'David Kim',
        brokerPhone: '+13105550606',
        brokerPhoto: 'https://randomuser.me/api/portraits/men/46.jpg',
        amenities: ['Parking', 'Laundry', 'Storage'],
        isFurnished: false,
        yearBuilt: 2018,
        listedDate: '2024-02-15',
        status: 'available',
      ),
    ];
  }

  Future<List<PropertyModel>> getProperties() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _generateMockProperties();
  }

  Future<PropertyModel?> getPropertyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _generateMockProperties().firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<PropertyModel>> getFeaturedProperties() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _generateMockProperties().take(3).toList();
  }

  Future<List<PropertyModel>> searchProperties(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _generateMockProperties()
        .where(
          (p) =>
              p.title.toLowerCase().contains(lowerQuery) ||
              p.location.toLowerCase().contains(lowerQuery) ||
              p.description.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }
}
