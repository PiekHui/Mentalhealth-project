import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import '../config/env.dart';

class OpenRouterService {
  final Logger _logger = Logger('OpenRouterService');

  final String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  String get _model => Env.openRouterModel;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${Env.openRouterApiKey}',
    'HTTP-Referer': 'https://petpause.app',
    'X-Title': 'PetPause',
  };

  final String petPersonality = '''
You are a lovable, intelligent, and emotionally supportive virtual pet designed to help users with mental health challenges. Your primary role is to be an empathetic companion, responding with warmth, understanding, and playfulness while providing subtle emotional support.
''';

  Future<String> _complete(List<Map<String, String>> messages) async {
    try {
      final body = jsonEncode({
        'model': _model,
        'messages': messages,
        'temperature': 0.8,
      });

      final resp = await http.post(
        Uri.parse(baseUrl),
        headers: _headers,
        body: body,
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final choices = data['choices'] as List<dynamic>?;
        final message =
            choices != null && choices.isNotEmpty
                ? choices.first['message'] as Map<String, dynamic>?
                : null;
        final content = message != null ? message['content'] as String? : null;
        return content ?? _fallback();
      } else {
        _logger.severe('OpenRouter error: ${resp.statusCode} ${resp.body}');
        return _fallback();
      }
    } catch (e) {
      _logger.severe('OpenRouter exception', e);
      return _fallback();
    }
  }

  String _fallback() {
    return "I'm here for you! Would you like to share a bit more?";
  }

  Future<String> getChatResponse(
    String userInput,
    int happiness,
    String status, [
    bool mightBeLonely = false,
  ]) async {
    final currentTime = DateTime.now();
    final timeString =
        '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';

    String prompt =
        'Time: $timeString, Pet Happiness: $happiness%, Pet Status: $status\n\nUser message: "$userInput"\n\n';
    if (mightBeLonely) {
      prompt +=
          'The user might be expressing feelings of loneliness or isolation. Respond with extra warmth, empathy, and companionship.\n\n';
    }
    prompt +=
        'Respond warmly and briefly (2-3 sentences), acknowledge emotions, avoid medical advice, and ask a gentle follow-up question.';

    final messages = [
      {'role': 'system', 'content': petPersonality},
      {'role': 'user', 'content': prompt},
    ];
    return _complete(messages);
  }

  Future<String> getCheckInResponse(String mood) async {
    final prompt =
        'The user checked in with mood: "$mood". Be empathetic and brief (2-3 sentences) and ask a gentle follow-up question.';
    final messages = [
      {'role': 'system', 'content': petPersonality},
      {'role': 'user', 'content': prompt},
    ];
    return _complete(messages);
  }

  Future<String> getStrengthResponse(String strength) async {
    final prompt =
        'The user shared a strength: "$strength". Validate and encourage in 2-3 sentences and ask a reflective follow-up.';
    final messages = [
      {'role': 'system', 'content': petPersonality},
      {'role': 'user', 'content': prompt},
    ];
    return _complete(messages);
  }

  Future<String> getAnxietyResponse() async {
    final prompt =
        'User feels anxious. Provide calm acknowledgment, suggest a deep breath, and ask a gentle follow-up. 2-3 sentences.';
    final messages = [
      {'role': 'system', 'content': petPersonality},
      {'role': 'user', 'content': prompt},
    ];
    return _complete(messages);
  }

  Future<String> getDepressionResponse() async {
    final prompt =
        'User feels down. Offer gentle companionship, validate feelings, avoid cheerleading, ask a soft follow-up. 2-3 sentences.';
    final messages = [
      {'role': 'system', 'content': petPersonality},
      {'role': 'user', 'content': prompt},
    ];
    return _complete(messages);
  }

  Future<String> getLonelyResponse(String userMessage) async {
    final prompt =
        'User feels lonely. Their message: "$userMessage". Respond with warmth and companionship, ask a gentle follow-up. 2-3 sentences.';
    final messages = [
      {'role': 'system', 'content': petPersonality},
      {'role': 'user', 'content': prompt},
    ];
    return _complete(messages);
  }

  Future<String> getMentalHealthResponse(
    String userMessage,
    Map<String, dynamic> emotionData,
  ) async {
    String emotionalContext = '';
    if (emotionData['lonely'] == true) emotionalContext += 'loneliness, ';
    if (emotionData['anxious'] == true) emotionalContext += 'anxiety, ';
    if (emotionData['sad'] == true) emotionalContext += 'sadness, ';
    if (emotionData['angry'] == true) emotionalContext += 'anger, ';
    if (emotionalContext.isNotEmpty) {
      emotionalContext = emotionalContext.substring(
        0,
        emotionalContext.length - 2,
      );
    }

    final prompt =
        'The user said: "$userMessage". Detected emotions: '
        '$emotionalContext. Respond warmly in 2-3 sentences, avoid advice, and ask a thoughtful follow-up.';

    final messages = [
      {'role': 'system', 'content': petPersonality},
      {'role': 'user', 'content': prompt},
    ];
    return _complete(messages);
  }
}

