import 'package:flutter/material.dart';

void customDialog(BuildContext context,
    {required String title, required String content}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          // TextButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   child: Text('Cancel'),
          // ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok'),
          ),
        ],
      );
    },
  );
}
