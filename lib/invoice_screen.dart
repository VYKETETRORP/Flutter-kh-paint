import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'cart_screan_2.dart';
class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen>{
  LatLng? _selectedLatLng;
    Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen())),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          'Checkout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                _buildProgressStep(1, 'Menu', true, true),
                Expanded(child: Container(height: 2, color: Colors.grey[300])),
                _buildProgressStep(2, 'Cart', true, true),
                Expanded(child: Container(height: 2, color: Colors.grey[300])),
                _buildProgressStep(3, 'Invoice', true, false),
              ],
            ),
          ),
              GestureDetector(
            onTap: () async {
              final picked = await Navigator.push<LatLng?>(
                context,
                MaterialPageRoute(
                  builder: (context) => MapPickerScreen(
                    initialPosition: LatLng(11.562108, 104.888535),
                  ),
                ),
              );
              if (picked != null) {
                setState(() => _selectedLatLng = picked);
              }
            },
            child: Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  // simple map preview / icon
                  Container(
                    width: 80,
                    height: 60,
                    color: Colors.grey[200],
                    child: _selectedLatLng == null
                        ? Icon(Icons.map, color: Colors.grey)
                        : Center(
                            child: Text(
                              'Lat\n${_selectedLatLng!.latitude.toStringAsFixed(4)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _selectedLatLng == null
                        ? Text('Tap to select address', style: TextStyle(color: Colors.grey[700]))
                        : Text('Lat: ${_selectedLatLng!.latitude.toStringAsFixed(6)}, Lng: ${_selectedLatLng!.longitude.toStringAsFixed(6)}'),
                  ),
                  Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
        
      ),
      
    );
  }
}

Widget _buildProgressStep(
  int step,
  String title,
  bool isCompleted,
  bool isActive,
) {
  return Column(
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isCompleted
              ? Colors.black
              : (isActive ? Colors.grey[800] : Colors.grey[300]),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '$step',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: isCompleted || isActive ? Colors.black : Colors.grey[500],
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    ],
    
  );
}
// In your InvoiceScreen widget
LatLng? _selectedLatLng;

void _pickLocation(BuildContext context) async {
  final picked = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MapPickerScreen(
        initialPosition: LatLng(11.562108, 104.888535), // Phnom Penh example
      ),
    ),
  );
  if (picked != null) {
    // setState is not available in a non-State class, so handle accordingly
    _selectedLatLng = picked;
  }
}

// Dummy MapPickerScreen widget for demonstration
class MapPickerScreen extends StatelessWidget {
  final LatLng initialPosition;

  const MapPickerScreen({Key? key, required this.initialPosition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace this with your actual map picker implementation
    return Scaffold(
      appBar: AppBar(title: Text('Pick Location')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Return the picked location
            Navigator.pop(context, initialPosition);
          },
          child: Text('Pick this location'),
        ),
      ),
    );
  }

}