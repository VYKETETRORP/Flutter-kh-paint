import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Data model for illustrations
class Illustration {
  final String id;
  final String title;
  final String description;
  final String category;
  final bool isFeatured;
  final String? imagePath;
  final String? imageName;
  final DateTime createdAt;

  Illustration({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isFeatured,
    this.imagePath,
    this.imageName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'isFeatured': isFeatured,
      'imagePath': imagePath,
      'imageName': imageName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Illustration fromMap(Map<String, dynamic> map) {
    return Illustration(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      isFeatured: map['isFeatured'],
      imagePath: map['imagePath'],
      imageName: map['imageName'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

// Global data storage class with default data
class IllustrationStorage {
  static final IllustrationStorage _instance = IllustrationStorage._internal();
  factory IllustrationStorage() => _instance;
  IllustrationStorage._internal() {
    _initializeDefaultData();
  }

  final List<Illustration> _illustrations = [];
  bool _defaultDataLoaded = false;

  // Initialize with default sample data
  void _initializeDefaultData() {
    if (_defaultDataLoaded) return;
    
    final defaultIllustrations = [
      Illustration(
        id: 'default_001',
        title: 'Sunset Symphony',
        description: 'A breathtaking oil painting capturing the golden hour with vibrant oranges and purples dancing across the canvas. This masterpiece evokes feelings of serenity and wonder.',
        category: 'Oil Paintings',
        isFeatured: true,
        imagePath: null,
        imageName: 'sunset_symphony.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 5)),
      ),
      
      Illustration(
        id: 'default_002',
        title: 'Modern Geometry',
        description: 'Contemporary wall art featuring bold geometric patterns in navy blue and gold. Perfect for modern living spaces and office environments.',
        category: 'Wall Arts',
        isFeatured: true,
        imagePath: null,
        imageName: 'modern_geometry.jpg',
        createdAt: DateTime.now().subtract(Duration(days: 3)),
      ),
      
                                
      
     
    ];

    _illustrations.addAll(defaultIllustrations);
    _defaultDataLoaded = true;
    
    print('🎨 Initialized with ${defaultIllustrations.length} default illustrations');
    print('⭐ Featured items: ${defaultIllustrations.where((item) => item.isFeatured).length}');
  }

  // Add new illustration
  void addIllustration(Illustration illustration) {
    _illustrations.add(illustration);
    print('✅ Added illustration: ${illustration.title}');
    print('📊 Total illustrations: ${_illustrations.length}');
  }

  // Get all illustrations
  List<Illustration> getAllIllustrations() => List.from(_illustrations);

  // Get illustrations by category
  List<Illustration> getIllustrationsByCategory(String category) {
    return _illustrations.where((item) => item.category == category).toList();
  }

  // Get featured illustrations
  List<Illustration> getFeaturedIllustrations() {
    return _illustrations.where((item) => item.isFeatured).toList();
  }

  // Get illustration by ID
  Illustration? getIllustrationById(String id) {
    try {
      return _illustrations.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Remove illustration
  bool removeIllustration(String id) {
    final index = _illustrations.indexWhere((item) => item.id == id);
    if (index != -1) {
      _illustrations.removeAt(index);
      return true;
    }
    return false;
  }

  // Update illustration
  bool updateIllustration(String id, Illustration updatedIllustration) {
    final index = _illustrations.indexWhere((item) => item.id == id);
    if (index != -1) {
      _illustrations[index] = updatedIllustration;
      return true;
    }
    return false;
  }

  // Get count
  int get count => _illustrations.length;

  // Get categories with counts
  Map<String, int> getCategoryCounts() {
    final counts = <String, int>{};
    for (final illustration in _illustrations) {
      counts[illustration.category] = (counts[illustration.category] ?? 0) + 1;
    }
    return counts;
  }

  // Clear all data (including default data)
  void clear() {
    _illustrations.clear();
    _defaultDataLoaded = false;
  }

  // Reset to default data only
  void resetToDefault() {
    _illustrations.clear();
    _defaultDataLoaded = false;
    _initializeDefaultData();
  }

  // Search illustrations
  List<Illustration> searchIllustrations(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _illustrations.where((item) {
      return item.title.toLowerCase().contains(lowercaseQuery) ||
             item.description.toLowerCase().contains(lowercaseQuery) ||
             item.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get summary statistics
  Map<String, dynamic> getStatistics() {
    final total = _illustrations.length;
    final featured = _illustrations.where((item) => item.isFeatured).length;
    final categories = getCategoryCounts();
    
    return {
      'total': total,
      'featured': featured,
      'regular': total - featured,
      'categories': categories,
      'latestDate': _illustrations.isNotEmpty 
          ? _illustrations.map((item) => item.createdAt).reduce((a, b) => a.isAfter(b) ? a : b)
          : null,
    };
  }
}

class AddIllustrationForm extends StatefulWidget {
  const AddIllustrationForm({super.key});

  @override
  _AddIllustrationFormState createState() => _AddIllustrationFormState();
}

class _AddIllustrationFormState extends State<AddIllustrationForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final IllustrationStorage _storage = IllustrationStorage();
  
  String title = '';
  String description = '';
  String category = 'Oil Paintings';
  bool isFeatured = false;
  File? _selectedImage;
  String? _selectedImageName;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Show initial data info
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stats = _storage.getStatistics();
      _showSuccessMessage(
        'Welcome! ${stats['total']} illustrations loaded (${stats['featured']} featured)'
      );
    });
  }

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
        
        _showSuccessMessage('Image selected: $_selectedImageName');
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

  // Show success message with data count
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

  // Show data summary dialog with enhanced statistics
  void _showDataSummary() {
    final stats = _storage.getStatistics();
    final categories = stats['categories'] as Map<String, int>;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.analytics, color: Colors.purple),
              SizedBox(width: 8),
              Text('Gallery Statistics'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview stats
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple[50]!, Colors.purple[100]!],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.palette, color: Colors.purple[600], size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Gallery Overview',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('📊 Total Illustrations: ${stats['total']}'),
                      Text('⭐ Featured: ${stats['featured']}'),
                      Text('📁 Regular: ${stats['regular']}'),
                      Text('📂 Categories: ${categories.length}'),
                    ],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Category breakdown
                Text('Category Breakdown:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                ...categories.entries.map((entry) => Container(
                  margin: EdgeInsets.only(bottom: 4),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key, style: TextStyle(fontSize: 14)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.purple[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${entry.value}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                
                SizedBox(height: 16),
                
                // Quick actions
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _showAllDataDialog();
                              },
                              icon: Icon(Icons.view_list, size: 16),
                              label: Text('View All', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _showResetDialog();
                              },
                              icon: Icon(Icons.refresh, size: 16),
                              label: Text('Reset', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Show reset dialog
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Reset Data'),
            ],
          ),
          content: Text(
            'This will remove all your custom illustrations and restore only the default sample data. This action cannot be undone.\n\nAre you sure you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _storage.resetToDefault();
                Navigator.pop(context);
                setState(() {}); // Refresh UI
                _showSuccessMessage('Data reset to default samples successfully!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  // Show all stored data
  void _showAllDataDialog() {
    final allIllustrations = _storage.getAllIllustrations();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: double.infinity,
            height: 500,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.storage, color: Colors.purple),
                    SizedBox(width: 8),
                    Text(
                      'All Illustrations (${allIllustrations.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                Expanded(
                  child: allIllustrations.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No illustrations yet',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
  itemCount: allIllustrations.length,
  itemBuilder: (context, index) {
    final illustration = allIllustrations[index];
    final isDefault = illustration.id.startsWith('default_');
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isDefault ? Colors.blue[100] : Colors.purple[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImageWidgetForList(illustration),
          ),
        ),
        title: Text(
          illustration.title,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(illustration.category),
                if (isDefault) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'DEFAULT',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ] else ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'DEVICE',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (illustration.description.isNotEmpty)
              Text(
                illustration.description.length > 50
                    ? '${illustration.description.substring(0, 50)}...'
                    : illustration.description,
                style: TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (illustration.imagePath != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'IMG',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              ),
            SizedBox(width: 4),
            if (illustration.isFeatured)
              Icon(Icons.star, color: Colors.amber),
          ],
        ),
      ),
    );
  },
),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Add this method inside _AddIllustrationFormState class

// Build image widget for list display
Widget _buildImageWidgetForList(Illustration illustration) {
  final imagePath = illustration.imagePath;
  final imageName = illustration.imageName;
  final isDefault = illustration.id.startsWith('default_');
  
  // Priority 1: Real device image file
  if (imagePath != null && imagePath.isNotEmpty && !kIsWeb) {
    final imageFile = File(imagePath);
    if (imageFile.existsSync()) {
      return Image.file(
        imageFile,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholderForList(imageName, isDefault);
        },
      );
    }
  }
  
  // Priority 2: Network image (for testing)
  if (imageName != null && (imageName.startsWith('http') || imageName.startsWith('https'))) {
    return Image.network(
      imageName,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildImagePlaceholderForList(imageName, isDefault);
      },
    );
  }
  
  // Priority 3: Asset image
  if (imageName != null && imageName.isNotEmpty) {
    return Image.asset(
      'assets/images/$imageName',
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildImagePlaceholderForList(imageName, isDefault);
      },
    );
  }
  
  // Fallback placeholder
  return _buildImagePlaceholderForList(imageName, isDefault);
}

// Build placeholder for list items
Widget _buildImagePlaceholderForList(String? imageName, bool isDefault) {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDefault 
            ? [Colors.blue[100]!, Colors.blue[200]!]
            : [Colors.purple[100]!, Colors.purple[200]!],
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image,
          size: 20,
          color: isDefault ? Colors.blue[600] : Colors.purple[600],
        ),
        if (imageName != null && imageName.isNotEmpty) ...[
          SizedBox(height: 2),
          Text(
            imageName.length > 8 ? '${imageName.substring(0, 5)}...' : imageName,
            style: TextStyle(
              fontSize: 6,
              color: isDefault ? Colors.blue[700] : Colors.purple[700],
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
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
          Row(
            children: [
              Text(
                'Upload Image *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              // Data count indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_storage.count} stored',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          
          GestureDetector(
            onTap: _showImageSourceDialog,
            child: Container(
              width: double.infinity,
              height: 180,
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
                size: 16,
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
              padding: EdgeInsets.all(8),
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
                size: 16,
              ),
            ),
          ),
        ),
        
        // Image name overlay
        if (_selectedImageName != null)
          Positioned(
            bottom: 10,
            left: 10,
            right: 50,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedImageName!.length > 20 
                    ? '${_selectedImageName!.substring(0, 17)}...'
                    : _selectedImageName!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
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
              size: 40,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 12),
          Text(
            _selectedImageName ?? 'Selected Image',
            style: TextStyle(
              fontSize: 16,
              color: Colors.purple[800],
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '✓ Ready to upload',
              style: TextStyle(
                fontSize: 12,
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
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(
            Icons.add_photo_alternate,
            size: 40,
            color: Colors.grey[500],
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Tap to upload image',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Sample • Gallery${!kIsWeb ? " • Camera" : ""}',
          style: TextStyle(
            fontSize: 12,
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
        actions: [
          // View data button with enhanced badge  
          IconButton(
            onPressed: _showDataSummary,
            icon: Stack(
              children: [
                Icon(Icons.analytics, color: Colors.white),
                if (_storage.count > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${_storage.count}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            tooltip: 'View gallery statistics',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced platform info with data count
                Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[50]!, Colors.blue[100]!],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kIsWeb 
                                  ? 'Running on Web Platform'
                                  : 'Running on Mobile Platform',
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Gallery loaded with ${_storage.getFeaturedIllustrations().length} featured items',
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_storage.count} total',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
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
                  initialValue: category,
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
                      'Featured illustrations appear in the favorites gallery automatically',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    value: isFeatured,
                    activeThumbColor: Colors.purple,
                    onChanged: (val) => setState(() => isFeatured = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Submit Button with enhanced functionality
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
                              
                              // Create and store illustration data
                              final newIllustration = Illustration(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                title: title,
                                description: description,
                                category: category,
                                isFeatured: isFeatured,
                                imagePath: _selectedImage?.path,
                                imageName: _selectedImageName,
                                createdAt: DateTime.now(),
                              );
                              
                              // Simulate upload process
                              Future.delayed(Duration(seconds: 2), () {
                                // Save to storage
                                _storage.addIllustration(newIllustration);
                                
                                setState(() {
                                  _isUploading = false;
                                });
                                
                                final stats = _storage.getStatistics();
                                _showSuccessMessage(
                                  '🎨 "$title" added! ${isFeatured ? "Now featured in favorites!" : ""} Total: ${stats['total']}'
                                );
                                
                                // Reset form
                                _formKey.currentState!.reset();
                                setState(() {
                                  _selectedImage = null;
                                  _selectedImageName = null;
                                  category = 'Oil Paintings';
                                  isFeatured = false;
                                  title = '';
                                  description = '';
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
                                'Saving to Gallery...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_to_photos),
                              SizedBox(width: 8),
                              Text(
                                'Add to Gallery',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage in another part of your app:
class IllustrationListScreen extends StatelessWidget {
  final IllustrationStorage storage = IllustrationStorage();

  IllustrationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final illustrations = storage.getAllIllustrations();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('All Illustrations (${illustrations.length})'),
      ),
      body: ListView.builder(
        itemCount: illustrations.length,
        itemBuilder: (context, index) {
          final illustration = illustrations[index];
          return ListTile(
            title: Text(illustration.title),
            subtitle: Text('${illustration.category} • ${illustration.createdAt}'),
            trailing: illustration.isFeatured ? Icon(Icons.star) : null,
          );
        },
      ),
    );
  }
}