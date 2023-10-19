import 'package:flash_chat_v2/components/CircularIndicator.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String title;
  final void Function()? onPressed;
  final bool isLoading;

  const RoundedButton({
    super.key,
    required this.color,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: isLoading ? null : onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: isLoading
              ? const CircularIndicator()
              : Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
