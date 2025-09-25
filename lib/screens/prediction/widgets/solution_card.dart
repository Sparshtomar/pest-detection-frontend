import 'package:flutter/material.dart';
import 'package:pest_detection/providers/local_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';

class SolutionCard extends StatelessWidget {
  final List<String> solutionPoints;
  const SolutionCard({super.key, required this.solutionPoints});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localeProvider.get('pestActionPlan'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          ...solutionPoints.map((point) {
            final parts = point.split(':');
            final title = parts.length > 1 ? '${parts[0]}:' : '';
            final description =
                parts.length > 1 ? parts.sublist(1).join(':').trim() : point;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 22,
                    color: AppTheme.secondaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                          fontFamily: 'Poppins',
                        ),
                        children: [
                          TextSpan(
                            text: title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' $description'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}