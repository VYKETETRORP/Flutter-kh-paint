import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'cart_screan_2.dart';
import 'map_screen.dart';
import 'package:geolocator/geolocator.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  LatLng? _selectedLatLng = LatLng(11.562108, 104.888535); // Default Phnom Penh
  String _address = "79 Kampuchea Krom Boulevard (128)\nPhnom Penh";
  String _note = "Please bring it to my room";
  bool _contactless = false;
  String _paymentMethod = "Cash";
  double _total = 10.81;

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _selectedLatLng = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CartScreen()),
          ),
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
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Progress bar
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                _buildProgressStep(1, 'Menu', true, true),
                Expanded(child: Container(height: 2, color: Colors.grey[300])),
                _buildProgressStep(2, 'Cart', true, true),
                Expanded(child: Container(height: 2, color: Colors.grey[300])),
                _buildProgressStep(3, 'Checkout', true, false),
              ],
            ),
          ),

          // Delivery address card
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.black, size: 22),
                    SizedBox(width: 8),
                    Text(
                      "Delivery address",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.black),
                      onPressed: () async {
                        final picked = await Navigator.push<LatLng>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapPickerScreen(
                              // initialPosition: _selectedLatLng!,
                            ),
                          ),
                        );
                        if (picked != null) {
                          setState(() => _selectedLatLng = picked);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await Navigator.push<LatLng>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPickerScreen(
                            // initialPosition: _selectedLatLng!,
                          ),
                        ),
                      );
                      if (picked != null) {
                        setState(() => _selectedLatLng = picked);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _selectedLatLng!,
                          zoom: 16,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId('address'),
                            position: _selectedLatLng!,
                          ),
                        },
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        onTap: (pos) async {
                          final picked = await Navigator.push<LatLng>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapPickerScreen(
                                // initialPosition: pos,
                              ),
                            ),
                          );
                          if (picked != null) {
                            setState(() => _selectedLatLng = picked);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _address,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // TODO: Implement note edit
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _note,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "Contactless delivery:",
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                    Spacer(),
                    Switch(
                      value: _contactless,
                      activeColor: Colors.red,
                      onChanged: (val) {
                        setState(() => _contactless = val);
                      },
                    ),
                  ],
                ),

                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.my_location),
                      label: Text('Use my location'),
                      onPressed: _getCurrentLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),

          // Payment method card
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.payment, color: Colors.red, size: 22),
                SizedBox(width: 8),
                Text(
                  "Payment method",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red[700],
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.red),
                  onPressed: () {
                    // TODO: Implement payment method edit
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                Text(_paymentMethod, style: TextStyle(fontSize: 15)),
                Spacer(),
                Text(
                  "\$ ${_total.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Order summary card
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.receipt_long, color: Colors.red, size: 22),
                SizedBox(width: 8),
                Text(
                  "Order summary",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                Text("Total (incl. VAT)", style: TextStyle(fontSize: 15)),
                Spacer(),
                Text(
                  "\$ ${_total.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.pink[700],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              // TODO: Place order logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Place order",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
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
                ? Colors.black87
                : (isActive ? Colors.black54 : Colors.grey[300]),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted || isActive ? Colors.black87 : Colors.grey[500],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
