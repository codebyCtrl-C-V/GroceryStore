import 'package:flutter/material.dart';
import '../../data/repositories/chatbot_repository.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatbotProvider extends ChangeNotifier {
  final ChatbotRepository _repository;

  ChatbotProvider({ChatbotRepository? repository})
      : _repository = repository ?? ChatbotRepository();

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    _messages.add(ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final reply = await _repository.askChatbot(text);
      // Add chatbot response
      _messages.add(ChatMessage(
        text: reply,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      // Add error feedback to the chat
      _messages.add(ChatMessage(
        text: 'Lỗi: Không thể nhận phản hồi từ chatbot. Vui lòng thử lại.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}
