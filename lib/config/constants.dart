import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/plant_model.dart';

// --- App Configuration ---
const String serverUrl = "http://10.229.231.2:8000";
final String OPENAI_API_KEY = dotenv.env['OPENAI_API_KEY'] ?? 'API_KEY_NOT_FOUND';
final String GEMINI_API_KEY = dotenv.env['GEMINI_API_KEY'] ?? 'GEMINI_KEY_NOT_FOUND';

// --- App Data ---
final List<Plant> plants = [
  Plant(nameKey: "plant_tomato", modelId: "model1", icon: Icons.spa),
  Plant(nameKey: "plant_potato", modelId: "model2", icon: Icons.eco),
  Plant(nameKey: "plant_grape", modelId: "model3", icon: Icons.grass),
  Plant(nameKey: "plant_corn", modelId: "model4", icon: Icons.grain),
  Plant(nameKey: "plant_wheat", modelId: "model5", icon: Icons.bakery_dining),
  Plant(nameKey: "plant_sugarcane", modelId: "model6", icon: Icons.waves),
];