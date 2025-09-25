import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

// --- Configuration ---
const String serverUrl = "http://10.229.231.2:8000";
const String GEMINI_API_KEY = "AIzaSyBQ9jQFKFWqH4hSraOv2a8O0SN_sDiNQWY";
// --- End of Configuration ---

// --- Localization Manager ---
class LocaleManager with ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  String get(String key) {
    return _translations[_locale.languageCode]?[key] ?? key;
  }
}

// --- Translation Data ---
const Map<String, Map<String, String>> _translations = {
  'en': {
    'appTitle': 'Kisaan Mitra',
    'welcome': 'Welcome!',
    'selectPlant': 'Select a plant to identify pests by symptoms.',
    'camera': 'Camera',
    'gallery': 'Gallery',
    'analyzeSymptoms': 'Analyze Symptoms',
    'symptomAnalysis': 'Symptom Analysis',
    'confidence': 'Confidence:',
    'identifyPests': 'Identify Pests & Get Action Plan',
    'pestActionPlan': 'Pest & Action Plan',
    'plant_tomato': 'Tomato',
    'plant_potato': 'Potato',
    'plant_grape': 'Grape',
    'plant_corn': 'Corn',
    'plant_wheat': 'Wheat',
    'plant_sugarcane': 'Sugarcane',
    'scanTitle': 'Pest & Symptom Scan',
  },
  'hi': {
    'appTitle': 'किसान मित्र',
    'welcome': 'आपका स्वागत है!',
    'selectPlant': 'लक्षणों से कीटों की पहचान के लिए एक पौधा चुनें।',
    'camera': 'कैमरा',
    'gallery': 'गैलरी',
    'analyzeSymptoms': 'लक्षणों का विश्लेषण करें',
    'symptomAnalysis': 'लक्षण विश्लेषण',
    'confidence': 'आत्मविश्वास:',
    'identifyPests': 'कीटों की पहचान करें और कार्य योजना प्राप्त करें',
    'pestActionPlan': 'कीट और कार्य योजना',
    'plant_tomato': 'टमाटर',
    'plant_potato': 'आलू',
    'plant_grape': 'अंगूर',
    'plant_corn': 'मक्का',
    'plant_wheat': 'गेहूँ',
    'plant_sugarcane': 'गन्ना',
    'scanTitle': 'कीट और लक्षण स्कैन',
  },
};

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleManager(),
      child: const PlantDoctorApp(),
    ),
  );
}

// --- Data Models ---
class Plant {
  final String nameKey; // Changed from 'name' to 'nameKey' for localization
  final String modelId;
  final IconData icon;

  Plant({required this.nameKey, required this.modelId, required this.icon});
}

final List<Plant> plants = [
  Plant(nameKey: "plant_tomato", modelId: "model1", icon: Icons.spa),
  Plant(nameKey: "plant_potato", modelId: "model2", icon: Icons.eco),
  Plant(nameKey: "plant_grape", modelId: "model3", icon: Icons.grass),
  Plant(nameKey: "plant_corn", modelId: "model4", icon: Icons.grain),
  Plant(nameKey: "plant_wheat", modelId: "model5", icon: Icons.bakery_dining),
  Plant(nameKey: "plant_sugarcane", modelId: "model6", icon: Icons.waves),
];

// --- App Theme ---
class AppTheme {
  static final Color primaryColor = Color(0xFF2E7D32);
  static final Color secondaryColor = Color(0xFF4CAF50);
  static final Color backgroundColor = Color(0xFFF5F9F6);
  static final Color cardColor = Colors.white;
  static final Color accentColor = Color(0xFFFFC107);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Poppins',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: primaryColor),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

class PlantDoctorApp extends StatelessWidget {
  const PlantDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeManager = Provider.of<LocaleManager>(context);
    return MaterialApp(
      title: 'Kisaan Mitra',
      theme: AppTheme.theme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      locale: localeManager.locale,
    );
  }
}

