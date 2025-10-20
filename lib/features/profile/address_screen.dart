import 'package:e_commerce/core/providers/address_provider.dart';
import 'package:e_commerce/shared/widgets/snack_bar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalController;
  bool _makeDefault = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _postalController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  void _showAddAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 12),
                TextFormField(
                  autofocus: true,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Address Name',
                    hintText: 'Home, Office',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter name' : null,
                ),
                SizedBox(height: 12),

                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Address',
                    hintText: 'Apartment, suite, unit, building, floor, etc.',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter address' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter city' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _postalController,
                  decoration: InputDecoration(
                    labelText: 'Postal Code',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Enter postal code' : null,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: _makeDefault,

                      onChanged: (v) {
                        setState(() {
                          _makeDefault = v ?? false;
                        });
                      },
                    ),
                    Expanded(child: Text('Set as default address')),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<AddressProvider>().addAddress(
                          name: _nameController.text.trim(),
                          addressLine: _addressController.text.trim(),
                          city: _cityController.text.trim(),
                          postalCode: _postalController.text.trim(),
                          makeDefault: _makeDefault,
                        );

                        _nameController.clear();
                        _phoneController.clear();
                        _addressController.clear();
                        _cityController.clear();
                        _postalController.clear();
                        _makeDefault = false;

                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save Address'),
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Addresses')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressSheet(context),
        child: Icon(Icons.add),
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          final addresses = addressProvider.addresses;
          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_off, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No addresses yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add a delivery address to make checkout faster.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final a = addresses[index];
              return Dismissible(
                key: ValueKey(a.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context.read<AddressProvider>().removeAddress(a.id);
                  SnackbarHelper.info(
                    context: context,
                    title: 'Removed',
                    message: 'Address removed',
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      a.isDefault ? Icons.check_circle : Icons.location_on,
                      color: a.isDefault ? Colors.green : null,
                    ),
                    title: Text(
                      a.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.addressLine),
                        Text('${a.city} • ${a.postalCode}'),
                      ],
                    ),
                    trailing: a.isDefault
                        ? Text('Default', style: TextStyle(color: Colors.green))
                        : TextButton(
                            onPressed: () => context
                                .read<AddressProvider>()
                                .setDefault(a.id),
                            child: Text('Set Default'),
                          ),
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemCount: addresses.length,
          );
        },
      ),
    );
  }
}
