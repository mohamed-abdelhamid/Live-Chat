import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  const OptionButton({
    Key key,
    this.controller,
    @required this.option,
    @required this.icon,
    @required this.onPressed,
    @required this.heroTag,
    @required this.widthRequired,
  }) : super(key: key);

  final AnimationController controller;
  final String heroTag , option;
  final double widthRequired;
  final icon ;
  final Function onPressed ;

  @override
  Widget build(BuildContext context) {


    return Material(
      elevation: 5.0,
      color: Colors.lightBlue,
      borderRadius: BorderRadius.circular(10.0),
      child: MaterialButton(
        onPressed: onPressed ,
        minWidth: 200.0,
        height: 60.0,
        child: Hero(
          tag: heroTag,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
              ),
              SizedBox(
                width: controller == null ? widthRequired : controller.value * widthRequired,
              ),
              Text(
                option,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
