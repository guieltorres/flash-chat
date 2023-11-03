import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;
  final String description;
  final String approveText;
  final String denyText;
  final VoidCallback? onPress;

  const Alert({
    Key? key,
    required this.title,
    required this.description,
    this.approveText = "OK",
    this.denyText = "Cancel",
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(28),
        ),
      ),
      title: Text(title),
      content: Text(description),
      alignment: Alignment.bottomCenter,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(denyText),
        ),
        TextButton(
          onPressed: onPress ?? () => Navigator.pop(context, 'ok'),
          child: Text(approveText),
        ),
      ],
    );
  }
}
