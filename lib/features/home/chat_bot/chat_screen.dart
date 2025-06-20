import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:zameel/core/functions/extract_books_ids.dart';
import 'package:zameel/core/functions/get_token.dart';
import 'package:zameel/core/networking/chat/create_chat.dart';
import 'package:zameel/core/networking/resources_services/fetch_all_books.dart';
import 'package:zameel/core/networking/resources_services/fetch_student_groups.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'dart:convert';
import 'package:zameel/core/widget/custom_snack_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController chatController = TextEditingController();
  late PusherChannelsFlutter _pusher;
  String? chatId;
  String? token;

  final List<Message> messages = [];
  final Map<String, Message> _messageById = {};
  List<int> books = [];

  @override
  void initState() {
    super.initState();
    _initPusher();
  }

  Future<void> _initPusher() async {
    token = await getToken();
    final resultUserGroup = await fetchStudentGroups(token: token!);
    List<int>  groupIds = resultUserGroup['data'];
    if (groupIds.isNotEmpty) {
      final resultoffetchAllUserBooks = await fetchAllBooks(
        token: token!,
        groupId: groupIds.first,
      );

      if (resultoffetchAllUserBooks['success']) {
        final response = resultoffetchAllUserBooks['data'] as Response;
        final allbooks = response.data['data'] as List;
        books = extractBookIds(allbooks);
      }
    }

    final resultOfCreatingChat = await createChat(token: token, books: books);
    chatId = resultOfCreatingChat['chat_id'];

    if (token!.isNotEmpty || chatId!.isNotEmpty) {
      _pusher = PusherChannelsFlutter.getInstance();

      await _pusher.init(apiKey: "2e6578229e9dbd0a0625", cluster: 'eu');

      _pusher.onError = (message, code, exception) {
     
      };

      await _pusher.subscribe(channelName: 'chat.$chatId');

      _pusher.onEvent = (PusherEvent event) {
        final data = jsonDecode(event.data ?? '{}');
        print(data);
        if (data['id'] != null &&
            data['sequence'] != null &&
            data['message'] != null) {
          final String id = data['id'];
          final String part = data['message'];

          setState(() {
            if (_messageById.containsKey(id)) {
              final msg = _messageById[id]!;
              msg.text += part;
            } else {
              final newMsg = Message(id: id, text: part, isMe: false);
              _messageById[id] = newMsg;
              messages.add(newMsg);
            }
          });
        }
      };

      _pusher.onConnectionStateChange = (currentState, previousState) {
        print('Pusher state changed from $previousState to $currentState');
      };

      await _pusher.connect();
    } else {
      customSnackBar(context, "تعذر الحصول على رمز المصادقة", Colors.red);
    }
  }

  Future<void> _sendMessage(String messageText) async {
    final dio = Dio();

    try {
      final response = await dio.post(
        'https://api.zameel.app/api/chat/$chatId',
        data: {'message': messageText},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print("Response: ${response.data}");
      print(chatId);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        setState(() {
          messages.add(Message(id: '', text: messageText, isMe: true));
        });
      }
    } catch (e) {
      customSnackBar(context, "تعذر ارسال الرسالة: $e", Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: 60,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Column(
            children: [
              SvgPicture.asset("assets/images/logo.svg", height: 55, width: 88),
              const SizedBox(height: 6),
            ],
          ),
          leading: IconButton(
            icon: Icon(
              LucideIcons.arrowRight,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    return Align(
                      alignment:
                          message.isMe
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        margin:
                            message.isMe
                                ? const EdgeInsets.only(
                                  top: 5,
                                  right: 10,
                                  bottom: 5,
                                )
                                : const EdgeInsets.only(
                                  top: 5,
                                  left: 10,
                                  bottom: 5,
                                ),
                        decoration: BoxDecoration(
                          color:
                              message.isMe
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft:
                                message.isMe
                                    ? const Radius.circular(0)
                                    : const Radius.circular(12),
                            bottomRight:
                                message.isMe
                                    ? const Radius.circular(12)
                                    : const Radius.circular(0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MarkdownBody(
                              data: message.text,
                              styleSheet: MarkdownStyleSheet(
                                p: TextStyle(
                                  fontSize: 14,
                                  height: 1.8,
                                  color:
                                      message.isMe
                                          ? Colors.white
                                          : Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                  fontFamily: AppFonts.mainFontName,
                                ),
                                h1: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppFonts.mainFontName,
                                  color:
                                      message.isMe
                                          ? Colors.white
                                          : Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                ),
                                h2: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.mainFontName,
                                  height: 1.5,
                                  color:
                                      message.isMe
                                          ? Colors.white
                                          : Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                ),
                                h3: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.mainFontName,
                                  color:
                                      message.isMe
                                          ? Colors.white
                                          : Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                ),
                                horizontalRuleDecoration: BoxDecoration(
                                  color:
                                      message.isMe
                                          ? Colors.white
                                          : Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                listBullet: TextStyle(
                                  color:
                                      message.isMe
                                          ? Colors.white
                                          : Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            if (!message.isMe)
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: message.text),
                                  );
                                },
                                icon: Icon(
                                  LucideIcons.copy,
                                  color: Theme.of(context).colorScheme.onPrimary
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: 5,
                        minLines: 1,
                        controller: chatController,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontFamily: AppFonts.mainFontName,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 15,
                          ),
                          hintText: "اكتب رسالتك",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: AppFonts.mainFontName,
                            color: Theme.of(context).hintColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        LucideIcons.send,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async {
                        final text = chatController.text.trim();
                        if (text.isEmpty) return;
                        chatController.clear();
                        await _sendMessage(text);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  final String id;
  String text;
  final bool isMe;

  Message({required this.id, required this.text, required this.isMe});
}
