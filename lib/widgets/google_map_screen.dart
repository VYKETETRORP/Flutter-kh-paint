import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng initialPosition;

  const MapPickerScreen({Key? key, required this.initialPosition})
    : super(key: key);

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late LatLng _pickedPosition;

  @override
  void initState() {
    super.initState();
    _pickedPosition = widget.initialPosition;
  }

  LatLng cambodiaLatLng = LatLng(11.562108, 104.888535); // Phnom Penh, Cambodia

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick Location')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedPosition,
              zoom: 16,
            ),
            onTap: (LatLng pos) {
              setState(() {
                _pickedPosition = pos;
              });
            },
            markers: {
              Marker(markerId: MarkerId('picked'), position: _pickedPosition),
            },
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MapPickerScreen(initialPosition: cambodiaLatLng),
                  ),
                );
              },
              child: Text('Confirm Location'),
            ),
          ),
        ],
      ),
    );
  }
}
