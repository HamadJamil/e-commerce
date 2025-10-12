// lib/core/utils/snackbar_helper.dart
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class SnackbarHelper {
  SnackbarHelper._();
  static void success({
    required BuildContext context,
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 2),
    Alignment alignment = Alignment.topRight,
    bool showProgressBar = true,
  }) {
    _showToast(
      context: context,
      title: title,
      message: message,
      type: ToastificationType.success,
      duration: duration,
      alignment: alignment,
      showProgressBar: showProgressBar,
      primaryColor: Colors.green,
    );
    clearAll(context);
  }

  static void error({
    required BuildContext context,
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 2),
    Alignment alignment = Alignment.topRight,
    bool showProgressBar = true,
  }) {
    _showToast(
      context: context,
      title: title,
      message: message,
      type: ToastificationType.error,
      duration: duration,
      alignment: alignment,
      showProgressBar: showProgressBar,
      primaryColor: Colors.red,
    );
    clearAll(context);
  }

  static void info({
    required BuildContext context,
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 2),
    Alignment alignment = Alignment.topRight,
    bool showProgressBar = false,
  }) {
    _showToast(
      context: context,
      title: title,
      message: message,
      type: ToastificationType.info,
      duration: duration,
      alignment: alignment,
      showProgressBar: showProgressBar,
      primaryColor: Colors.blue,
    );
    clearAll(context);
  }

  static void _showToast({
    required BuildContext context,
    required String title,
    required String? message,
    required ToastificationType type,
    required Duration duration,
    required Alignment alignment,
    required bool showProgressBar,
    required Color primaryColor,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: duration,
      title: Text(title),
      description: message != null ? Text(message) : null,
      alignment: alignment,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      showProgressBar: showProgressBar,
      primaryColor: primaryColor,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
      closeOnClick: true,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }

  static void clearAll(BuildContext context) {
    toastification.dismissAll();
  }
}
