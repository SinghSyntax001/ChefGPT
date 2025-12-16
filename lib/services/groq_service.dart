import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GroqService {
  final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';

  static const String _baseUrl = "https://api.groq.com/openai/v1/chat/completions";

  Future<String> generateRecipe(String dishName) async {
    if (_apiKey.isEmpty) {
      return "GROQ API key missing. Please add it to your .env";
    }

    final messages = [
      {
        "role": "system",
        "content": '''
You are a professional chef. Provide a recipe with these sections: Ingredients, Instructions, and Tips.
Use bullet points using "•" for ingredients.
Use a numbered list for instructions.
Respond in clean, plain text only. NO markdown, no hashes, no asterisks.
Keep steps short and very clear.
'''
      },
      {"role": "user", "content": "Give me a detailed recipe for $dishName"}
    ];

    final body = {
      "model": "llama-3.1-8b-instant",
      "messages": messages,
      "temperature": 0.4,
    };

    final res = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiKey",
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return decoded["choices"][0]["message"]["content"];
    } else {
      return "Error: ${res.statusCode} ${res.body}";
    }
  }

  Future<String> chat(List<Map<String, String>> history) async {
    if (_apiKey.isEmpty) {
      return "GROQ API key missing. Please add it to your .env";
    }

    // Convert history to OpenAI format
    final messages = history.map((m) {
      return {
        "role": m["role"],
        "content": m["content"],
      };
    }).toList();

    // Add friendly chef instructions
    messages.insert(0, {
      "role": "system",
      "content": '''
You are a friendly AI chef. Respond in clean, plain text only.
NO markdown, no hashtags, no asterisks.
Short sentences. Simple explanations.
'''
    });

    final body = {
      "model": "llama-3.1-8b-instant",
      "messages": messages,
      "temperature": 0.4,
    };

    final res = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiKey",
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return decoded["choices"][0]["message"]["content"];
    } else {
      return "Error: ${res.statusCode} ${res.body}";
    }
  }
}
