import 'dart:typed_data';
import 'dart:convert';

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

  Map<String, dynamic> toJson() {
    return {
      'isUser': isUser,
      'text': text,
      'imagePath': imagePath,
      'imageBytes': imageBytes != null ? base64Encode(imageBytes!) : null,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      isUser: json['isUser'] as bool,
      text: json['text'] as String,
      imagePath: json['imagePath'] as String?,
      imageBytes: json['imageBytes'] != null ? base64Decode(json['imageBytes'] as String) : null,
    );
  }
}