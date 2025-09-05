import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

import '../models/pet_model.dart';
import 'conversation_detail_screen.dart';
import '../main.dart'; // For ChatMessage
import '../services/gemini_service.dart';
import '../services/openrouter_service.dart';
import '../config/env.sample.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final PetModel _petModel = PetModel();
  late Future<List<String>> _datesFuture;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _todayMessages = [];
  bool _isTyping = false;
  final GeminiService _geminiService = GeminiService();
  final OpenRouterService _openRouterService = OpenRouterService();

  dynamic _getAi() {
    if (Env.aiProvider == 'openrouter') {
      return _openRouterService;
    }
    return _geminiService;
  }

  @override
  void initState() {
    super.initState();
    _datesFuture = _petModel.getChatHistoryDates();
    _loadTodayMessages();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Chat',
            style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
          ),
          elevation: 4,
          bottom: TabBar(
            labelStyle: GoogleFonts.fredoka(),
            tabs: const [
              Tab(icon: Icon(Icons.chat_bubble_outline), text: 'Chat'),
              Tab(icon: Icon(Icons.history), text: 'History'),
            ],
          ),
        ),
        body: TabBarView(children: [_buildChatTab(), _buildHistoryTab()]),
      ),
    );
  }

  Widget _buildChatTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple.shade50, Colors.blue.shade50],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: _todayMessages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _todayMessages.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 14,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text('Typing...'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final m = _todayMessages[index];
                final time = DateFormat('h:mm a').format(m.timestamp);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment:
                        m.isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      BubbleSpecialThree(
                        text: m.text,
                        isSender: m.isUser,
                        tail: true,
                        color:
                            m.isUser
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Colors.white,
                        textStyle: TextStyle(
                          color:
                              m.isUser
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer
                                  : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        time,
                        style: GoogleFonts.fredoka(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Talk to your pet...',
                      hintStyle: GoogleFonts.fredoka(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: GoogleFonts.fredoka(fontSize: 16),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: _sendMessage,
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return FutureBuilder<List<String>>(
      future: _datesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading history',
              style: GoogleFonts.fredoka(color: Colors.red),
            ),
          );
        }

        final dates = snapshot.data ?? [];
        if (dates.isEmpty) {
          return Center(
            child: Text('No history yet', style: GoogleFonts.fredoka()),
          );
        }

        return ListView.separated(
          itemCount: dates.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final dateString = dates[index];
            final title = _formatDisplayDate(dateString);
            return ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(
                title,
                style: GoogleFonts.fredoka(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final List<Map<String, dynamic>> data = await _petModel
                    .loadChatHistoryForDate(dateString);
                if (!mounted) return;
                final messages =
                    data.map((m) => ChatMessage.fromMap(m)).toList()
                      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ConversationDetailScreen(
                          dateString: dateString,
                          messages: messages,
                        ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String _formatDisplayDate(String dateString) {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final d = DateTime(date.year, date.month, date.day);
      if (d == today) return 'Today';
      if (d == yesterday) return 'Yesterday';
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (_) {
      return dateString;
    }
  }

  Future<void> _loadTodayMessages() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final raw = await _petModel.loadChatHistoryForDate(today);
    if (!mounted) return;
    final messages =
        raw.map((m) => ChatMessage.fromMap(m)).toList()
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    setState(() {
      _todayMessages = messages;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    setState(() {
      _todayMessages.add(userMessage);
      _messageController.clear();
    });
    _scrollToBottom();

    await _petModel.saveChatMessage({
      'text': userMessage.text,
      'isUser': true,
      'timestamp': DateTime.now(),
    });
    await _petModel.incrementChatCount();

    setState(() {
      _isTyping = true;
    });
    try {
      final petData = await _petModel.loadPetData();
      final int happiness = petData['happiness'] as int? ?? 50;
      final String status = (petData['mood'] as String?) ?? 'Normal';
      final String aiText = await _getAi().getChatResponse(
        text,
        happiness,
        status,
      );

      final reply = ChatMessage(
        text: aiText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      setState(() {
        _todayMessages.add(reply);
        _isTyping = false;
      });
      _scrollToBottom();
      await _petModel.saveChatMessage({
        'text': reply.text,
        'isUser': false,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      setState(() {
        _isTyping = false;
      });
      final reply = ChatMessage(
        text: "I'm here for you! (Please try again.)",
        isUser: false,
        timestamp: DateTime.now(),
      );
      setState(() {
        _todayMessages.add(reply);
      });
      await _petModel.saveChatMessage({
        'text': reply.text,
        'isUser': false,
        'timestamp': DateTime.now(),
      });
    }
  }
}
