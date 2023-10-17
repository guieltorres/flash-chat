import 'package:flutter/material.dart';

class CircularIndicator extends StatefulWidget {
  final double height;
  final double width;

  const CircularIndicator({
    super.key,
    this.height = 20,
    this.width = 20,
  });

  @override
  State<CircularIndicator> createState() => _CircularIndicatorState();
}

class _CircularIndicatorState extends State<CircularIndicator> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          semanticsLabel: 'Circular progress indicator',
        ),
      ),
    );
  }
}
