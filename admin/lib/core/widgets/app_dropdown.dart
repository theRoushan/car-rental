import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class AppDropdown<T> extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final bool isExpanded;
  final String? errorText;
  final IconData? prefixIcon;

  const AppDropdown({
    super.key,
    required this.labelText,
    this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.isExpanded = true,
    this.errorText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      validator: validator,
      initialValue: value,
      builder: (FormFieldState<T> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                border: Border.all(
                  color: state.hasError || errorText != null
                      ? AppTheme.errorColor
                      : AppTheme.textLight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.defaultSpacing,
                ),
                child: Row(
                  children: [
                    if (prefixIcon != null) ...[
                      Icon(
                        prefixIcon,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: AppTheme.mediumSpacing),
                    ],
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<T>(
                          hint: Text(
                            hintText ?? 'Select ${labelText.toLowerCase()}',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          value: value,
                          items: items,
                          onChanged: (newValue) {
                            onChanged(newValue);
                            state.didChange(newValue);
                          },
                          isExpanded: isExpanded,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppTheme.primaryColor,
                          ),
                          style: AppTheme.bodyMedium,
                          borderRadius:
                              BorderRadius.circular(AppTheme.defaultRadius),
                          dropdownColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state.hasError || errorText != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  state.errorText ?? errorText ?? '',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.errorColor,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
} 