import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry borderRadius;
  final double blurSigma;
  final double opacity;
  final double elevation;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.blurSigma = 16,
    this.opacity = 0.18,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final Color base = Theme.of(context).colorScheme.surface;
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          if (elevation > 0)
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            padding: padding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: base.withOpacity(opacity),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(opacity + 0.05),
                  Colors.white.withOpacity(opacity - 0.05),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
