import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    bottom: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

kInputDecoration(String type, temp) => InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      hintText: type,
      prefixIcon: Icon(
        temp,
        color: Colors.black,
        size: 20,
      ),
      hintStyle: TextStyle(
        color: Colors.black,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      fillColor: Colors.white,
      filled: true,
    );
