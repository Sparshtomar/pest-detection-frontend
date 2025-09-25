import 'package:flutter/material.dart';
import 'package:pest_detection/providers/local_provider.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';

class ResultCard extends StatelessWidget {
  final Map<String, dynamic> result;
  final VoidCallback onFindSolutions;

  const ResultCard({
    super.key,
    required this.result,
    required this.onFindSolutions,
  });

  String get className =>
      result['class'].replaceAll('___', ' - ').replaceAll('_', ' ');
  double get confidence => result['confidence'];

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    bool isHealthy = className.toLowerCase().contains('healthy');
    Color statusColor =
        isHealthy ? AppTheme.secondaryColor : Colors.orange.shade800;
    IconData statusIcon = isHealthy ? Icons.check_circle : Icons.warning;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localeProvider.get('symptomAnalysis'),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  className,
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                localeProvider.get('confidence'),
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const Spacer(),
              Text(
                '${(confidence * 100).toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: confidence,
              minHeight: 12,
              backgroundColor: statusColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          if (!isHealthy) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.pest_control, color: Colors.white),
                label: Text(localeProvider.get('identifyPests')),
                onPressed: onFindSolutions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}