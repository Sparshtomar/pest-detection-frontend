import 'package:dart_openai/dart_openai.dart';
import '../config/constants.dart';

class AIService {
  AIService() {
    OpenAI.apiKey = OPENAI_API_KEY;
  }

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

    final chatCompletion = await OpenAI.instance.chat.create(
      model: 'gpt-3.5-turbo',
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
          ],
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );

    return chatCompletion.choices.first.message.content?.first.text ?? "";
  }
}