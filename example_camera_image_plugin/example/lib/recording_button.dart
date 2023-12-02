import 'dart:math';

import 'package:flutter/material.dart';

class RecordingButton extends StatelessWidget {
  final bool isRecording;
  final void Function() onPressed;

  const RecordingButton({
    super.key,
    required this.isRecording,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final minDimension = min(constraints.maxHeight, constraints.maxWidth);
      final borderRadius = minDimension / 2;
      final dotDimension = minDimension / 4;
      final double dotRadius = isRecording ? 2 : dotDimension / 2;

      return Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        elevation: 5,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              constraints: BoxConstraints.tight(Size.square(dotDimension)),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(dotRadius),
              ),
            ),
          ),
        ),
      );
    });
  }
}
