import 'package:flutter/material.dart';
import 'package:social_media_app/constants.dart';

void toast(BuildContext context, String message, [Color? color = Colors.red])
{
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
      backgroundColor: color == Colors.red ? kRedColor : color,
      duration: Duration(seconds: 2),
    ),
  );
}