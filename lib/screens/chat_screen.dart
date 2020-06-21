import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/messageContainer.dart';

final _fireStore = Firestore.instance;
FirebaseUser loggedInUser ;
String awayUsername ;

class ChatScreen extends StatefulWidget {

  ChatScreen(username, loggedUser){
    loggedInUser = loggedUser ;
    awayUsername = username ;
  }

  @override
  _ChatScreenState createState() => _ChatScreenState();
}



class _ChatScreenState extends State<ChatScreen> {


  final inputController = TextEditingController();
  String messageText ;

  addMessageToChat() {
    inputController.clear();

    /** add message to logged in user's chat **/
    _fireStore.collection('user_data')
        .document(loggedInUser.email)
        .collection('messages')
        .document(awayUsername)
        .collection('chat')
        .add({
      'sender' : loggedInUser.email,
      'message' : messageText,
      'time': DateTime.now(),
    });

    /** add message to the other user's chat **/
    _fireStore.collection('user_data')
        .document(awayUsername)
        .collection('messages')
        .document(loggedInUser.email)
        .collection('chat')
        .add({
      'sender' : loggedInUser.email,
      'message' : messageText,
      "time": DateTime.now(),
    });

  }



//  messagesStream() async {
//    await for(var snapshot in _fireStore.collection('messages').snapshots()){
//      for(var messages in snapshot.documents){
//        print(messages.data);
//      }
//    }
//  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(
          '⚡️Chat',
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              MessagesStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: inputController,
                        onChanged: (value) {
                          messageText = value ;
                        },
                        style: TextStyle(fontSize: 20.0),
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: addMessageToChat,
                      child: Text(
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('user_data')
          .document(loggedInUser.email)
          .collection('messages')
          .document(awayUsername)
          .collection('chat').snapshots(),
      builder: (context , snapshot){
        if (!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final documents = snapshot.data.documents;
        List<MessageContainer> chatMessages = [] ;
        for(var document in documents){
          final message = document.data['message'];
          final sender = document.data['sender'];
          final messageTime = document.data["time"];
          final messageWidget = MessageContainer(
            text: message,
            time: messageTime,
            isMe: loggedInUser.email == sender ,
          );
          chatMessages.add(messageWidget);
          chatMessages.sort((a , b) => b.time.compareTo(a.time));
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: chatMessages,
          ),
        );
      },
    );
  }
}
