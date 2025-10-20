import 'dart:convert';
import 'package:http/http.dart' as http;
import 'email_service.dart';

class EmailJsService implements EmailService {
  final String serviceId;
  final String templateId;
  final String userId; 

  EmailJsService({
    required this.serviceId,
    required this.templateId,
    required this.userId,
  });

  @override
  Future<bool> sendOrderConfirmation({
    required String toEmail,
    required String customerName,
    required String orderId,
    required String itemsSummary,
    required double total,
    required String address,
    required String paymentMethod,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final payload = {
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'to_email': toEmail,
        'to_name': customerName,
        'order_id': orderId,
        'items': itemsSummary,
        'total': total.toStringAsFixed(2),
        'address': address,
        'payment_method': paymentMethod,
      }
    };

    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      ).timeout(Duration(seconds: 10));

      return resp.statusCode >= 200 && resp.statusCode < 300;
    } catch (_) {
      return false;
    }
  }
}
