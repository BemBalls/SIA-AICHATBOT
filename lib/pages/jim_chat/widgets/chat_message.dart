import 'dart:typed_data';

class ChatMessage {
  final bool isUser;
  final String text;
  final String? imagePath;
  final Uint8List? imageBytes;

  const ChatMessage({
    required this.isUser,
    required this.text,
    this.imagePath,
    this.imageBytes,
  });
}