import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum DialogsAction { yes, cancel}

class AlertDialogs {
  static Future<DialogsAction> yesCancelDialog(
      BuildContext context,
      String title,
      String body,
      ) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext  context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            title: Text(title,),
            content: Text(body),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop(DialogsAction.cancel);
                  },
                  child: Text(
                    'cancel',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),
                  )),
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop(DialogsAction.yes);
                  },
                  child: Text(
                    'confirm',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),
                  ))
            ],
          );
        });
    return (action != null) ? action : DialogsAction.cancel;
  }
}
