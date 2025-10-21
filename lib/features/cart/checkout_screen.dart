import 'package:e_commerce/core/providers/auth_provider.dart';
import 'package:e_commerce/core/providers/cart_provider.dart';
import 'package:e_commerce/core/providers/address_provider.dart';
import 'package:e_commerce/core/providers/order_provider.dart';
import 'package:e_commerce/core/services/email_service.dart';
import 'package:e_commerce/features/payment/jazzcash_payment_screen.dart';
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
  bool _useAccountPhone = false;
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    final userEmail = context.read<AuthenticationProvider>().currentUser?.email;
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _emailController.text = userEmail ?? '';
    _phoneController = TextEditingController();
    final userModel = context.read<AuthenticationProvider>().userModel;
    if (userModel != null && userModel.phones.isNotEmpty) {
      _useAccountPhone = true;
      _phoneController.text = userModel.phones.first;
    }
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
          enabled: false,
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          enabled: !_useAccountPhone,
          decoration: InputDecoration(
            prefix: Text('+92 '),
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length < 10 || value.length > 11) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Checkbox(
              value: _useAccountPhone,
              onChanged: (v) {
                setState(() {
                  _useAccountPhone = v ?? false;
                  if (_useAccountPhone) {
                    final userModel = context
                        .read<AuthenticationProvider>()
                        .userModel;
                    _phoneController.text =
                        (userModel != null && userModel.phones.isNotEmpty)
                        ? userModel.phones.first
                        : '';
                  } else {
                    _phoneController.clear();
                  }
                });
              },
            ),
            Expanded(child: Text('Use account phone for this order')),
          ],
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
                  'PKR${cartProvider.actualAmount.toStringAsFixed(0)}',
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
                  'PKR${cartProvider.totalDiscount.toStringAsFixed(2)}',
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
                  'PKR${cartProvider.discountedAmount.toStringAsFixed(2)}',
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
            onPressed: () async {
              await _processOrder(context);
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _processOrder(BuildContext context) async {
    final cartProvider = context.read<CartProvider>();
    final addressProvider = context.read<AddressProvider>();
    final orderProvider = context.read<OrderProvider>();
    final emailService = context.read<EmailService?>();
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

    if (selectedAddress != null && cartProvider.items.isNotEmpty) {
      try {
        final order = await orderProvider.addOrder(
          items: List.from(cartProvider.items),
          total: cartProvider.discountedAmount,
          address: selectedAddress,
          paymentMethod: _selectedPaymentMethod,
        );
        final email = _emailController.text.trim();
        final itemsSummary = cartProvider.items
            .map((c) => '${c.product.title} x${c.quantity}')
            .join('\n');

        // If Jazz Cash is selected, open payment webview and send confirmation only after payment success.
        if (_selectedPaymentMethod == 'Jazz Cash') {
          final merchantId = 'MC415731';
          final password = 'ahu95u80yd';
          final integritySalt = 'v54t8u1zu9';
          final returnUrl =
              'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';

          final success =
              await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => JazzCashPaymentScreen(
                    amount: cartProvider.discountedAmount,
                    merchantId: merchantId,
                    password: password,
                    integritySalt: integritySalt,
                    returnUrl: returnUrl,
                  ),
                ),
              ) ??
              false;

          if (success) {
            if (emailService != null && email.isNotEmpty) {
              final orderId = order.id;
              final customerName =
                  context
                      .read<AuthenticationProvider>()
                      .currentUser
                      ?.displayName ??
                  '';
              final sent = await emailService.sendOrderConfirmation(
                toEmail: email,
                customerName: customerName,
                orderId: orderId,
                itemsSummary: itemsSummary,
                total: cartProvider.discountedAmount,
                address:
                    '${selectedAddress.addressLine}, ${selectedAddress.city}, ${selectedAddress.postalCode}',
                paymentMethod: _selectedPaymentMethod,
              );

              if (sent) {
                SnackbarHelper.success(
                  context: context,
                  title: 'Success',
                  message: 'Your order has been placed successfully!',
                );
              } else {
                SnackbarHelper.info(
                  context: context,
                  title: 'Email Failed',
                  message: 'Could not send confirmation email.',
                );
              }
            }

            final uid = context.read<AuthenticationProvider>().currentUser?.uid;
            if (uid != null) {
              try {
                await cartProvider.clearCartForUser(uid);
              } catch (_) {
                cartProvider.clearCart();
              }
            } else {
              cartProvider.clearCart();
            }
          } else {
            SnackbarHelper.error(
              context: context,
              title: 'Payment Failed',
              message: 'JazzCash payment was not completed.',
            );
            // optionally delete or mark order as failed
          }
        } else {
          if (emailService != null && email.isNotEmpty) {
            final orderId = order.id;
            final customerName =
                context
                    .read<AuthenticationProvider>()
                    .currentUser
                    ?.displayName ??
                '';
            final sent = await emailService.sendOrderConfirmation(
              toEmail: email,
              customerName: customerName,
              orderId: orderId,
              itemsSummary: itemsSummary,
              total: cartProvider.discountedAmount,
              address:
                  '${selectedAddress.addressLine}, ${selectedAddress.city}, ${selectedAddress.postalCode}',
              paymentMethod: _selectedPaymentMethod,
            );

            if (sent) {
              SnackbarHelper.success(
                context: context,
                title: 'Success',
                message: 'Your order has been placed successfully!',
              );
            } else {
              SnackbarHelper.info(
                context: context,
                title: 'Email Failed',
                message: 'Could not send confirmation email.',
              );
            }
          }

          final uid = context.read<AuthenticationProvider>().currentUser?.uid;
          if (uid != null) {
            try {
              await cartProvider.clearCartForUser(uid);
            } catch (_) {
              cartProvider.clearCart();
            }
          } else {
            cartProvider.clearCart();
          }
        }

        final uid = context.read<AuthenticationProvider>().currentUser?.uid;
        if (uid != null) {
          try {
            await cartProvider.clearCartForUser(uid);
          } catch (_) {
            cartProvider.clearCart();
          }
        } else {
          cartProvider.clearCart();
        }
      } catch (e) {
        SnackbarHelper.error(
          context: context,
          title: 'Order Failed',
          message: e.toString(),
        );
      }
    }
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
