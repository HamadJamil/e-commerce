// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class JazzCashPaymentScreen extends StatefulWidget {
  final double amount; // in app currency, assume PKR
  final String merchantId;
  final String password;
  final String integritySalt;
  final String returnUrl;

  const JazzCashPaymentScreen({
    super.key,
    required this.amount,
    required this.merchantId,
    required this.password,
    required this.integritySalt,
    required this.returnUrl,
  });

  @override
  State<JazzCashPaymentScreen> createState() => _JazzCashPaymentScreenState();
}

class _JazzCashPaymentScreenState extends State<JazzCashPaymentScreen> {
  late final WebViewController _controller;
  late final String _txnRef;
  late final String _amountStr;
  bool _isLoading = true;
  bool _showWebView = false;

  @override
  void initState() {
    super.initState();
    final dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    _txnRef = 'T$dateandtime';
    // JazzCash expects amount in paisa-like smallest unit; in your sample you used 100000.
    // We'll multiply by 100 to convert PKR to paisa if required by integration. Adjust if needed.
    _amountStr = (widget.amount * 100).toInt().toString();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            // detect return url indicating completion
            if (url.startsWith(widget.returnUrl)) {
              // simplistic success detection — real integration should verify params with backend
              Navigator.of(context).pop(true);
            }
          },
          onNavigationRequest: (nav) {
            // also check nav url
            if (nav.url.startsWith(widget.returnUrl)) {
              Navigator.of(context).pop(true);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  void _startPayment() {
    // show webview and post form
    setState(() {
      _showWebView = true;
      _isLoading = true;
    });
    _postPaymentForm();
  }

  String _generateSecureHash(String integritySalt) {
    final pp_Version = '1.1';
    final pp_TxnType = 'MWALLET';
    final pp_Language = 'EN';
    final pp_TxnCurrency = 'PKR';
    final pp_TxnDateTime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    final pp_TxnExpiryDateTime = DateFormat(
      "yyyyMMddHHmmss",
    ).format(DateTime.now().add(Duration(days: 1)));
    final pp_TxnRefNo = _txnRef;
    final ppmpf_1 = '';

    final superdata =
        '$integritySalt&$_amountStr&billRef&Description&$pp_Language&${widget.merchantId}&${widget.password}&${widget.returnUrl}&$pp_TxnCurrency&$pp_TxnDateTime&$pp_TxnExpiryDateTime&$pp_TxnRefNo&$pp_TxnType&$pp_Version&$ppmpf_1';

    final key = utf8.encode(integritySalt);
    final bytes = utf8.encode(superdata);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _postPaymentForm() async {
    final secureHash = _generateSecureHash(widget.integritySalt);
    final html =
        '''
    <html>
    <body onload="document.forms[0].submit()">
      <form id="payment" method="post" action="${widget.returnUrl}">
        <input type="hidden" name="pp_Version" value="1.1" />
        <input type="hidden" name="pp_TxnType" value="MWALLET" />
        <input type="hidden" name="pp_Language" value="EN" />
        <input type="hidden" name="pp_MerchantID" value="${widget.merchantId}" />
        <input type="hidden" name="pp_Password" value="${widget.password}" />
        <input type="hidden" name="pp_TxnRefNo" value="$_txnRef" />
        <input type="hidden" name="pp_Amount" value="$_amountStr" />
        <input type="hidden" name="pp_TxnCurrency" value="PKR" />
        <input type="hidden" name="pp_TxnDateTime" value="${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}" />
        <input type="hidden" name="pp_BillReference" value="billRef" />
        <input type="hidden" name="pp_Description" value="Order Payment" />
        <input type="hidden" name="pp_TxnExpiryDateTime" value="${DateFormat("yyyyMMddHHmmss").format(DateTime.now().add(Duration(days: 1)))}" />
        <input type="hidden" name="pp_ReturnURL" value="${widget.returnUrl}" />
        <input type="hidden" name="pp_SecureHash" value="$secureHash" />
      </form>
    </body>
    </html>
    ''';

    await _controller.loadHtmlString(html);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('JazzCash Payment')),
      body: WillPopScope(
        onWillPop: () async {
          // user backed out before completion
          Navigator.of(context).pop(false);
          return false;
        },
        child: _showWebView
            ? Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_isLoading) Center(child: CircularProgressIndicator()),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Pay with JazzCash',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Amount: PKR ${widget.amount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _startPayment,
                                child: Text('Pay'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
