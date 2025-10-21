import 'package:e_commerce/shared/models/order.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Order #${order.id.substring(0, 8)}', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text('Date: ${order.date.day}/${order.date.month}/${order.date.year}'),
            SizedBox(height: 8),
            Text('Payment: ${order.paymentMethod}'),
            SizedBox(height: 8),
            Text('Delivery Address:', style: Theme.of(context).textTheme.titleMedium),
            Text(order.address.name),
            Text(order.address.addressLine),
            Text('${order.address.city} • ${order.address.postalCode}'),
            Divider(height: 32),
            Text('Items:', style: Theme.of(context).textTheme.titleMedium),
            ...order.items.map((item) => ListTile(
              title: Text(item.product.title),
              subtitle: Text('Qty: ${item.quantity}'),
              trailing: Text('PKR${item.product.discountedPrice.toStringAsFixed(2)}'),
            )),
            Divider(height: 32),
            Text('Total: PKR${order.total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
