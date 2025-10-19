import 'package:e_commerce/core/providers/cart_provider.dart';
import 'package:e_commerce/core/providers/address_provider.dart';
import 'package:e_commerce/core/providers/order_provider.dart';
import 'package:e_commerce/shared/models/address.dart';
import 'package:e_commerce/features/profile/address_screen.dart';
import 'package:e_commerce/shared/widgets/cart_product_card.dart';
import 'package:e_commerce/shared/widgets/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late GlobalKey<FormState> _formKey;
  String _selectedPaymentMethod = 'Cash on Delivery';
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Consumer2<CartProvider, AddressProvider>(
        builder: (context, cartProvider, addressProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderSummary(cartProvider),
                  _buildContactInformation(),
                  const SizedBox(height: 24),
                  _buildPaymentMethod(),
                  const SizedBox(height: 24),
                  _buildAddressSelector(addressProvider),
                  const SizedBox(height: 24),
                  _buildTotalAndConfirm(cartProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddressSelector(AddressProvider addressProvider) {
    final addresses = addressProvider.addresses;
    final defaultAddress = addresses.isNotEmpty
        ? addresses.firstWhere(
            (a) => a.isDefault,
            orElse: () => addresses.first,
          )
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Address', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (defaultAddress == null)
          Card(
            child: ListTile(
              leading: Icon(Icons.location_off, color: Colors.grey),
              title: Text('No address added'),
              trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddressScreen()),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ),
          )
        else
          Card(
            child: ListTile(
              leading: Icon(Icons.location_on, color: Colors.green),
              title: Text(
                defaultAddress.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(defaultAddress.addressLine),
                  Text('${defaultAddress.city} • ${defaultAddress.postalCode}'),
                ],
              ),
              trailing: Text('Default', style: TextStyle(color: Colors.green)),
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: Icon(Icons.add_location_alt),
            label: Text('Manage Addresses'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddressScreen()),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildOrderSummary(CartProvider cartProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Summary', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: cartProvider.items.length,
          itemBuilder: (context, index) {
            final item = cartProvider.items[index];
            return CartProductCard(item: item, isFromCheckout: true);
          },
        ),
      ],
    );
  }

  Widget _buildContactInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        Card(
          child: RadioListTile<String>(
            title: Text(
              'Cash on Delivery',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              'Pay when you receive',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: 'Cash on Delivery',
            groupValue: _selectedPaymentMethod,
            onChanged: (String? value) {
              if (value != null) {
                setState(() => _selectedPaymentMethod = value);
              }
            },
          ),
        ),

        const SizedBox(height: 12),

        Card(
          child: RadioListTile<String>(
            title: Text(
              'Jazz Cash',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              'Pay via Jazz Cash wallet',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: 'Jazz Cash',
            groupValue: _selectedPaymentMethod,
            onChanged: (String? value) {
              if (value != null) {
                setState(() => _selectedPaymentMethod = value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTotalAndConfirm(CartProvider cartProvider) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        final addresses = addressProvider.addresses;
        final defaultAddress = addresses.isNotEmpty
            ? addresses.firstWhere(
                (a) => a.isDefault,
                orElse: () => addresses.first,
              )
            : null;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sub Total',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '\$${cartProvider.actualAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '\$${cartProvider.totalDiscount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grand Total',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '\$${cartProvider.discountedAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (defaultAddress == null) {
                    SnackbarHelper.info(
                      context: context,
                      title: 'Address Required',
                      message: 'Please add a delivery address to continue.',
                    );
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    _confirmOrder(context, defaultAddress);
                  }
                },
                child: Text('Confirm Order'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmOrder(BuildContext context, Address? address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Order'),
        content: Text('Are you sure you want to place this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processOrder(context);
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _processOrder(BuildContext context) {
    final cartProvider = context.read<CartProvider>();
    final addressProvider = context.read<AddressProvider>();
    final orderProvider = context.read<OrderProvider>();
    final addresses = addressProvider.addresses;
    final selectedAddress = addresses.isNotEmpty
        ? addresses.firstWhere(
            (a) =>
                a.id ==
                (_selectedAddressId ??
                    addresses
                        .firstWhere(
                          (ad) => ad.isDefault,
                          orElse: () => addresses.first,
                        )
                        .id),
            orElse: () => addresses.first,
          )
        : null;

    // Add order to history
    if (selectedAddress != null && cartProvider.items.isNotEmpty) {
      orderProvider.addOrder(
        items: List.from(cartProvider.items),
        total: cartProvider.discountedAmount,
        address: selectedAddress,
        paymentMethod: _selectedPaymentMethod,
      );
    }

    SnackbarHelper.success(
      context: context,
      title: 'Success',
      message: 'Your order has been placed successfully!',
    );

    cartProvider.clearCart();
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
