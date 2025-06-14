import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:zameel/core/theme/app_fonts.dart';
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
  final String chatId = '9f274d32-52f3-4f17-881c-0d7dfa4b40c3'; // ID المحادثة
 String  token = "320|HH5UzdsIvlnFYE10vTMorhdn2KQzK5a1mwPAOKbM964a0555";

  @override
  void initState() {
    super.initState();
    _initPusher();
  }

  Future<void> _initPusher() async {
      
      
    _pusher = PusherChannelsFlutter.getInstance();

    await _pusher.init(apiKey: "2e6578229e9dbd0a0625", cluster: 'eu');

    // استماع لأخطاء الاتصال
    _pusher.onError = (message, code, exception) {
      print(
        'Pusher connection error: $message, code: $code, exception: $exception',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'خطأ في الاتصال بخادم الدردشة: $message , $code , $exception',
          ),
        ),
      );
    };

    await _pusher.subscribe(channelName: 'chat.$chatId');

    _pusher.onEvent = (PusherEvent event) {
      final data = jsonDecode(event.data ?? '{}');
      if (data['message'] != null) {
        setState(() {
          messages.add(Message(text: data['message'], isMe: false));
        });
      }
    };
    _pusher.onConnectionStateChange = (currentState, previousState) {
      print('Pusher state changed from $previousState to $currentState');
    };

    await _pusher.connect();
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

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        setState(() {
          messages.add(Message(text: messageText, isMe: true));
        });
      } else {}
    } catch (e) {
      customSnackBar(context, "تعذر ارسال الرسالة$e", Colors.red);
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
                    final message =
                        messages[messages.length -
                            1 -
                            index]; // عكس القائمة بسبب reverse
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
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              message.isMe
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withAlpha(180)
                                  : Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer
                                  : Theme.of(context).colorScheme.onSecondary,
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
                        child: Text(
                          message.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.8,
                            fontWeight: FontWeight.w400,
                          ),
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

final List<Message> messages = [];

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:zameel/core/networking/chat/create_chat.dart';
// import 'package:zameel/core/theme/app_fonts.dart';
// import 'dart:convert';

// import 'package:zameel/core/widget/custom_snack_bar.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController chatController = TextEditingController();
//   late PusherChannelsFlutter _pusher;
//   String chatId = ''; // ID المحادثة
//   String? token;
//   bool isCreating = false;

//   @override
//   void initState() {
//     super.initState();
//     _createChat();
//   }

//   Future<void> _createChat() async {
//     setState(() {
//       isCreating = true;
//     });
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     token = prefs.getString('token');
//     if (token != null) {
//       final result = await createChat(token: token);
//       print(result);
//       if (result['success'] == true) {
//         print(result);
//         chatId = result['chat_id'];
//         setState(() {
//           isCreating = false;
//         });
//         if (chatId != '') {
//           print("chatId: $chatId");
//           _initPusher();
//         } else {
//           customSnackBar(context, "حدث خطأ في جلب المحادثة", Colors.red);
//         }
//       } else {
//         customSnackBar(context, "$result حدث خطأ في المحادثة", Colors.red);
//         setState(() {
//           isCreating = false;
//         });
//       }
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('خطأ في تسجيل الدخول')));
//     }
//   }

//   Future<void> _initPusher() async {
//     print("chatId: $chatId");
//     print("+++++++++++++++++++++++");
//     _pusher = PusherChannelsFlutter.getInstance();
//     await _pusher.init(apiKey: "2e6578229e9dbd0a0625", cluster: 'eu');
//     _pusher.onError = (message, code, exception) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'خطأ في الاتصال بخادم الدردشة: $message , $code , $exception',
//           ),
//         ),
//       );
//     };

//     await _pusher.subscribe(channelName: 'chat.$chatId');

