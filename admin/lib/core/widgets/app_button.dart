import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

enum ButtonType { primary, secondary, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final bool isDisabled;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style;
    
    switch (type) {
      case ButtonType.primary:
        style = AppTheme.primaryButtonStyle;
        break;
      case ButtonType.secondary:
        style = AppTheme.secondaryButtonStyle;
        break;
      case ButtonType.text:
        style = AppTheme.textButtonStyle;
        break;
    }
    
    Widget button;
    
    if (icon != null) {
      button = _buildIconButton(style);
    } else {
      button = _buildButton(style);
    }
    
    if (isFullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    
    return button;
  }
  
  Widget _buildButton(ButtonStyle style) {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: style,
          child: _buildButtonContent(),
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: style,
          child: _buildButtonContent(),
        );
    }
  }
  
  Widget _buildIconButton(ButtonStyle style) {
    final content = _buildButtonContent();
    
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return ElevatedButton.icon(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: style,
          icon: Icon(icon),
          label: content,
        );
      case ButtonType.text:
        return TextButton.icon(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: style,
          icon: Icon(icon),
          label: content,
        );
    }
  }
  
  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    
    return Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: type == ButtonType.text ? 14 : 16,
      ),
    );
  }
} 