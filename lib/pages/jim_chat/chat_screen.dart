import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'widgets/chat_message.dart';
import 'widgets/chat_service.dart';
import 'widgets/chat_messagelist.dart';
import 'widgets/chat_inputbar.dart';
import 'widgets/chat_repository.dart';
import 'package:omnichat/widgets/response_page.dart';
import 'package:omnichat/widgets/fade_slide_up.dart';
import 'package:omnichat/widgets/header.dart';

class JimChatApp extends ResponsePage {
  const JimChatApp({super.key, required super.token})
    : super(endpoint: "users/me");

  @override
  State<StatefulWidget> createState() => _JimChatScreenState();
}

class _JimChatScreenState extends ResponsePageState<JimChatApp> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const Color gymJamsOrange = Color(0xFFF27E35);

  List<ChatMessage> _messages = [];
  bool _showContent = false;
  bool _isWaitingForResponse = false;
  bool _isLoadingMoreHistory = false;
  bool _hasMoreHistory = true;
  final int _historyPageSize = 20;
  int _historyOffset = 0;
  Map<String, dynamic> _userProfile = {};

  @override
  Future<bool> init(Object? data) async {
    print('DEBUG: Chat profile response payload: $data');
    Map<String, dynamic> profile = {};
    if (data is Map<String, dynamic>) {
      if (data['user_profile'] is Map<String, dynamic>) {
        profile = Map<String, dynamic>.from(data['user_profile'] as Map<String, dynamic>);
      } else if (data['profile'] is Map<String, dynamic>) {
        profile = Map<String, dynamic>.from(data['profile'] as Map<String, dynamic>);
      } else {
        profile = Map<String, dynamic>.from(data);
      }
    }

    print('DEBUG: Parsed userProfile for ChatService: $profile');
    _userProfile = profile;

    final initialized = await _initializeApp();
    return initialized ? super.init(data) : false;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void activate() {
    super.activate();
    if (_showContent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scrollToBottom();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> _initializeApp() async {
    if (!mounted) return false;
    try {
      await _loadRecentMessages();
    } catch (e) {
      if (mounted) return false;
    }
    return true;
  }

  Future<void> _loadRecentMessages() async {
    if (!mounted) return;
    try {
      final messages = await ChatRepository.loadMessages(
        offset: 0,
        limit: _historyPageSize,
      );

      if (!mounted) return;

      final bool hasMessages = messages.isNotEmpty;

      setState(() {
        _messages = messages;
        _historyOffset = messages.length;
        _hasMoreHistory = messages.length >= _historyPageSize;

        // Only show welcome message if no existing messages
        if (!hasMessages) {
          _messages.add(
            ChatMessage(
              isUser: false,
              text:
                  'Hi! I\'m Jim, your fitness companion. How can I help today?',
            ),
          );
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scrollToBottom();
      });
    } catch (e) {
      if (mounted) return;
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        _isLoadingMoreHistory ||
        !_hasMoreHistory) {
      return;
    }
    if (_scrollController.position.pixels <= 60) {
      _loadPreviousMessages();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend(String text, XFile? image, Uint8List? bytes) {
    if (text.trim().isEmpty && image == null) return;
    if (_isWaitingForResponse || !mounted) return;

    final userMsg = ChatMessage(
      isUser: true,
      text: text.trim(),
      imagePath: kIsWeb ? null : image?.path,
      imageBytes: bytes,
    );

    setState(() {
      _messages.add(userMsg);
      _isWaitingForResponse = true;
    });

    _scrollToBottom();
    _fetchAIResponse();
  }

  Future<void> _fetchAIResponse() async {
    if (!mounted) return;
    try {
      setState(() {
        _messages.add(ChatMessage(isUser: false, text: "..."));
      });
      _scrollToBottom();
      final response = await ChatService.sendMessage(
        messageHistory: _messages,
        userProfile: _userProfile,
      );
      if (!mounted) return;
      if (_messages.isNotEmpty && _messages.last.text == "...") {
        _messages.removeLast();
      }
      setState(() {
        _messages.add(ChatMessage(isUser: false, text: response));
        _isWaitingForResponse = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      if (_messages.isNotEmpty && _messages.last.text == "...") {
        _messages.removeLast();
      }
      setState(() {
        _messages.add(
          ChatMessage(isUser: false, text: "Sorry, I hit an error: $e"),
        );
        _isWaitingForResponse = false;
      });
    }
    // await ChatStorage.saveMessages(_messages);
  }

  Future<void> _loadPreviousMessages() async {
    if (_isLoadingMoreHistory || !_hasMoreHistory || !mounted) return;
    _isLoadingMoreHistory = true;
    try {
      final double oldMaxScroll = _scrollController.hasClients
          ? _scrollController.position.maxScrollExtent
          : 0.0;
      final previousMessages = await ChatRepository.loadMessages(
        offset: _historyOffset,
        limit: _historyPageSize,
      );
      if (!mounted) return;
      if (previousMessages.isEmpty) {
        _hasMoreHistory = false;
        return;
      }
      setState(() {
        _messages.insertAll(0, previousMessages);
        _historyOffset += previousMessages.length;
        _hasMoreHistory = previousMessages.length >= _historyPageSize;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;
        final double newMaxScroll = _scrollController.hasClients
            ? _scrollController.position.maxScrollExtent
            : 0.0;
        final offsetAdjustment = newMaxScroll - oldMaxScroll;
        final targetOffset = _scrollController.offset + offsetAdjustment;
        _scrollController.jumpTo(targetOffset.clamp(0.0, newMaxScroll));
      });
    } catch (e) {
      print('Error loading previous messages: $e');
    } finally {
      if (mounted) _isLoadingMoreHistory = false;
    }
  }

  @override
  Widget loadPage() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      bottomNavigationBar: _showContent
          ? AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SafeArea(
                top: false,
                child: FadeSlideUp(
                  child: ChatInputBar(
                    controller: _controller,
                    onSend: _handleSend,
                    isLoading: _isWaitingForResponse,
                  ),
                ),
              ),
            )
          : null,
      drawer: null,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: [
            FadeSlideUp(
              delay: 0,
              child: Header(
                header: 'Assistant',
                subheader: 'Your AI assistant',
                onFinished: () {
                  setState(() {
                    _showContent = true;
                  });
                },
                children: [
                  HeaderButton(
                    icon: Icons.menu,
                    onPressed: () {
                      // drawer removed in slimmed-down app
                    },
                  ),
                ],
              ),
            ),
            if (_showContent)
              Expanded(
                child: FadeSlideUp(
                  delay: 200,
                  child: Container(
                    color: const Color(0xFFF6F0E8),
                    child: Column(
                      children: [
                        if (_isLoadingMoreHistory)
                          const LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: gymJamsOrange,
                          ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: ChatMessageList(
                              messages: _messages,
                              scrollController: _scrollController,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
