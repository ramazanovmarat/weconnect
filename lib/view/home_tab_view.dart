import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/post_model.dart';
import '../utils/constants.dart';
import 'chat_room.dart';
import 'create_post_view.dart';


OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20)
);

class HomeTabView extends StatefulWidget {
  const HomeTabView({Key? key}) : super(key: key);

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Главная', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: (){


                  final picker = ImagePicker();

                  picker.pickImage(source: ImageSource.gallery, imageQuality: 40).then((xFile){


                    if(xFile != null) {

                      final File file = File(xFile.path);

                      Navigator.of(context).pushNamed(
                        CreatePostView.id, arguments: file
                      );

                    }

                  });


                },
                icon: const Icon(Icons.add, color: Constants.kBlackColor,)
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasError) {
              return const Center(child: Text("Error"));
            }
            if(snapshot.connectionState == ConnectionState.waiting
            || snapshot.connectionState == ConnectionState.none) {
              return const Center(child: CircularProgressIndicator(
                color: Constants.kBlackColor,
              ));
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {

                final QueryDocumentSnapshot doc = snapshot.data!.docs[index];

                final Post post = Post(
                  imageURL: doc["imageUrl"],
                  userName: doc["userName"],
                  id: doc["postID"],
                  userID: doc["userID"],
                  description: doc["description"],
                  timestamp: doc["timestamp"]
                );

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(post.imageURL),
                            fit: BoxFit.cover
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        color: Colors.blueGrey,
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 5),
                            child: Column(
                              children: [
                                Text(post.userName, style: Theme.of(context).textTheme.headline5),
                                const Divider(thickness: 1, color: Constants.kBlackColor,)
                              ],
                            ),
                          ),
                          subtitle:  Text(post.description, style: const TextStyle(fontSize: 20, color: Constants.kPrimaryColor)),
                          trailing: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(ChatRoom.id, arguments: post);
                              },
                              child: const Icon(Icons.message_outlined, color: Constants.kBlackColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
                },
            );
          },
        ),
    );
  }
}
