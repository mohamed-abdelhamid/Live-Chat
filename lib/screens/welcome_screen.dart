import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flash_chat/components/optionButton.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation animation;

  @override
  void dispose() {
    // this is the distrctr
    controller.dispose(); // end controller
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: 16.0,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();
    controller.addListener(() {
      //print(controller.value); // to see how controller rise from 0.0 to 16.0
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/logo2.png'),
            fit: BoxFit.cover,
            //colorFilter: new ColorFilter.mode(Colors.blue.withOpacity(controller.value), BlendMode.dstIn),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(controller.value),
              child: OptionButton(
                controller: controller,
                icon: FontAwesomeIcons.doorOpen,
                heroTag: 'loginButton',
                option: 'Login',
                widthRequired: 7.0,
                onPressed: (){
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(controller.value),
              child: OptionButton(
                controller: controller,
                icon: FontAwesomeIcons.handshake,
                heroTag: 'registerButton',
                option: 'Register',
                widthRequired: 6.0,
                onPressed: (){
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ),
            SizedBox(
              height: controller.value * 5,
            ),
          ],
        ),
      ),
    );
  }
}
