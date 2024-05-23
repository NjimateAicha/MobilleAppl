import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:moroccan_explorer/consts.dart';
import 'package:moroccan_explorer/ui/widgets/home.button.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  List<ChatUser> _typingUsers = <ChatUser>[];
  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true,
  );
  final ChatUser _currentUser =
      ChatUser(id: "1", firstName: "Mustapha", lastName: "Moukit");
  final ChatUser _gptChatUser =
      ChatUser(id: "2", firstName: "Morocco", lastName: "Explorer");
  List<ChatMessage> _messages = <ChatMessage>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar:  AppBar(
  backgroundColor: Colors.white,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Morocco",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black, // Couleur du texte
        ),
      ),
      SizedBox(width: 8), // Espacement entre le texte et l'image
      Container(
        padding: EdgeInsets.all(6), // Ajustez le padding selon vos besoins
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image(
            image: AssetImage('images/m.jpg'),
            width: 28,
            height: 28,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ],
  ),
  centerTitle: true,
  automaticallyImplyLeading: false,
),
      body: DashChat(
          messageOptions: const MessageOptions(
            currentUserContainerColor: Colors.black,
            containerColor: Color.fromRGBO(0, 166, 126, 1),
            textColor: Colors.white,
          ),
          currentUser: _currentUser,
          onSend: (ChatMessage m) {
            getChatResponse(m);
          },
          messages: _messages),
          bottomNavigationBar:HomeBottomBar(),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _typingUsers.add(_gptChatUser);
      _messages.insert(0, m);
    });
    List<Messages> _messagesHistory = _messages.reversed.map((m) {
      if (m.user == _currentUser) {
        return Messages(role: Role.user, content: m.text);
      } else {
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();
    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: _messagesHistory,
      maxToken: 200,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
              0,
              ChatMessage(
                user: _gptChatUser,
                createdAt: DateTime.now(),
                text: element.message!.content,
              ));
        });
      }
    }
    setState(() {
      _typingUsers.remove(_gptChatUser);
    }
    );
   
  }
}
