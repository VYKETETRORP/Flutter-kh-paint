import 'package:flutter/material.dart';

class AddIllustrationForm extends StatefulWidget {
  @override
  _AddIllustrationFormState createState() => _AddIllustrationFormState();
}

class _AddIllustrationFormState extends State<AddIllustrationForm> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String category = 'Oil Paintings';
  bool isFeatured = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Illustration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (val) => title = val ?? '',
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                  onSaved: (val) => description = val ?? '',
                ),
                DropdownButtonFormField<String>(
                  value: category,
                  items: ['Oil Paintings', 'Wall Arts', 'Museums']
                      .map((item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (val) => setState(() => category = val!),
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                SwitchListTile(
                  title: Text('Feature this illustration'),
                  value: isFeatured,
                  onChanged: (val) => setState(() => isFeatured = val),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Save or submit the form data here
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
