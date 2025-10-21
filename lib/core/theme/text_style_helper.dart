import 'package:flutter/material.dart';

class TextStyleHelper {
  static TextStyle? displayLarge(BuildContext context) =>
      Theme.of(context).textTheme.displayLarge;

  static TextStyle? displayMedium(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium;

  static TextStyle? displaySmall(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall;

  static TextStyle? headlineLarge(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge;

  static TextStyle? headlineMedium(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium;

  static TextStyle? headlineSmall(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall;

  static TextStyle? titleLarge(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge;

  static TextStyle? titleMedium(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium;

  static TextStyle? titleSmall(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall;

  static TextStyle? bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge;

  static TextStyle? bodyMedium(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium;

  static TextStyle? bodySmall(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall;

  static TextStyle? labelLarge(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge;

  static TextStyle? labelMedium(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium;

  static TextStyle? labelSmall(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall;

  
  static TextStyle? pageTitle(BuildContext context) =>
      headlineMedium(context)?.copyWith(fontWeight: FontWeight.bold);

  static TextStyle? sectionTitle(BuildContext context) =>
      titleLarge(context)?.copyWith(fontWeight: FontWeight.w600);

  static TextStyle? productTitle(BuildContext context) =>
      titleMedium(context)?.copyWith(fontWeight: FontWeight.w500);

  static TextStyle? productPrice(BuildContext context) =>
      titleSmall(context)?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      );

  static TextStyle? caption(BuildContext context) =>
      bodySmall(context)?.copyWith(color: Colors.grey);

  static TextStyle? button(BuildContext context) =>
      labelLarge(context)?.copyWith(fontWeight: FontWeight.w600);
}

extension TextThemeCompat on TextTheme {
  TextStyle? get headline1 => displayLarge;
  TextStyle? get headline2 => displayMedium;
  TextStyle? get headline3 => displaySmall;
  TextStyle? get headline4 => headlineLarge;
  TextStyle? get headline5 => headlineMedium;
  TextStyle? get headline6 => headlineSmall;
  TextStyle? get subtitle1 => titleMedium;
  TextStyle? get subtitle2 => titleSmall;
  TextStyle? get bodyText1 => bodyLarge;
  TextStyle? get bodyText2 => bodyMedium;
  TextStyle? get caption => bodySmall;
  TextStyle? get button => labelLarge;
  TextStyle? get overline => labelSmall;
}
