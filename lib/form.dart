import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddIllustrationForm extends StatefulWidget {
  @override
  _AddIllustrationFormState createState() => _AddIllustrationFormState();
}

class _AddIllustrationFormState extends State<AddIllustrationForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  
  String title = '';
  String description = '';
  String category = 'Oil Paintings';
  bool isFeatured = false;
  File? _selectedImage;
  String? _selectedImageName;
  bool _isUploading = false;

  // Pick image from gallery with better error handling
  Future<void> _pickImageFromGallery() async {
    try {
      print('Attempting to pick image from gallery...');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Image selection timed out');
        },
      );
      
      if (image != null) {
        print('Image picked successfully: ${image.path}');
        
        setState(() {
          if (!kIsWeb) {
            _selectedImage = File(image.path);
          } else {
            _selectedImage = null; // Web doesn't support File()
          }
          _selectedImageName = image.name.isNotEmpty ? image.name : 'selected_image.jpg';
        });
        
        _showSuccessMessage('Image selected: ${_selectedImageName}');
      } else {
        print('No image selected by user');
        _showInfoMessage('No image selected');
      }
    } catch (e) {
      print('Gallery error: $e');
      _showFallbackOptions();
    }
  }

  // Pick image from camera with better error handling
  Future<void> _pickImageFromCamera() async {
    if (kIsWeb) {
      _showErrorMessage('Camera not available on web platform');
      return;
    }

    try {
      print('Attempting to pick image from camera...');
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Camera access timed out');
        },
      );
      
      if (image != null) {
        print('Photo taken successfully: ${image.path}');
        
        setState(() {
          _selectedImage = File(image.path);
          _selectedImageName = 'camera_photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
        });
        
        _showSuccessMessage('Photo captured successfully!');
      } else {
        print('No photo taken by user');
        _showInfoMessage('No photo taken');
      }
    } catch (e) {
      print('Camera error: $e');
      _showFallbackOptions();
    }
  }

  // Select sample image (always works)
  void _selectSampleImage() {
    setState(() {
      _selectedImage = null;
      _selectedImageName = 'sample_artwork_${DateTime.now().millisecondsSinceEpoch}.jpg';
    });
    
    _showSuccessMessage('Sample artwork selected - ready to use!');
  }

  // Show success message
  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Show error message
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Show info message
  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Show fallback options when image picker fails
  void _showFallbackOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.image_not_supported, color: Colors.orange),
              SizedBox(width: 8),
              Text('Image Selection Issue'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Having trouble accessing your device gallery/camera?'),
              SizedBox(height: 16),
              Text('This could be due to:'),
              SizedBox(height: 8),
              Text('• Missing permissions'),
              Text('• Platform restrictions'),
              Text('• Device compatibility'),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.palette, color: Colors.purple),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You can use a sample image instead to test the form',
                        style: TextStyle(
                          color: Colors.purple[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _selectSampleImage();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: Text('Use Sample Image'),
            ),
          ],
        );
      },
    );
  }

  // Show image source selection dialog
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Select Image Source',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      SizedBox(height: 8),
                      
                      Text(
                        'Choose how you want to add an image',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Sample image option (recommended)
                      _buildImageSourceOption(
                        icon: Icons.palette,
                        title: 'Sample Image (Recommended)',
                        subtitle: 'Always works - use demo artwork',
                        color: Colors.purple,
                        onTap: () {
                          Navigator.pop(context);
                          _selectSampleImage();
                        },
                      ),
                      
                      SizedBox(height: 12),
                      
                      // Gallery option
                      _buildImageSourceOption(
                        icon: Icons.photo_library,
                        title: 'Gallery',
                        subtitle: 'Choose from your photos',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.pop(context);
                          _pickImageFromGallery();
                        },
                      ),
                      
                      SizedBox(height: 12),
                      
                      // Camera option (if not web)
                      if (!kIsWeb)
                        _buildImageSourceOption(
                          icon: Icons.camera_alt,
                          title: 'Camera',
                          subtitle: 'Take a new photo',
                          color: Colors.green,
                          onTap: () {
                            Navigator.pop(context);
                            _pickImageFromCamera();
                          },
                        ),
                      
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build image source option widget
  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color.withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // Build image upload section
  Widget _buildImageUploadSection() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Image *',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          
          GestureDetector(
            onTap: _showImageSourceDialog,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: double.infinity,
              height: _selectedImageName != null ? 250 : 150,
              decoration: BoxDecoration(
                color: _selectedImageName != null 
                    ? Colors.purple[50] 
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _selectedImageName != null 
                      ? Colors.purple 
                      : Colors.grey[300]!,
                  width: 2,
                ),
                boxShadow: _selectedImageName != null 
                    ? [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: _selectedImageName != null
                  ? _buildSelectedImageDisplay()
                  : _buildEmptyImageDisplay(),
            ),
          ),
        ],
      ),
    );
  }

  // Build selected image display
  Widget _buildSelectedImageDisplay() {
    return Stack(
      children: [
        // Show actual image or placeholder
        if (_selectedImage != null && !kIsWeb)
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.file(
              _selectedImage!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildImagePlaceholder();
              },
            ),
          )
        else
          _buildImagePlaceholder(),
        
        // Remove button
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedImage = null;
                _selectedImageName = null;
              });
              _showSuccessMessage('Image removed');
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        
        // Edit button
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: _showImageSourceDialog,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        
        // Image name overlay
        if (_selectedImageName != null)
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                _selectedImageName!.length > 25 
                    ? '${_selectedImageName!.substring(0, 22)}...'
                    : _selectedImageName!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Build image placeholder
  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple[100]!,
            Colors.purple[200]!,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.check_circle,
              size: 50,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 16),
          Text(
            _selectedImageName ?? 'Selected Image',
            style: TextStyle(
              fontSize: 18,
              color: Colors.purple[800],
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '✓ Ready to upload',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build empty image display
  Widget _buildEmptyImageDisplay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            Icons.add_photo_alternate,
            size: 50,
            color: Colors.grey[500],
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Tap to upload image',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Sample (Recommended) • Gallery${!kIsWeb ? " • Camera" : ""}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Add New Illustration',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
        elevation: 2,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Platform info
                Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          kIsWeb 
                              ? 'Running on Web - Use Sample Image for best results'
                              : 'Running on Mobile - All options available',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Image Upload Section
                _buildImageUploadSection(),
                
                SizedBox(height: 20),
                
                // Title Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title *',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.purple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSaved: (val) => title = val ?? '',
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Title is required' : null,
                ),
                
                SizedBox(height: 16),
                
                // Description Field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.purple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  onSaved: (val) => description = val ?? '',
                ),
                
                SizedBox(height: 16),
                
                // Category Dropdown
                DropdownButtonFormField<String>(
                  value: category,
                  items: [
                    'Oil Paintings',
                    'Wall Arts',
                    'Museums',
                    'Sculptures',
                    'Photography',
                    'Digital Art'
                  ]
                      .map((item) =>
                          DropdownMenuItem(value: item, child: Text(item)))
                      .toList(),
                  onChanged: (val) => setState(() => category = val!),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.purple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Featured Switch
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: SwitchListTile(
                    title: Text(
                      'Feature this illustration',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Featured illustrations appear in the main gallery',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    value: isFeatured,
                    activeColor: Colors.purple,
                    onChanged: (val) => setState(() => isFeatured = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isUploading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              if (_selectedImageName == null) {
                                _showErrorMessage('Please select an image first');
                                return;
                              }
                              
                              _formKey.currentState!.save();
                              setState(() {
                                _isUploading = true;
                              });
                              
                              // Simulate upload process
                              Future.delayed(Duration(seconds: 2), () {
                                setState(() {
                                  _isUploading = false;
                                });
                                
                                _showSuccessMessage('Illustration "$title" added successfully!');
                                
                                // Reset form
                                _formKey.currentState!.reset();
                                setState(() {
                                  _selectedImage = null;
                                  _selectedImageName = null;
                                  category = 'Oil Paintings';
                                  isFeatured = false;
                                });
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: _isUploading
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
                                'Uploading...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'Add Illustration',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}