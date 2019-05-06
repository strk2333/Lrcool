import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirm;

  CustomAlertDialog(this.title, this.content, {this.confirm});

  @override
  Widget build(BuildContext context) {
    var confirmText = confirm;
    if (confirmText == null) {
      confirmText = "Close";
    }

    return AlertDialog(
      title: Text(this.title),
      content: Text(this.content),
      actions: <Widget>[
        FlatButton(
          child: Text(confirmText),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}