import 'package:flutter/material.dart';

class LoadingSpinner{

  final BuildContext context;
  
  LoadingSpinner(this.context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=> AlertDialog(
        insetPadding: EdgeInsets.all(110),
        content: Container(
          height: 110,
          padding: const EdgeInsets.only(top: 15) ,
          child: Column(
            children: [
              CircularProgressIndicator(),
              Spacer(),
              Text('Please Wait...'),
            ],
          ),
        ),
      )
    );
  }
}
