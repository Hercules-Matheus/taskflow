import 'package:flutter/material.dart';

class FabVerticalDelegate extends FlowDelegate {
  final AnimationController animation;

  FabVerticalDelegate({required this.animation}) : super(repaint: animation);

  @override
  void paintChildren(FlowPaintingContext context) {
    const btnSize = 56;
    const btnRadius = btnSize / 2;
    const btnMargin = 10;

    final dy = context.size.height - btnSize - 3;
    final dx = context.size.width - btnSize;
    final lastFabIndex = context.childCount - 1;

    for (int i = lastFabIndex; i >= 0; i--) {
      final y = dy - ((btnSize + btnMargin) * i * animation.value);
      final size = (i != 0) ? animation.value : 1.0;

      context.paintChild(i,
          transform: Matrix4.translationValues(dx, y, 0)
            ..translate(btnRadius, btnRadius)
            ..scale(size)
            ..translate(-btnRadius, -btnRadius));
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}
