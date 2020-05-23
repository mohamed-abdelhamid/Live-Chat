import 'package:flash_chat/components/optionButton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  String email, pass;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false ;



  void showAlert({title , titleColor , desc , type}) => Alert(
        context: context,
        type: type,
        title: title,
        desc: desc,
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
          descStyle: TextStyle(color: Colors.white),
          titleStyle: TextStyle(color: titleColor),
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
              image: AssetImage('images/logo4.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                  decoration:
                      kInputDecoration('Username', FontAwesomeIcons.signature),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                child: TextField(
                  onChanged: (value) {
                    pass = value;
                  },
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                  obscureText: true,
                  textAlign: TextAlign.justify,
                  decoration:
                      kInputDecoration('Password', FontAwesomeIcons.lockOpen),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: OptionButton(
                  icon: FontAwesomeIcons.handshake,
                  heroTag: 'registerButton',
                  option: 'Register',
                  widthRequired: 100.0,
                  onPressed: () async {
                    setState(() {
                      this.showSpinner = true;
                    });
                    try {
                      final newUser = await _auth.createUserWithEmailAndPassword(
                          email: email, password: pass);
                      if (newUser != null) {
                        Navigator.pushNamed(context, '/login');
                        showAlert(
                          type: AlertType.success,
                          title: "Registered Successfuly!",
                          titleColor: Colors.green,
                          desc: "please login",
                        );
                        setState(() {
                          this.showSpinner = false;
                        });
                      }
                    } catch (e) {
                      print(e);
                      showAlert(
                        type: AlertType.error,
                        title: "invalid username or password",
                        titleColor: Colors.red,
                        desc: "username should be like example@template.com\n"
                            "password should contain at least 6 characters",
                      );
                      setState(() {
                        this.showSpinner = false;
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
        ),
      ),
    );
  }


}
