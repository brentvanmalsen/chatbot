import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_chatbot/consts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(
        seconds: 5,
      ),
    ),
    enableLog: true,
  );

  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Brent', lastName: 'Malsen');

  final ChatUser _gptChatUser =
      ChatUser(id: '2', firstName: 'Chat', lastName: 'GPT');

  List<ChatMessage> _messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(
            0,
            166,
            126,
            1,
          ),
          title: const Text(
            'GPT Chat',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: DashChat(
            currentUser: _currentUser,
            messageOptions: const MessageOptions(
              currentUserContainerColor: Colors.black,
              containerColor: Color.fromRGBO(
                0,
                166,
                126,
                1,
              ),
              textColor: Colors.white,
            ),
            onSend: (ChatMessage m) {
              getChatResponse(m);
            },
            messages: _messages));
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
    });
    List<Messages> _messagesHistory = _messages.map((m) {
      if (m.user == _currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();
  }
}
