import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/chatbot_provider.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    final provider = context.read<ChatbotProvider>();
    provider.sendMessage(text).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final chatbotProvider = context.watch<ChatbotProvider>();
    final messages = chatbotProvider.messages;
    final isLoading = chatbotProvider.isLoading;

    return Column(
      children: [
        // Message list
        Expanded(
          child: messages.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.auto_awesome, size: 40, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          AppStrings.chatbotWelcome,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tôi có thể giải đáp các thắc mắc về sản phẩm, chính sách cửa hàng và đơn hàng.',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _buildMessageBubble(msg);
                  },
                ),
        ),

        // Typing indicator
        if (isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                ),
                const SizedBox(width: 8),
                Text(
                  'Trợ lý đang suy nghĩ...',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500], fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),

        // Bottom text field input
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: AppStrings.chatbotHint,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final alignment = msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bgColor = msg.isUser ? AppColors.primary : Colors.grey.withValues(alpha: 0.15);
    final textColor = msg.isUser ? Colors.white : AppColors.textPrimary;
    final borderRadius = msg.isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius,
          ),
          child: Text(
            msg.text,
            style: TextStyle(color: textColor, fontSize: 13, height: 1.4),
          ),
        ),
        Text(
          '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
          style: TextStyle(fontSize: 9, color: Colors.grey[400]),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
