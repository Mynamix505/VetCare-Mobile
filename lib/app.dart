import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/pet_repository.dart';
import 'presentation/screens/pets/pets_screen.dart';
import 'presentation/state/pets_notifier.dart';

class VetCareApp extends StatelessWidget {
  const VetCareApp({super.key, required this.repository, required this.isDemo});

  final PetRepository repository;
  final bool isDemo;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => PetsNotifier(repository)..load(),
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) => MaterialApp(
            title: 'VetCare Mobile',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(),
            locale: const Locale('ru'),
            supportedLocales: const [Locale('ru')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: child,
          ),
          child: PetsScreen(isDemo: isDemo),
        ),
      );
}
