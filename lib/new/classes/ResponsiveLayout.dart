import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class Responsivelayout extends StatelessWidget {
  const Responsivelayout({
    super.key,
    required this.builder,
    this.designSize = const Size(1920, 1080)
  });

  final Size designSize;
  final Widget Function(BuildContext context, Responsive responsive) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth,
          constraints.maxHeight
        );

        return builder(
          context,
          Responsive(
            size,
            designSize
          )
        );
      }
    );
  }
}

class Responsive {
  Responsive(this.size, this.designSize);

  final Size size;
  final Size designSize;

  double get scale =>
      math.min(size.width / designSize.width,
               size.height / designSize.height);

  double width(double value, {double? min, double? max})
  {
    final result = value * size.width / designSize.width;

    return clampDouble(
      result,
      min ?? 0,
      max ?? double.infinity
    );
  }

  double height(double value, {double? min, double? max})
  {
    final result = value * size.height / designSize.height;

    return clampDouble(
      result,
      min ?? 0,
      max ?? double.infinity
    );
  }

  /// Radius, Padding 등
  double radius(double value, {double? min, double? max})
  {
    final result = value * scale;

    return clampDouble(
      result,
      min ?? 0,
      max ?? double.infinity
    );
  }

  /// Font Size
  double sp(double value, {double? min, double? max})
  {
    final result = value * scale;
    
    return clampDouble(
      result,
      min ?? 0,
      max ?? double.infinity
    );
  }

  bool get isMobile => size.width < 600;
  bool get isTablet => size.width >= 600 && size.width < 1024;
  bool get isDesktop => size.width >= 1024;
}