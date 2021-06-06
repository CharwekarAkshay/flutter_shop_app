import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  Badge(
      {Key? key,
      required this.child,
      required this.value,
      this.color = Colors.transparent})
      : super(key: key);

  final Widget? child;
  final String value;
  Color color;

  @override
  Widget build(BuildContext context) {
    // Assign Default color to badge
    if (color == Colors.transparent) this.color = Theme.of(context).accentColor;

    return Stack(
      alignment: Alignment.center,
      children: [
        child!,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color,
            ),
            constraints: BoxConstraints(
              maxHeight: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
