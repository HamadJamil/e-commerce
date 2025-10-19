import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms & Conditions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Terms & Conditions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Text(
              'Sample Terms & Conditions\n\n'
              '1. Acceptance of Terms\n'
              'By using this app, you agree to these terms and conditions.\n\n'
              '2. Use of Service\n'
              'You agree to use the app for lawful purposes only.\n\n'
              '3. Orders\n'
              'All orders are subject to acceptance and availability.\n\n'
              '4. Limitation of Liability\n'
              'We are not liable for any damages arising from the use of this app.\n\n'
              '5. Changes to Terms\n'
              'We may update these terms at any time. Continued use of the app constitutes acceptance of the new terms.\n\n'
              'Contact us for any questions regarding these terms.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
