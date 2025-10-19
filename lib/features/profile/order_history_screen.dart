import 'package:e_commerce/core/providers/order_provider.dart';
import 'package:e_commerce/features/profile/order_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order History')),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final orders = orderProvider.orders;
          if (orders.isEmpty) {
            return Center(
              child: Text('No previous orders'),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                child: ListTile(
                  title: Text('Order #${order.id.substring(0, 8)}'),
                  subtitle: Text(
                    '${order.items.length} items\n${order.address.addressLine}, ${order.address.city}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Total: \$${order.total.toStringAsFixed(2)}'),
                      Text(
                        '${order.date.day}/${order.date.month}/${order.date.year}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
