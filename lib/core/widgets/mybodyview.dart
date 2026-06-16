import 'package:flutter/material.dart';

class MyBodyView extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const MyBodyView({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}
