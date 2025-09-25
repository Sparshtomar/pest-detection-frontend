import 'package:flutter/material.dart';
import 'package:pest_detection/providers/local_provider.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'screens/home/home_screen.dart';

class PlantDoctorApp extends StatelessWidget {
  const PlantDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
      title: 'Kisaan Mitra',
      theme: AppTheme.theme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
    );
  }
}