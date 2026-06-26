// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'core/firebase/firebase_initializer.dart';
// import 'core/theme/app_theme.dart';
// import 'l10n/app_localizations.dart';
// import 'presentation/home/home_page.dart';
// import 'presentation/providers/locale_provider.dart';



// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await initFirebase();

//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ),
//   );

//   runApp(const ProviderScope(child: HeavenApp()));
// }

// class HeavenApp extends ConsumerWidget {
//   const HeavenApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentLocale = ref.watch(localeProvider);
//     return MaterialApp(
//       title: 'Heaven',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.darkTheme,
//       locale: currentLocale,
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//       ],
//       supportedLocales: AppLocalizations.supportedLocales,
//       home: const HomePage(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 1. ADD THIS IMPORT
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/firebase/firebase_initializer.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/home/home_page.dart';
import 'presentation/providers/locale_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: HeavenApp()));
}

class HeavenApp extends ConsumerWidget {
  const HeavenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: 'Heaven',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate, // Your custom translation delegate
        
        // 2. ADD THESE THREE GLOBAL SYSTEM DELEGATES:
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}