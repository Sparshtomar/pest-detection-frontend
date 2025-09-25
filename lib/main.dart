import 'package:flutter/material.dart';
import 'package:pest_detection/providers/local_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: const PlantDoctorApp(),
    ),
  );
}