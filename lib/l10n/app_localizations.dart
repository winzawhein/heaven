import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('my'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get appTitle => 'Heaven';

  // Home
  String get brokerPortal => _t('brokerPortal');
  String get searchResults => _t('searchResults');
  String get featured => _t('featured');
  String get seeAll => _t('seeAll');
  String get categories => _t('categories');
  String get recentListings => _t('recentListings');
  String noPropertiesFound(String query) => _t('noPropertiesFound', {'query': query});

  String get findYour => _t('findYour');
  String get perfectHome => _t('perfectHome');

  String get hintSearchByLocation => _t('hintSearchByLocation');
  String get hintSearchByProperty => _t('hintSearchByProperty');
  String get hintSearchByVilla => _t('hintSearchByVilla');

  // Categories
  String get categoryApartment => _t('categoryApartment');
  String get categoryForSale => _t('categoryForSale');
  String get categoryForRent => _t('categoryForRent');
  String get categoryVilla => _t('categoryVilla');

  // Status
  String get statusAvailable => _t('statusAvailable');
  String get statusSale => _t('statusSale');
  String get statusRent => _t('statusRent');

  String _t(String key, [Map<String, String>? vars]) {
    final en = <String, String>{
      'brokerPortal': 'Broker Portal',
      'searchResults': 'Search Results',
      'featured': 'Featured',
      'seeAll': 'See All',
      'categories': 'Categories',
      'recentListings': 'Recent Listings',
      'noPropertiesFound': 'No properties found for "{query}"',
      'findYour': 'Find Your',
      'perfectHome': 'Perfect Home',
      'hintSearchByLocation': 'Search by location...',
      'hintSearchByProperty': 'Search by property...',
      'hintSearchByVilla': 'Search by villa...',
      'categoryApartment': 'Apartment',
      'categoryForSale': 'For Sale',
      'categoryForRent': 'For Rent',
      'categoryVilla': 'Villa',
      'statusAvailable': 'Available',
      'statusSale': 'For Sale',
      'statusRent': 'For Rent',
    };

    final my = <String, String>{
      'brokerPortal': 'ဘရိုကာ ပေါ်တယ်',
      'searchResults': 'ရှာဖွေမှု ရလဒ်များ',
      'featured': 'အထူးရွေးချယ်မှု',
      'seeAll': 'အားလုံး ကြည့်ရန်',
      'categories': 'အမျိုးအစားများ',
      'recentListings': 'မကြာသေးမီ အိမ်ရာစာရင်းများ',
      'noPropertiesFound': '"{query}" အတွက် အိမ်ရာများ မတွေ့ပါ။',
      'findYour': 'သင့်အိမ်ကိုရှာပါ',
      'perfectHome': 'ပြီးပြည့်စုံတဲ့ နေအိမ်',
      'hintSearchByLocation': 'နေရာအားဖြင့် ရှာဖွေပါ...',
      'hintSearchByProperty': 'အိမ်ရာအမျိုးအစားအားဖြင့် ရှာဖွေပါ...',
      'hintSearchByVilla': 'ဗီလာဖြင့် ရှာဖွေပါ...',
      'categoryApartment': 'တိုက်ခန်း',
      'categoryForSale': 'ရောင်းရန်',
      'categoryForRent': 'ငှားရန်',
      'categoryVilla': 'ဗီလာ',
      'statusAvailable': 'ရရှိနိုင်',
      'statusSale': 'ရောင်းရန်',
      'statusRent': 'ငှားရန်',
    };

    final map = locale.languageCode == 'my' ? my : en;
    var value = map[key] ?? key;

    if (vars != null) {
      vars.forEach((k, v) {
        value = value.replaceAll('{$k}', v);
      });
    }

    return value;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'my'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

