import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pest_detection/config/theme.dart';
import 'package:pest_detection/models/plant_model.dart';
import 'package:pest_detection/providers/local_provider.dart';
import 'package:pest_detection/services/ai_service.dart';
import 'package:pest_detection/services/gemini_ai_service.dart';
import 'package:pest_detection/services/prediction_service.dart';
import 'package:provider/provider.dart';
import 'widgets/result_card.dart';
import 'widgets/solution_card.dart';

class PredictionScreen extends StatefulWidget {
  final Plant plant;
  const PredictionScreen({super.key, required this.plant});

  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final ImagePicker _picker = ImagePicker();
  final PredictionService _predictionService = PredictionService();
  // final AIService _aiService = AIService();
  final GeminiAIService _aiService = GeminiAIService(); 

  File? _image;
  Map<String, dynamic>? _predictionResult;
  List<String> _solutionPoints = [];
  String? _errorMessage;
  bool _isLoading = false;
  bool _isGeneratingSolution = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _predictionResult = null;
          _errorMessage = null;
          _solutionPoints = [];
        });
      }
    } catch (e) {
      setState(() => _errorMessage = "Failed to pick image: $e");
    }
  }

  Future<void> _predict() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _solutionPoints = [];
    });

    try {
      final result = await _predictionService.predictImage(
        imageFile: _image!,
        modelId: widget.plant.modelId,
      );
      setState(() => _predictionResult = result);
    } catch (e) {
      setState(() => _errorMessage = "Prediction failed: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getSolutions() async {
    if (_predictionResult == null) return;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    setState(() {
      _isGeneratingSolution = true;
      _solutionPoints = [];
    });

    try {
      final diseaseName = _formatClassName(_predictionResult!['class']);
      final plantName = localeProvider.get(widget.plant.nameKey);
      final language = localeProvider.locale.languageCode == 'hi' ? "Hindi" : "English";

      final result = await _aiService.getSolutions(
        plantName: plantName,
        diseaseName: diseaseName,
        language: language,
      );
      setState(() => _solutionPoints = _parseSolution(result));
    } catch (e) {
      setState(() => _solutionPoints = ["Error generating solution: ${e.toString()}"]);
    } finally {
      setState(() => _isGeneratingSolution = false);
    }
  }

  List<String> _parseSolution(String rawText) {
    return rawText
        .split('\n')
        .where((s) =>
            s.trim().isNotEmpty && (s.trim().startsWith('*') || s.trim().startsWith('-')))
        .map((s) => s.replaceAll(RegExp(r'^\s*[\*\-]\s*'), '').replaceAll('**', '').trim())
        .toList();
  }

  String _formatClassName(String className) {
    return className.replaceAll('___', ' - ').replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final localizedPlantName = localeProvider.get(widget.plant.nameKey);

    return Scaffold(
      appBar: AppBar(
        title: Text('$localizedPlantName ${localeProvider.get("scanTitle")}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            _buildImagePicker(localeProvider),
            const SizedBox(height: 24),
            if (_image != null && !_isLoading) _buildDiagnoseButton(localeProvider),
            const SizedBox(height: 30),
            _buildResult(localeProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(LocaleProvider lm) {
    return Column(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: _image == null
              ? Center(
                  child: Icon(
                    Icons.image_search,
                    size: 80,
                    color: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPickerButton(
              Icons.camera_alt,
              lm.get('camera'),
              () => _pickImage(ImageSource.camera),
            ),
            _buildPickerButton(
              Icons.photo_library,
              lm.get('gallery'),
              () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPickerButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: AppTheme.primaryColor),
      label: Text(label, style: TextStyle(color: AppTheme.primaryColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );
  }

  Widget _buildDiagnoseButton(LocaleProvider lm) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _predict,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          elevation: 5,
        ),
        child: Text(lm.get('analyzeSymptoms')),
      ),
    );
  }

  Widget _buildResult(LocaleProvider lm) {
    if (_isLoading) return const CircularProgressIndicator();
    if (_errorMessage != null)
      return Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      );
    if (_predictionResult != null) {
      return Column(
        children: [
          ResultCard(
            result: _predictionResult!,
            onFindSolutions: _getSolutions,
          ),
          if (_isGeneratingSolution)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          if (_solutionPoints.isNotEmpty)
            SolutionCard(solutionPoints: _solutionPoints),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}