import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'cart_screen.dart';
import 'models.dart' as models;

// Product model

class CreateSaleForm extends StatefulWidget {
  const CreateSaleForm({super.key});

  @override
  _CreateSaleFormState createState() => _CreateSaleFormState();
}

class _CreateSaleFormState extends State<CreateSaleForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notesController = TextEditingController();

  // Form state
  DateTime _selectedDateTime = DateTime.now();
  models.Outlet? _selectedOutlet;
  List<models.Product> _selectedProducts = [];
  bool _isSubmitting = false;

  // Sample data
  final List<models.Outlet> _outlets = [
    models.Outlet(id: '1', name: 'Main Store', address: 'Phnom Penh Central'),
    models.Outlet(id: '2', name: 'Branch A', address: 'Toul Kork District'),
    models.Outlet(id: '3', name: 'Branch B', address: 'BKK1 District'),
  ];

  final List<models.Product> _availableProducts = [
    models.Product(
      id: '1',
      code: '10110',
      name: 'Premium Coffee Beans',
      nameKhmer: 'កាហ្វេគ្រាប់ពិសេស',
      price: 25.50,
    ),
    models.Product(
      id: '2',
      code: '10111',
      name: 'Organic Tea Leaves',
      nameKhmer: 'ស្លឹកតែធម្មជាតិ',
      price: 18.75,
    ),
    models.Product(
      id: '3',
      code: '10112',
      name: 'Fresh Milk',
      nameKhmer: 'ទឹកដោះគោស្រស់',
      price: 12.00,
    ),
    models.Product(
      id: '4',
      code: '10113',
      name: 'Chocolate Powder',
      nameKhmer: 'ម្សៅសូកូឡា',
      price: 22.30,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Add initial products to match the screenshot
    _selectedProducts = [
      models.Product(
        id: '1',
        code: '10110',
        name: 'Premium Coffee Beans',
        nameKhmer: 'កាហ្វេគ្រាប់ពិសេស',
        price: 25.50,
        quantity: 1,
      ),
      models.Product(
        id: '2',
        code: '10111',
        name: 'Organic Tea Leaves',
        nameKhmer: 'ស្លឹកតែធម្មជាតិ',
        price: 18.75,
        quantity: 1,
      ),
    ];
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // Calculate total amount
  double get _totalAmount {
    return _selectedProducts.fold(
      0.0,
      (sum, product) => sum + (product.price * product.quantity),
    );
  }

  // Show outlet selection dialog
  void _showOutletSelection() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.store, color: Colors.blue),
                  SizedBox(width: 12),
                  Text(
                    'Choose Outlet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),

              SizedBox(height: 16),

              ..._outlets.map((outlet) {
                return ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.store, color: Colors.blue),
                  ),
                  title: Text(
                    outlet.name,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(outlet.address),
                  trailing: _selectedOutlet?.id == outlet.id
                      ? Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedOutlet = outlet;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),

              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // void _showProductSelection() {
  //   List<String> tempSelectedIds = _selectedProducts.map((p) => p.id).toList();

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setDialogState) {
  //           return Dialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(15),
  //             ),
  //             child: Container(
  //              width: MediaQuery.of(context).size.width,  // ← Full width
  //   height: MediaQuery.of(context).size.height, // ← Full height
  //   // ...
  //               padding: EdgeInsets.all(20),
  //               child: Column(
  //                 children: [
  //                   // Header with selection count
  //                   Row(
  //                     children: [
  //                       Icon(Icons.add_shopping_cart, color: Colors.red),
  //                       SizedBox(width: 12),
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               'Add Products',
  //                               style: TextStyle(
  //                                 fontSize: 20,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             if (tempSelectedIds.isNotEmpty)
  //                               Text(
  //                                 '${tempSelectedIds.length} product(s) selected',
  //                                 style: TextStyle(
  //                                   fontSize: 12,
  //                                   color: Colors.blue,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                           ],
  //                         ),
  //                       ),
  //                       IconButton(
  //                         onPressed: () => Navigator.pop(context),
  //                         icon: Icon(Icons.close),
  //                       ),
  //                     ],
  //                   ),

  //                   SizedBox(height: 16),

  //                   // Select All / Deselect All buttons
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: OutlinedButton.icon(
  //                           onPressed: () {
  //                             setDialogState(() {
  //                               if (tempSelectedIds.length ==
  //                                   _availableProducts.length) {
  //                                 // Deselect all
  //                                 tempSelectedIds.clear();
  //                               } else {
  //                                 // Select all
  //                                 tempSelectedIds = _availableProducts
  //                                     .map((p) => p.id)
  //                                     .toList();
  //                               }
  //                             });
  //                           },
  //                           icon: Icon(
  //                             tempSelectedIds.length ==
  //                                     _availableProducts.length
  //                                 ? Icons.check_box
  //                                 : Icons.check_box_outline_blank,
  //                             size: 18,
  //                           ),
  //                           label: Text(
  //                             tempSelectedIds.length ==
  //                                     _availableProducts.length
  //                                 ? 'Deselect All'
  //                                 : 'Select All',
  //                             style: TextStyle(fontSize: 12),
  //                           ),
  //                           style: OutlinedButton.styleFrom(
  //                             padding: EdgeInsets.symmetric(
  //                               horizontal: 12,
  //                               vertical: 8,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       SizedBox(width: 12),
  //                       Container(
  //                         padding: EdgeInsets.symmetric(
  //                           horizontal: 12,
  //                           vertical: 8,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           color: Colors.blue[50],
  //                           borderRadius: BorderRadius.circular(20),
  //                           border: Border.all(color: Colors.blue[200]!),
  //                         ),
  //                         child: Text(
  //                           '${tempSelectedIds.length}/${_availableProducts.length}',
  //                           style: TextStyle(
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.blue[800],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),

  //                   SizedBox(height: 16),

  //                   // Product list with checkboxes
  //                   Expanded(
  //                     child: ListView.builder(
  //                       itemCount: _availableProducts.length,
  //                       itemBuilder: (context, index) {
  //                         final product = _availableProducts[index];
  //                         final isSelected = tempSelectedIds.contains(
  //                           product.id,
  //                         );

  //                         return Card(
  //                           margin: EdgeInsets.only(bottom: 8),
  //                           elevation: isSelected ? 3 : 1,
  //                           color: isSelected ? Colors.blue[50] : Colors.white,
  //                           child: ListTile(
  //                             onTap: () {
  //                               setDialogState(() {
  //                                 if (isSelected) {
  //                                   tempSelectedIds.remove(product.id);
  //                                 } else {
  //                                   tempSelectedIds.add(product.id);
  //                                 }
  //                               });
  //                             },
  //                             leading: Row(
  //                               mainAxisSize: MainAxisSize.min,
  //                               children: [
  //                                 // Checkbox
  //                                 // Container(
  //                                 //   width: 24,
  //                                 //   height: 24,
  //                                 //   decoration: BoxDecoration(
  //                                 //     color: isSelected ? Colors.blue : Colors.transparent,
  //                                 //     border: Border.all(
  //                                 //       color: isSelected ? Colors.blue : Colors.grey,
  //                                 //       width: 2,
  //                                 //     ),
  //                                 //     borderRadius: BorderRadius.circular(4),
  //                                 //   ),
  //                                 //   child: isSelected
  //                                 //       ? Icon(
  //                                 //           Icons.check,
  //                                 //           size: 16,
  //                                 //           color: Colors.white,
  //                                 //         )
  //                                 //       : null,
  //                                 // ),
  //                                 SizedBox(width: 12),
  //                                 // Product icon
  //                                 Container(
  //                                   width: 40,
  //                                   height: 40,
  //                                   decoration: BoxDecoration(
  //                                     color: Colors.red[100],
  //                                     borderRadius: BorderRadius.circular(8),
  //                                   ),
  //                                   child: Icon(
  //                                     Icons.local_cafe,
  //                                     color: Colors.red,
  //                                     size: 20,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             title: Text(
  //                               '${product.code} - ${product.name}',
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.w600,
  //                                 fontSize: 14,
  //                                 color: isSelected
  //                                     ? Colors.blue[800]
  //                                     : Colors.black,
  //                               ),
  //                             ),
  //                             subtitle: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Text(
  //                                   product.nameKhmer,
  //                                   style: TextStyle(
  //                                     fontSize: 12,
  //                                     color: isSelected
  //                                         ? Colors.blue[600]
  //                                         : Colors.grey[600],
  //                                   ),
  //                                 ),
  //                                 SizedBox(height: 4),
  //                                 Text(
  //                                   '\$${product.price.toStringAsFixed(2)}',
  //                                   style: TextStyle(
  //                                     color: Colors.green,
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 12,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             trailing: isSelected
  //                                 ? Icon(
  //                                     Icons.check_circle,
  //                                     color: Colors.green,
  //                                   )
  //                                 : null,
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),

  //                   SizedBox(height: 16),

  //                   // Action buttons
  //                   Row(
  //                     children: [
  //                       // Expanded(
  //                       // child: OutlinedButton(
  //                       //   onPressed: () => Navigator.pop(context),
  //                       //   style: OutlinedButton.styleFrom(
  //                       //     padding: EdgeInsets.symmetric(vertical: 14),
  //                       //     side: BorderSide(color: Colors.grey),
  //                       //   ),
  //                       //   child: Text(
  //                       //     'Cancel',
  //                       //     style: TextStyle(
  //                       //       fontSize: 16,
  //                       //       fontWeight: FontWeight.w600,
  //                       //       color: Colors.grey[700],
  //                       //     ),
  //                       //   ),
  //                       // ),
  //                       // ),
  //                       SizedBox(width: 12),
  //                       Expanded(
  //                         flex: 2,
  //                         child: ElevatedButton(
  //                           onPressed: tempSelectedIds.isEmpty
  //                               ? null
  //                               : () {
  //                                   setState(() {
  //                                     // Remove products that are no longer selected
  //                                     _selectedProducts.removeWhere(
  //                                       (product) => !tempSelectedIds.contains(
  //                                         product.id,
  //                                       ),
  //                                     );

  //                                     // Add newly selected products
  //                                     for (String productId
  //                                         in tempSelectedIds) {
  //                                       if (!_selectedProducts.any(
  //                                         (p) => p.id == productId,
  //                                       )) {
  //                                         final product = _availableProducts
  //                                             .firstWhere(
  //                                               (p) => p.id == productId,
  //                                             );
  //                                         _selectedProducts.add(
  //                                           Product(
  //                                             id: product.id,
  //                                             code: product.code,
  //                                             name: product.name,
  //                                             nameKhmer: product.nameKhmer,
  //                                             price: product.price,
  //                                             quantity: 1,
  //                                           ),
  //                                         );
  //                                       }
  //                                     }
  //                                   });
  //                                   Navigator.pop(context);
  //                                 },
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: Colors.red,
  //                             foregroundColor: Colors.white,
  //                             padding: EdgeInsets.symmetric(vertical: 14),
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(8),
  //                             ),
  //                           ),
  //                           child: Text(
  //                             tempSelectedIds.isEmpty
  //                                 ? 'Select Products'
  //                                 : 'Add ${tempSelectedIds.length} Product${tempSelectedIds.length == 1 ? '' : 's'}',
  //                             style: TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  // Replace the _showProductSelection method with this updated version:

  void _showProductSelection() {
    List<String> tempSelectedIds = _selectedProducts.map((p) => p.id).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              insetPadding: EdgeInsets.zero, // Remove default margins
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // Remove rounded corners
              ),
              child: Container(
                width: MediaQuery.of(context).size.width, // Full screen width
                height: MediaQuery.of(
                  context,
                ).size.height, // Full screen height
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header with selection count
                    Row(
                      children: [
                        Icon(Icons.add_shopping_cart, color: Colors.red),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add Products',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (tempSelectedIds.isNotEmpty)
                                Text(
                                  '${tempSelectedIds.length} product(s) selected',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Select All / Deselect All buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setDialogState(() {
                                if (tempSelectedIds.length ==
                                    _availableProducts.length) {
                                  // Deselect all
                                  tempSelectedIds.clear();
                                } else {
                                  // Select all
                                  tempSelectedIds = _availableProducts
                                      .map((p) => p.id)
                                      .toList();
                                }
                              });
                            },
                            icon: Icon(
                              tempSelectedIds.length ==
                                      _availableProducts.length
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 18,
                            ),
                            label: Text(
                              tempSelectedIds.length ==
                                      _availableProducts.length
                                  ? 'Deselect All'
                                  : 'Select All',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            '${tempSelectedIds.length}/${_availableProducts.length}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Product list with checkboxes
                    Expanded(
                      child: ListView.builder(
                        itemCount: _availableProducts.length,
                        itemBuilder: (context, index) {
                          final product = _availableProducts[index];
                          final isSelected = tempSelectedIds.contains(
                            product.id,
                          );

                          return Card(
                            margin: EdgeInsets.only(bottom: 8),
                            elevation: isSelected ? 3 : 1,
                            color: isSelected ? Colors.blue[50] : Colors.white,
                            child: ListTile(
                              onTap: () {
                                setDialogState(() {
                                  if (isSelected) {
                                    tempSelectedIds.remove(product.id);
                                  } else {
                                    tempSelectedIds.add(product.id);
                                  }
                                });
                              },
                              leading: Row(mainAxisSize: MainAxisSize.min),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${product.code} :  ${product.name}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                ],
                              ),

                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   product.nameKhmer,
                                  //   style: TextStyle(
                                  //     fontSize: 12,
                                  //     color: isSelected
                                  //         ? Colors.blue[600]
                                  //         : Colors.grey[600],
                                  //   ),
                                  // ),
                                  SizedBox(height: 4),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: isSelected
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.orange[800],
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: tempSelectedIds.isEmpty
                                ? null
                                : () {
                                    setState(() {
                                      // Remove products that are no longer selected
                                      _selectedProducts.removeWhere(
                                        (product) => !tempSelectedIds.contains(
                                          product.id,
                                        ),
                                      );

                                      // Add newly selected products
                                      for (String productId
                                          in tempSelectedIds) {
                                        if (!_selectedProducts.any(
                                          (p) => p.id == productId,
                                        )) {
                                          final product = _availableProducts
                                              .firstWhere(
                                                (p) => p.id == productId,
                                              );
                                          _selectedProducts.add(
                                            models.Product(
                                              id: product.id,
                                              code: product.code,
                                              name: product.name,
                                              nameKhmer: product.nameKhmer,
                                              price: product.price,
                                              quantity: 1,
                                            ),
                                          );
                                        }
                                      }
                                    });
                                    Navigator.pop(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              tempSelectedIds.isEmpty
                                  ? 'Select Products'
                                  : 'Add ${tempSelectedIds.length} Product${tempSelectedIds.length == 1 ? '' : 's'}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Show date time picker
  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  // Remove product from list
  void _removeProduct(int index) {
    setState(() {
      _selectedProducts.removeAt(index);
    });
  }

  // Update product quantity
  void _updateProductQuantity(int index, int quantity) {
    if (quantity > 0) {
      setState(() {
        _selectedProducts[index].quantity = quantity;
      });
    }
  }

  // Submit form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedOutlet == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an outlet'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_selectedProducts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please add at least one product'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call
      Future.delayed(Duration(seconds: 1), () {
        final ticket = models.Ticket(
          id: 'TKT${DateTime.now().millisecondsSinceEpoch}',
          createdAt: _selectedDateTime,
          outletId: _selectedOutlet!.id,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          products: List.from(_selectedProducts),
          totalAmount: _totalAmount,
        );

        setState(() {
          _isSubmitting = false;
        });

        // Navigate to Cart Screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartScreen(ticket: ticket)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Sale',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Time Section
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey[600]),
                          SizedBox(width: 12),
                          Text(
                            DateFormat(
                              'EEE, dd/MM/yyyy hh:mm a',
                            ).format(_selectedDateTime),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                    // Outlet Selection
                    GestureDetector(
                      onTap: _showOutletSelection,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.store, color: Colors.grey[600]),
                            SizedBox(width: 12),
                            Text(
                              _selectedOutlet?.name ?? 'Choose Customer',
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedOutlet != null
                                    ? Colors.black
                                    : Colors.grey[600],
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Notes Section
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          hintText: 'Remarks . . .',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        maxLines: 3,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Add Product Button
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: _showProductSelection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Product',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Selected Products List
// Replace the selected products section (around lines 1000-1200) with this updated version:

// Selected Products List
if (_selectedProducts.isNotEmpty) ...[
  Text(
    'Selected Products (${_selectedProducts.length})',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
  ),
  SizedBox(height: 12),

  ..._selectedProducts.asMap().entries.map((entry) {
    final index = entry.key;
    final product = entry.value;

    return Dismissible(
      key: Key('${product.id}_$index'), // Unique key for each product
      direction: DismissDirection.endToStart, // Swipe right to left
      background: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.delete,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Remove Product',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              content: Text(
                'Are you sure you want to remove "${product.name}" from your order?',
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Remove',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        ) ?? false;
      },
      onDismissed: (direction) {
        // Store the removed product for undo functionality
        final removedProduct = product;
        final removedIndex = index;
        
        // Remove the product
        setState(() {
          _selectedProducts.removeAt(index);
        });
        
        // Show snackbar with undo option
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${removedProduct.name} removed',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            duration: Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            action: SnackBarAction(
              label: 'UNDO',
              textColor: Colors.white,
              backgroundColor: Colors.red[800],
              onPressed: () {
                // Restore the product
                setState(() {
                  _selectedProducts.insert(removedIndex, removedProduct);
                });
                
                // Show restoration confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.restore, color: Colors.white, size: 20),
                        SizedBox(width: 12),
                        Text(
                          '${removedProduct.name} restored',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green[600],
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product number
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(width: 12),

            // Product icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.local_cafe,
                color: Colors.red,
                size: 20,
              ),
            ),

            SizedBox(width: 12),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product.code} : ${product.name}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'x ${product.quantity}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '= \$${(product.price * product.quantity).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                ],
              ),
            ),

            // Quantity controls
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (product.quantity > 1) {
                          _updateProductQuantity(
                            index,
                            product.quantity - 1,
                          );
                        } else {
                          _removeProduct(index);
                        }
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: product.quantity == 1 
                              ? Colors.red[100] 
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          product.quantity == 1
                              ? Icons.delete
                              : Icons.remove,
                          size: 16,
                          color: product.quantity == 1
                              ? Colors.red
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 32,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${product.quantity}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        _updateProductQuantity(
                          index,
                          product.quantity + 1,
                        );
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }).toList(),

  // Total Amount section remains the same
  Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.blue[200]!),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Amount:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue[800],
          ),
        ),
        Text(
          '\$${_totalAmount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
      ],
    ),
  ),
],
                    SizedBox(height: 100), // Space for submit button
                  ],
                ),
              ),
            ),

            // Submit Button (Fixed at bottom)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: _isSubmitting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Submitting...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage example
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sale Ticket Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CreateSaleForm(),
    );
  }
}
