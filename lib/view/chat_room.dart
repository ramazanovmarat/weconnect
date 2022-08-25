import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../models/post_model.dart';
import '../utils/constants.dart';
import '../widgets/message_list_tile.dart';

class ChatRoom extends StatefulWidget {

  static const String id = "chat_room";

  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;

  String _message = "";

  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Post post = ModalRoute.of(context)!.settings.arguments as Post;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Чат", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("posts").doc(post.id).collection("chat").orderBy("timeStamp").snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasError) {
                    return const Center(child: Text("Error"));
                  }
                  if(snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.connectionState == ConnectionState.none) {
                    return const Center(child: CircularProgressIndicator(
                      color: Constants.kBlackColor,
                    ));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {

                      final QueryDocumentSnapshot doc = snapshot.data!.docs[index];

                      final ChatModel chatModel = ChatModel(
                          userName: doc["userName"],
                          userId: doc["userId"],
                          message: doc["message"],
                          timestamp: doc["timeStamp"],
                      );

                      return Align(
                        alignment: chatModel.userId == currentUserID
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                          child: MessageListTile(chatModel: chatModel)
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _textEditingController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: "Сообщение",
                        ),
                        onChanged: (value) {
                          _message = value;
                        },
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    FirebaseFirestore.instance.collection("posts").doc(post.id).collection("chat").add({
                      "userId" : FirebaseAuth.instance.currentUser!.uid,
                      "userName" : FirebaseAuth.instance.currentUser!.displayName,
                      "message" : _message,
                      "timeStamp" : Timestamp.now(),
                    });

                    _textEditingController.clear();

                    setState(() {
                      _message = "";
                    });

                  },
                      icon: const Icon(Icons.arrow_forward_ios)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
