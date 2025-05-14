import 'package:flutter/material.dart';

class ParallaxBox extends StatelessWidget {
  final Widget child;

  const ParallaxBox({
    super.key,
    required this.child,
    required int height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 225, 255, 219),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
