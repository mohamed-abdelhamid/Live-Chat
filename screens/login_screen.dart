import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/components/optionButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String email , pass ;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false ;

  void showAlert() => Alert(
    context: context,
    type: AlertType.warning,
    title: "wrong email or password",
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
      titleStyle: TextStyle(color: Colors.yellow[800]),
    ),
  ).show();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/logo2.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20.0 , right: 20.0 , bottom: 5.0),
                child: TextField(
                  onChanged: (value){
                    email = value ;
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                  decoration: kInputDecoration('Username',FontAwesomeIcons.signature),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0 , right: 20.0 , bottom: 5.0),
                child: TextField(
                  onChanged: (value){
                    pass = value ;
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                  obscureText: true,
                  textAlign: TextAlign.justify,
                  decoration: kInputDecoration('Password',FontAwesomeIcons.lockOpen),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: OptionButton(
                  icon: FontAwesomeIcons.key,
                  heroTag: 'loginButton',
                  option: 'Login',
                  widthRequired: 110.0,
                  onPressed: () async {
                    setState(() {
                      this.showSpinner = true;
                    });
                    try{
                      final user = await _auth.signInWithEmailAndPassword(email: email, password: pass);
                      if (user != null){
                         Navigator.pushNamed(context, '/contacts');
                       }
                      setState(() {
                        this.showSpinner = false;
                      });
                    }catch(e){
                      print(e);
                      showAlert();
                      setState(() {
                        this.showSpinner = false;
                      });
                    }
                  },
                )
              ),
              SizedBox(height: 40.0,),
            ],
          ),
        ),
      ),
    );
  }
}
