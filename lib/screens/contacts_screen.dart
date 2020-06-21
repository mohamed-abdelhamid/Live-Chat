import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'chat_screen.dart';

final _fireStore = Firestore.instance;
final _auth = FirebaseAuth.instance;
FirebaseUser loggedInUser;

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {

  @override
  void initState() {
    super.initState();
    getUser();
  }

  final inputController = TextEditingController();
  String messageText, username;
  bool visible = false, showSpinner = false;

  void showTextField() {
    setState(() {
      this.visible = true;
    });
  }

  void showAlert() => Alert(
        context: context,
        type: AlertType.error,
        title: 'username doesn\'t Exist',
        buttons: [
          DialogButton(
            child: Text(
              "Alright",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
            color: Colors.lightBlue,
          )
        ],
        style: AlertStyle(
          backgroundColor: Colors.black,
          titleStyle: TextStyle(color: Colors.red),
        ),
      ).show();

  Future<bool> isExist(String username) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: username, password: 'password');
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') return true;
      }
    }
    return false;
  }

  Future<void> addNewContact(String otherUserID) async {
    setState(() {
      showSpinner = true;
    });

    bool exist = await isExist(otherUserID);
    if (!exist) {
      showAlert();
      setState(() {
        showSpinner = false;
      });
      return;
    }

    final CollectionReference userRef =
        Firestore.instance.collection('user_data');
    var userID = loggedInUser.email;
    /** add contact to logged in user **/
    await userRef
        .document(userID)
        .collection('contacts')
        .document(otherUserID)
        .setData({
      'username': otherUserID,
    });

    /** add contact to the other user **/
    await userRef
        .document(otherUserID)
        .collection('contacts')
        .document(userID)
        .setData({
      'username': userID,
    });
    setState(() {
      this.visible = false;
      showSpinner = false;
    });
  }


  getUser() async {
    setState(() {
      showSpinner = true;
    });
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
      Navigator.pushNamed(context, '/login');
    }
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, '/login');
              }),
        ],
        title: Text(
          'contacts',
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          color: Colors.white,
          child: SafeArea(
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Column(
                children: <Widget>[
                  ContactStream(),
                  Visibility(
                    visible: visible,
                    replacement: FloatingActionButton(
                      onPressed: showTextField,
                      backgroundColor: Colors.lightBlue,
                      child: Icon(Icons.add),
                    ),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: kInputDecoration(
                                'Username...', CupertinoIcons.person_add_solid),
                            onChanged: (value) {
                              this.username = value;
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(CupertinoIcons.add_circled),
                          onPressed: () => addNewContact(username),
                          color: Colors.white,
                          iconSize: 40.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContactStream extends StatelessWidget {

  String cutUserName(String username) {
    try{
      int indexOfLastChar = username.indexOf('@');
      return username.substring(0, indexOfLastChar);
    }catch(e){ return null ; }
  }


  nonEmptyWidget(String name){
    if (name == null ) return Column();
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Icon(
                CupertinoIcons.person_solid,
                color: Colors.lightBlueAccent,
                size: 35.0,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 1.5, color: Colors.blue),
              ),
              margin: EdgeInsets.only(right: 12.0),
            ),
            Flexible(
              child: Text(
                cutUserName(name),
                style: TextStyle(
                    fontSize: 30, color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('user_data')
          .document(loggedInUser.email)
          .collection('contacts')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final documents = snapshot.data.documents;
        List<Material> contacts = [];
        for (var document in documents) {
          final username = document.data['username'];
          final contactWidget = Material(
            color: Colors.black,
            child: InkWell(
              onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return ChatScreen(username , loggedInUser);
              }));
              },
              child: Container(
                decoration: kMessageContainerDecoration,
                padding: EdgeInsets.all(8.0),
                child: nonEmptyWidget(username),
              ),
            ),
          );
          contacts.add(contactWidget);
        }
        return Expanded(
          child: ListView(
            children: contacts,
          ),
        );
      },
    );
  }
}
