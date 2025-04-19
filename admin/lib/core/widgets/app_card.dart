import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: margin ?? const EdgeInsets.all(AppTheme.mediumSpacing),
      elevation: elevation ?? 1,
      color: backgroundColor ?? AppTheme.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.defaultRadius),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppTheme.defaultSpacing),
        child: child,
      ),
    );
    
    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius is BorderRadius
              ? borderRadius as BorderRadius
              : BorderRadius.circular(AppTheme.defaultRadius),
          child: card,
        ),
      );
    }
    
    return card;
  }
} 