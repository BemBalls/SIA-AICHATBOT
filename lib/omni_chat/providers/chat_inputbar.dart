import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../api/api_service.dart';
import '../models/chat_message.dart';

// ── Dark theme tokens (inline so this file is self-contained) ────────────────
// If you have app_theme.dart set up, replace these with AppTheme.xxx
const _bg          = Color(0xFF0D0D0D); // scaffold background
const _surface     = Color(0xFF1A1A1A); // input field bg
const _surfaceAlt  = Color(0xFF242424); // image preview card bg
const _border      = Color(0xFF2E2E2E); // subtle borders
const _accent      = Color(0xFF5B8EF4); // active/highlight accent
const _textPrimary   = Color(0xFFE8E8E8);
const _textSecondary = Color(0xFFAAAAAA);
const _textMuted     = Color(0xFF666666);
const _disabled      = Color(0xFF3A3A3A);

class ChatInputProvider extends ChangeNotifier {
  ChatInputProvider({required this.sessionId});

  final String sessionId;
  String _draft = '';
  bool _isLoading = false;

  String get draft => _draft;
  bool get hasDraft => _draft.trim().isNotEmpty;
  bool get isLoading => _isLoading;

  void updateDraft(String value) {
    _draft = value;
    notifyListeners();
  }

  void clearDraft() {
    _draft = '';
    notifyListeners();
  }

  Future<void> sendMessage(
    String prompt,
    List<ChatMessage> messages,
    void Function(ChatMessage) addMessage,
  ) async {
    if (prompt.trim().isEmpty || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    final userMessage = ChatMessage(isUser: true, text: prompt);
    addMessage(userMessage);

    try {
      final response = await ApiService.instance.sendMessage(prompt);
      addMessage(ChatMessage(isUser: false, text: response));
    } catch (error) {
      addMessage(ChatMessage(
        isUser: false,
        text: 'Unable to load response. Please try again.',
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String text, XFile? image, Uint8List? bytes) onSend;
  final bool isLoading;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.isLoading = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  XFile?    _pickedImage;
  Uint8List? _imageBytes;

  // ── Actions ──────────────────────────────────────────────────────────────

  void _handleSend() {
    if (widget.controller.text.trim().isEmpty && _pickedImage == null) return;
    if (widget.isLoading) return;

    widget.onSend(widget.controller.text, _pickedImage, _imageBytes);
    widget.controller.clear();
    setState(() {
      _pickedImage = null;
      _imageBytes  = null;
    });
  }

  void _removeImage() => setState(() {
        _pickedImage = null;
        _imageBytes  = null;
      });

  Future<void> _pickImage() async {
    if (widget.isLoading) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = kIsWeb ? await picked.readAsBytes() : null;
      setState(() {
        _pickedImage = picked;
        _imageBytes  = bytes;
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _border, width: 0.8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ImagePreview(
            pickedImage: _pickedImage,
            imageBytes:  _imageBytes,
            onRemove:    _removeImage,
          ),
          _InputRow(
            controller:   widget.controller,
            isLoading:    widget.isLoading,
            hasImage:     _pickedImage != null,
            onPickImage:  _pickImage,
            onSend:       _handleSend,
          ),
        ],
      ),
    );
  }
}

// ── Image preview strip ───────────────────────────────────────────────────────

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.pickedImage,
    required this.imageBytes,
    required this.onRemove,
  });

  final XFile?    pickedImage;
  final Uint8List? imageBytes;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: pickedImage != null ? 90 : 0,
      curve: Curves.easeInOut,
      child: pickedImage != null
          ? Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _surfaceAlt,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border, width: 0.8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.memory(imageBytes!,
                            width: 70, height: 70, fit: BoxFit.cover)
                        : Image.file(File(pickedImage!.path),
                            width: 70, height: 70, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 12),

                  // File info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pickedImage!.name,
                          style: const TextStyle(
                            fontSize: 13,
                            color: _textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Image attached',
                          style: TextStyle(fontSize: 12, color: _textMuted),
                        ),
                      ],
                    ),
                  ),

                  // Remove button
                  GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _border),
                      ),
                      child: const Icon(Icons.close,
                          size: 16, color: _textSecondary),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

// ── Input row ─────────────────────────────────────────────────────────────────

class _InputRow extends StatelessWidget {
  const _InputRow({
    required this.controller,
    required this.isLoading,
    required this.hasImage,
    required this.onPickImage,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isLoading;
  final bool hasImage;
  final VoidCallback onPickImage;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ── Image picker icon ──
        GestureDetector(
          onTap: isLoading ? null : onPickImage,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 9),
            child: Icon(
              Icons.image_outlined,
              size: 22,
              color: isLoading
                  ? _disabled
                  : hasImage
                      ? _accent        // accent when image attached
                      : _textSecondary,
            ),
          ),
        ),

        // ── Text field ──
        Expanded(
          child: Container(
            constraints:
                const BoxConstraints(minHeight: 40, maxHeight: 120),
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _border, width: 0.8),
            ),
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.enter &&
                    !HardwareKeyboard.instance.isShiftPressed &&
                    !isLoading) {
                  onSend();
                }
              },
              child: TextField(
                controller: controller,
                style: const TextStyle(
                    fontSize: 13, color: _textPrimary),
                maxLines: null,
                enabled: !isLoading,
                textInputAction: TextInputAction.send,
                onSubmitted: isLoading ? null : (_) => onSend(),
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: InputBorder.none,
                  hintText: 'Message',
                  hintStyle:
                      TextStyle(fontSize: 13, color: _textMuted),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // ── Send button ──
        GestureDetector(
          onTap: isLoading ? null : onSend,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: isLoading ? _disabled : _accent,
              borderRadius: BorderRadius.circular(22),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(_textSecondary),
                    ),
                  )
                : const Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}