//     _pusher.onEvent = (PusherEvent event) {
//       final data = jsonDecode(event.data ?? '{}');
//       if (data['message'] != null) {
//         setState(() {
//           messages.add(Message(text: data['message'], isMe: false));
//         });
//       }
//     };

//     await _pusher.connect();
//   }

//   Future<void> _sendMessage(String messageText) async {
//     final dio = Dio();

//     try {
//       final response = await dio.post(
//         'https://api.zameel.app/api/chat/$chatId',
//         data: {'message': messageText},
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200 ||
//           response.statusCode == 201 ||
//           response.statusCode == 202) {
//         setState(() {
//           messages.add(Message(text: messageText, isMe: true));
//         });
//       } else {}
//     } catch (e) {
//       return;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           automaticallyImplyLeading: false,
//           centerTitle: true,
//           toolbarHeight: 60,
//           scrolledUnderElevation: 0,
//           elevation: 0,
//           title: Column(
//             children: [
//               SvgPicture.asset("assets/images/logo.svg", height: 55, width: 88),
//               const SizedBox(height: 6),
//             ],
//           ),
//           leading: IconButton(
//             icon: Icon(
//               LucideIcons.arrowRight,
//               color: Theme.of(context).iconTheme.color,
//             ),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body:
//             isCreating
//                 ? Center(child: CircularProgressIndicator())
//                 : Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: ListView.builder(
//                           reverse: true,
//                           itemCount: messages.length,
//                           itemBuilder: (context, index) {
//                             final message =
//                                 messages[messages.length -
//                                     1 -
//                                     index]; // عكس القائمة بسبب reverse
//                             return Align(
//                               alignment:
//                                   message.isMe
//                                       ? Alignment.centerLeft
//                                       : Alignment.centerRight,
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 10,
//                                   horizontal: 14,
//                                 ),
//                                 margin: const EdgeInsets.symmetric(vertical: 4),
//                                 decoration: BoxDecoration(
//                                   color:
//                                       message.isMe
//                                           ? Theme.of(
//                                             context,
//                                           ).colorScheme.primary.withAlpha(180)
//                                           : Theme.of(context).brightness ==
//                                               Brightness.dark
//                                           ? Theme.of(
//                                             context,
//                                           ).colorScheme.onSecondaryContainer
//                                           : Theme.of(
//                                             context,
//                                           ).colorScheme.onSecondary,
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: const Radius.circular(12),
//                                     topRight: const Radius.circular(12),
//                                     bottomLeft:
//                                         message.isMe
//                                             ? const Radius.circular(0)
//                                             : const Radius.circular(12),
//                                     bottomRight:
//                                         message.isMe
//                                             ? const Radius.circular(12)
//                                             : const Radius.circular(0),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   message.text,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14,
//                                     height: 1.8,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           color:
//                               Theme.of(
//                                 context,
//                               ).colorScheme.onSecondaryContainer,
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(10),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 maxLines: 5,
//                                 minLines: 1,
//                                 controller: chatController,
//                                 style: TextStyle(
//                                   color:
//                                       Theme.of(context).colorScheme.onPrimary,
//                                   fontFamily: AppFonts.mainFontName,
//                                   fontSize: 14,
//                                 ),
//                                 decoration: InputDecoration(
//                                   contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 5,
//                                     vertical: 15,
//                                   ),
//                                   hintText: "اكتب رسالتك",
//                                   hintStyle: TextStyle(
//                                     fontSize: 14,
//                                     fontFamily: AppFonts.mainFontName,
//                                     color: Theme.of(context).hintColor,
//                                   ),
//                                   border: InputBorder.none,
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 LucideIcons.send,
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                               onPressed: () async {
//                                 final text = chatController.text.trim();
//                                 if (text.isEmpty) return;
//                                 chatController.clear();
//                                 await _sendMessage(text);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//       ),
//     );
//   }
// }

// final List<Message> messages = [];

// class Message {
//   final String text;
//   final bool isMe;

//   Message({required this.text, required this.isMe});
// }
