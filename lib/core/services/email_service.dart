abstract class EmailService {
  /// Sends an order confirmation email to [toEmail].
  /// Returns true on success, false otherwise.
  Future<bool> sendOrderConfirmation({
    required String toEmail,
    required String customerName,
    required String orderId,
    required String itemsSummary,
    required double total,
    required String address,
    required String paymentMethod,
  });
}
