import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedMethod = 'Cash';

  final List<Map<String, dynamic>> _methods = [
    {'label': 'Cash', 'subtitle': null, 'icon': Icons.money, 'value': 'Cash'},
    {'label': 'Cash', 'subtitle': null, 'icon': Icons.money, 'value': 'Cash'},
    {
      'label': 'Credit or Debit Card',
      'subtitle': null,
      'icon': Icons.credit_card,
      'value': 'Card',
      'trailing': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        title: const Text('Select a payment method'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: _methods.length,
        separatorBuilder: (_, __) => Divider(height: 1),
        itemBuilder: (context, index) {
          final method = _methods[index];
          return ListTile(
            leading: Icon(method['icon'], size: 32),
            title: Text(
              method['label'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: method['subtitle'] != null
                ? Text(method['subtitle'])
                : null,
            trailing: method['trailing'] == true
                ? Icon(Icons.chevron_right)
                : Radio<String>(
                    value: method['value'],
                    groupValue: _selectedMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    },
                  ),
            selected: _selectedMethod == method['value'], // <-- Add this line
            selectedTileColor: Colors.grey[200],
            onTap: method['trailing'] == true
                ? () {
                    // Handle card selection navigation here
                  }
                : () {
                    setState(() {
                      _selectedMethod = method['value'];
                    });
                  },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _selectedMethod);
            },
            child: Text('Confirm'),
          ),
        ),
      ),
    );
  }
}
