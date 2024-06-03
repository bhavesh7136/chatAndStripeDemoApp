import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:flutter_chat_bubble/chat_bubble.dart";

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> map;


  const ChatPage({super.key, required this.map});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController txtMessageController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? chatRoomId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatRoomId = chatRoomIdGet(
        _auth.currentUser!.uid,
        widget.map['id']);
  }

  String chatRoomIdGet(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }
  Future<void> onSendMessage() async {
    if (txtMessageController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": txtMessageController.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.uid);
      txtMessageController.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
      listScrollController
          .jumpTo(listScrollController.position.maxScrollExtent);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.map['nickname']),
      ),
      body: Column(
        children: [
          buildListMessage(),
          buildInput(),
        ],
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chatroom')
            .doc(chatRoomId)
            .collection('chats')
            .orderBy("time", descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              controller: listScrollController,
              itemBuilder: (context, index) {
                Map<String, dynamic> map =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return buildItem(map);
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildItem(Map<String, dynamic> map) {
    if (map['sendby'] == _auth.currentUser!.displayName) {
      return ChatBubble(
        clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: Colors.blue,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            map['message'],
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      // Left (peer message)
      return ChatBubble(
        clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
        backGroundColor: Colors.grey[300],
        margin: const EdgeInsets.only(top: 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            map['message'],
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );
    }
  }

  Widget buildInput() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 10),
            Flexible(
              child: TextField(
                style:
                    const TextStyle(color: Color(0xff203152), fontSize: 15.0),
                controller: txtMessageController,
                decoration: const InputDecoration(
                    hintText: "Type your message...",
                    hintStyle: TextStyle(color: Color(0xffaeaeae)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide:
                          BorderSide(color: Color(0xFF0D8898), width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide:
                          BorderSide(color: Color(0xFF0D8898), width: 2.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                    fillColor: Colors.white),
              ),
            ),
            // Button send message
            Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xFF0D8898),
                  ),
                  onPressed: () => onSendMessage(),
                  color: const Color(0xff203152),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