// --- Home Page ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localeManager = Provider.of<LocaleManager>(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 130.0,
              pinned: true,
              actions: [
                // START OF CHANGE
                IconButton(
                  onPressed: () {
                    final newLocale =
                        localeManager.locale.languageCode == 'en'
                            ? const Locale('hi')
                            : const Locale('en');
                    localeManager.setLocale(newLocale);
                  },
                  icon: Icon(
                    Icons.language,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                // END OF CHANGE
                SizedBox(width: 10),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  localeManager.get('appTitle'),
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(color: AppTheme.backgroundColor),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localeManager.get('welcome'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      localeManager.get('selectPlant'),
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.9,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => PlantCard(plant: plants[index]),
                  childCount: plants.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Plant Card Widget ---
class PlantCard extends StatelessWidget {
  final Plant plant;
  const PlantCard({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final localeManager = Provider.of<LocaleManager>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PredictionPage(plant: plant)),
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
              localeManager.get(plant.nameKey), // Use localized name
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Prediction Page ---
class PredictionPage extends StatefulWidget {
  final Plant plant;
  const PredictionPage({super.key, required this.plant});

  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? _predictionResult;
  bool _isLoading = false;
  String? _errorMessage;

  bool _isGeneratingSolution = false;
  List<String> _solutionPoints = [];

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
      final uri = Uri.parse('$serverUrl/predict/${widget.plant.modelId}');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _image!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        setState(() => _predictionResult = json.decode(responseBody));
      } else {
        final responseBody = await response.stream.bytesToString();
        setState(
          () =>
              _errorMessage = "Error: ${response.reasonPhrase} ($responseBody)",
        );
      }
    } catch (e) {
      setState(
        () =>
            _errorMessage =
                "Connection failed. Please check your network and server IP.",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<String> _parseSolution(String rawText) {
    return rawText
        .split('\n')
        .where(
          (s) =>
              s.trim().isNotEmpty &&
              (s.trim().startsWith('*') || s.trim().startsWith('-')),
        )
        .map(
          (s) =>
              s
                  .replaceAll(RegExp(r'^\s*[\*\-]\s*'), '')
                  .replaceAll('**', '')
                  .trim(),
        )
        .toList();
  }

  Future<void> _getSolutionsFromAI() async {
    if (_predictionResult == null) return;
    final localeManager = Provider.of<LocaleManager>(context, listen: false);

    if (GEMINI_API_KEY == "YOUR_GEMINI_API_KEY") {
      setState(
        () => _solutionPoints = ["Error: Please add your Gemini API Key."],
      );
      return;
    }

    setState(() {
      _isGeneratingSolution = true;
      _solutionPoints = [];
    });

    final diseaseName = _formatClassName(_predictionResult!['class']);
    final plantName = localeManager.get(widget.plant.nameKey);
    final targetLanguage =
        localeManager.locale.languageCode == 'hi' ? "Hindi" : "English";

    final prompt = """
    You are an agricultural expert. A farmer's "$plantName" plant is showing symptoms identified as "$diseaseName".
    The primary goal is to identify the pests associated with these symptoms and provide a clear action plan.
    Provide a highly concise action plan. Limit the entire response to a maximum of 4 bullet points, focusing on pests first.
    Your response must only contain the bullet points and nothing else.
    IMPORTANT: Your entire response must be in the $targetLanguage language.

    - **Likely Pests:** Based on these symptoms, name the 1-2 most likely pests.
    - **Pest Action:** State the single most effective, simple treatment for these pests.
    - **Symptom Treatment:** State the single most important action for the plant's underlying condition ($diseaseName).
    - **Prevention:** State one key preventative measure against these pests for the future.
    """;

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: GEMINI_API_KEY,
      );
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      setState(() => _solutionPoints = _parseSolution(response.text ?? ""));
    } catch (e) {
      setState(
        () => _solutionPoints = ["Error generating solution: ${e.toString()}"],
      );
    } finally {
      setState(() => _isGeneratingSolution = false);
    }
  }

  String _formatClassName(String className) {
    return className.replaceAll('___', ' - ').replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    final localeManager = Provider.of<LocaleManager>(context);
    final localizedPlantName = localeManager.get(widget.plant.nameKey);

    return Scaffold(
      appBar: AppBar(
        title: Text('$localizedPlantName ${localeManager.get("scanTitle")}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            _buildImagePicker(localeManager),
            const SizedBox(height: 24),
            if (_image != null && !_isLoading)
              _buildDiagnoseButton(localeManager),
            const SizedBox(height: 30),
            _buildResult(localeManager),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(LocaleManager lm) {
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
          child:
              _image == null
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

  Widget _buildDiagnoseButton(LocaleManager lm) {
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

  Widget _buildResult(LocaleManager lm) {
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
            onFindSolutions: _getSolutionsFromAI,
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

// --- Result Card Widget ---
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
    final localeManager = Provider.of<LocaleManager>(context, listen: false);
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
            localeManager.get('symptomAnalysis'),
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
                localeManager.get('confidence'),
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
                label: Text(localeManager.get('identifyPests')),
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

// --- Solution Card Widget ---
class SolutionCard extends StatelessWidget {
  final List<String> solutionPoints;
  const SolutionCard({super.key, required this.solutionPoints});

  @override
  Widget build(BuildContext context) {
    final localeManager = Provider.of<LocaleManager>(context, listen: false);
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
            localeManager.get('pestActionPlan'),
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
