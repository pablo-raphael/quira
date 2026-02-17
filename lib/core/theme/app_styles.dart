import 'package:flutter/material.dart';
import 'package:quira/core/theme/app_font_sizes.dart';
import 'package:quira/core/theme/app_theme.dart';

class AppStyles {
  AppStyles._();

  static const TextStyle title = TextStyle(
    fontSize: AppFontSizes.body,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle mutedSmall = TextStyle(
    color: AppTheme.muted,
    fontSize: AppFontSizes.caption,
  );

  static const TextStyle whiteSemiBold = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle answerLabel = TextStyle(
    color: AppTheme.muted,
    fontWeight: FontWeight.w600,
    fontSize: AppFontSizes.caption,
  );
}
