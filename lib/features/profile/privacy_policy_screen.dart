import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Text(
              'Sample Privacy Policy\n\n'
              'We value your privacy. This sample privacy policy explains how we collect, use, and protect your information.\n\n'
              '1. Information Collection\n'
              'We may collect personal information such as your name, email, and address for order processing.\n\n'
              '2. Use of Information\n'
              'Your information is used to provide and improve our services, process orders, and communicate with you.\n\n'
              '3. Data Security\n'
              'We implement security measures to protect your data.\n\n'
              '4. Third-Party Services\n'
              'We do not share your personal information with third parties except as required by law.\n\n'
              '5. Changes to Policy\n'
              'We may update this policy. Please review it regularly.\n\n'
              'Contact us if you have any questions about our privacy practices.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
