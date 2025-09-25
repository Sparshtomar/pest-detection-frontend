// lib/services/gemini_ai_service.dart

import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/constants.dart';

// FIX: Renamed the class to match the service it provides
class GeminiAIService {
  late final GenerativeModel _model;

  // FIX: Constructor name now correctly matches the class name
  GeminiAIService() {
    if (GEMINI_API_KEY == 'GEMINI_KEY_NOT_FOUND' || GEMINI_API_KEY.isEmpty) {
        throw Exception('Gemini API Key is missing. Please check your .env file.');
    }
    _model = GenerativeModel(
      model: 'gemini-2.0-flash-lite-001',
      apiKey: GEMINI_API_KEY,
    );
  }

  /// Generates an action plan using the Google Gemini API.
  Future<String> getSolutions({
    required String plantName,
    required String diseaseName,
    required String language,
  }) async {
    final prompt = """
    A farmer's "$plantName" plant is showing symptoms identified as "$diseaseName".
    Your task is to identify the pests associated with these symptoms and provide a clear, concise action plan in the $language language.
    Limit the entire response to a maximum of 4 bullet points, focusing on pests first.
    Your response must only contain the bullet points and nothing else.
    - **Likely Pests:** Based on these symptoms, name the 1-2 most likely pests.
    - **Pest Action:** State the single most effective, simple treatment for these pests.
    - **Symptom Treatment:** State the single most important action for the plant's underlying condition ($diseaseName).
    - **Prevention:** State one key preventative measure against these pests for the future.
    """;

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);

    return response.text ?? "";
  }
}