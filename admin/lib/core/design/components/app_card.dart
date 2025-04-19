import 'package:flutter/material.dart';
import '../design_tokens.dart';

enum AppCardVariant {
  elevated,
  outlined,
  filled
}

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isError;
  final String? errorMessage;
  final bool isSuccess;
  final String? successMessage;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
    this.isSuccess = false,
    this.successMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine card style based on variant
    final Color bgColor;
    final double elevation;
    final BorderSide borderSide;
    
    switch (variant) {
      case AppCardVariant.elevated:
        bgColor = backgroundColor ?? theme.cardTheme.color!;
        elevation = 1;
        borderSide = BorderSide.none;
        break;
      case AppCardVariant.outlined:
        bgColor = backgroundColor ?? theme.cardTheme.color!;
        elevation = 0;
        borderSide = BorderSide(
          color: theme.dividerColor,
          width: 1,
        );
        break;
      case AppCardVariant.filled:
        bgColor = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
        elevation = 0;
        borderSide = BorderSide.none;
        break;
    }

    Widget content = Padding(
      padding: padding ?? const EdgeInsets.all(DesignTokens.spaceMD),
      child: child,
    );

    // Add loading indicator
    if (isLoading) {
      content = Stack(
        children: [
          content,
          Positioned.fill(
            child: Container(
              color: theme.colorScheme.surface.withOpacity(0.7),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Add error/success messages if present
    if (isError && errorMessage != null || isSuccess && successMessage != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          content,
          if (isError && errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(DesignTokens.spaceMD),
              decoration: BoxDecoration(
                color: DesignTokens.error.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(DesignTokens.radiusMD),
                  bottomRight: Radius.circular(DesignTokens.radiusMD),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: DesignTokens.error,
                    size: 20,
                  ),
                  const SizedBox(width: DesignTokens.spaceSM),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: DesignTokens.bodySmall.copyWith(
                        color: DesignTokens.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (isSuccess && successMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(DesignTokens.spaceMD),
              decoration: BoxDecoration(
                color: DesignTokens.success.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(DesignTokens.radiusMD),
                  bottomRight: Radius.circular(DesignTokens.radiusMD),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: DesignTokens.success,
                    size: 20,
                  ),
                  const SizedBox(width: DesignTokens.spaceSM),
                  Expanded(
                    child: Text(
                      successMessage!,
                      style: DesignTokens.bodySmall.copyWith(
                        color: DesignTokens.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    final card = Card(
      margin: margin ?? EdgeInsets.zero,
      elevation: elevation,
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(DesignTokens.radiusMD),
        side: borderSide,
      ),
      child: content,
    );

    if (onTap != null) {
      return InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: (borderRadius as BorderRadius?) ?? BorderRadius.circular(DesignTokens.radiusMD),
        child: card,
      );
    }

    return card;
  }
} 