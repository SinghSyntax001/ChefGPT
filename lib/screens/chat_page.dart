import 'package:flutter/material.dart';
import 'package:recipe_book_app/services/groq_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _ctrl = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final GroqService _groq = GroqService(); // ✅ instance service
  bool _loading = false;

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    _ctrl.clear();

    setState(() {
      _messages.add({"role": "user", "content": text});
      _loading = true;
    });

    // ✅ call the instance method with a positional argument
    final reply = await _groq.chat(_messages);

    setState(() {
      _messages.add({"role": "assistant", "content": reply});
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("AI Chef Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                final isUser = msg['role'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser ? cs.primary.withOpacity(0.15) : cs.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['content'] ?? '',
                      style: const TextStyle(fontSize: 15.5, height: 1.4),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: CircularProgressIndicator(),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: "Ask AI Chef anything...",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton.filled(
                    onPressed: _send,
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
