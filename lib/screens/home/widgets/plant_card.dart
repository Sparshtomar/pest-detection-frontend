import 'package:flutter/material.dart';
import 'package:pest_detection/providers/local_provider.dart';
import 'package:pest_detection/screens/prediction/prediction_screen.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../models/plant_model.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  const PlantCard({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PredictionScreen(plant: plant)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
              child: Icon(plant.icon, size: 40, color: AppTheme.secondaryColor),
            ),
            const SizedBox(height: 15),
            Text(
              localeProvider.get(plant.nameKey),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}