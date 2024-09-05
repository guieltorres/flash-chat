import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_v2/components/Alert.dart';
import 'package:flash_chat_v2/components/CircularIndicator.dart';
import 'package:flash_chat_v2/components/MessageBubble.dart';
import 'package:flash_chat_v2/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late User loggedInUser;
late bool hasError;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    hasError = false;
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void logout() {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => Alert(
                  title: "Quick Check",
                  description: "Ready to sign off?",
                  approveText: "Log Out",
                  denyText: "Not Yet",
                  onPress: () => logout(),
                ),
              ),
            ),
          ],
          title: const Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const MessagesStream(),
              if (hasError == false)
                Container(
                  decoration: kMessageContainerDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageTextController,
                          onChanged: (value) {
                            messageText = value;
                          },
                          decoration: kMessageTextFieldDecoration,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          messageTextController.clear();
                          _firestore.collection("messages").add({
                            "text": messageText,
                            "sender": loggedInUser.email,
                            "timestamp": Timestamp.now(),
                          });
                        },
                        child: const Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    final stream = _firestore
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();

    stream.listen((snapshot) {
      for (var document in snapshot.docs) {
        print(document.data());
      }
    });

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          hasError = true;
          return const Expanded(
            child: Center(
              child: Text(
                'Something went wrong 😭',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Expanded(
            child: Center(
              child: CircularIndicator(),
            ),
          );
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children:
                snapshot.data!.docs.reversed.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return MessageBubble(
                  sender: data["sender"],
                  text: data["text"],
                  isMe: data["sender"] == loggedInUser.email);
            }).toList(),
          ),
        );
      },
    );
  }
}
