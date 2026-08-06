import '../datasources/chatbot_remote_datasource.dart';

class ChatbotRepository {
  final ChatbotRemoteDataSource _remoteDataSource;

  ChatbotRepository({ChatbotRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ChatbotRemoteDataSource();

  Future<String> askChatbot(String message) {
    return _remoteDataSource.askChatbot(message);
  }
}
