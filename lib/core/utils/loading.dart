import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Color? color;
  const Loading({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25,
      height: 25,
      child: CircularProgressIndicator(
        color: color ?? Colors.white,
      ),
    );
  }
}
