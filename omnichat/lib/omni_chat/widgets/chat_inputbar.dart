import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  XFile? _pickedImage;
  Uint8List? _imageBytes;

  void _handleSend() {
    if (widget.controller.text.trim().isEmpty && _pickedImage == null) return;
    if (widget.isLoading) return; // Prevent sending while loading
    
    widget.onSend(widget.controller.text, _pickedImage, _imageBytes);
    widget.controller.clear();
    setState(() {
      _pickedImage = null;
      _imageBytes = null;
    });
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
      _imageBytes = null;
    });
  }

  Future<void> _pickImage() async {
    if (widget.isLoading) return; // Prevent picking while loading
    
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final Uint8List? bytes = kIsWeb ? await picked.readAsBytes() : null;
      setState(() {
        _pickedImage = picked;
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F8FD),
        border: Border(
          top: BorderSide(color: Color(0x14000000), width: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image preview area - always visible when image is picked
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: _pickedImage != null ? 90 : 0,
            curve: Curves.easeInOut,
            child: _pickedImage != null
                ? Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x1F000000), width: 0.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: kIsWeb
                              ? Image.memory(
                                  _imageBytes!,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_pickedImage!.path),
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(width: 12),
                        // Image info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _pickedImage!.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF1A1A1A),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Image attached',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF808080),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Remove button
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: _removeImage,
                            color: const Color(0xFF1A1A1A),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          // Input row
          Row(
            children: [
              GestureDetector(
                onTap: widget.isLoading ? null : _pickImage,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.image_outlined,
                    color: widget.isLoading
                        ? const Color(0xFFCCCCCC) // Disabled color
                        : (_pickedImage != null 
                            ? const Color(0xFFFF9F6D) 
                            : const Color(0xFF1A1A1A)),
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 38,
                    maxHeight: 120,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0x1F000000), width: 0.5),
                  ),
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: (event) {
                      // Check if Enter is pressed without Shift
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.enter &&
                          !HardwareKeyboard.instance.isShiftPressed &&
                          !widget.isLoading) {
                        _handleSend();
                      }
                    },
                    child: TextField(
                      controller: widget.controller,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)),
                      maxLines: null,
                      enabled: !widget.isLoading, // Disable input while loading
                      textInputAction: TextInputAction.send,
                      onSubmitted: widget.isLoading ? null : (_) => _handleSend(),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: InputBorder.none,
                        hintText: 'Message',
                        hintStyle: TextStyle(fontSize: 13, color: Color(0xFFB0B0B0)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: widget.isLoading ? null : _handleSend,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: widget.isLoading
                        ? const Color(0xFFCCCCCC) // Disabled color
                        : const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
          ),
        ],
      ),
    );
  }
}