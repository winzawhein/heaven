class AppConstants {
  AppConstants._();

  static const String appName = 'Heaven';
  static const String appTagline = 'Find Your Perfect Home';
  
  static const double glassOpacity = 0.15;
  static const double glassBlur = 20.0;
  static const double borderRadius = 20.0;
  static const double cardBorderRadius = 16.0;
  static const double smallBorderRadius = 12.0;
  
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  static const String phonePlaceholder = '+95 ';

  static const List<String> propertyTypes = ['Apartment', 'House', 'Condo', 'Villa', 'Studio'];
  static const List<String> furnishings = ['Fully Furnished', 'Semi Furnished', 'Unfurnished'];
  static const List<String> amenities = [
    'Swimming Pool', 'Gym', 'Parking', 'Security', 'Garden',
    'Elevator', 'AC', 'Heating', 'Laundry', 'Storage'
  ];
}
