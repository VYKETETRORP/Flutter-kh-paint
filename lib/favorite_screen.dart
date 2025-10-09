import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'widgets/bottom_navigation.dart';
import 'form.dart'; // Import your form file to access IllustrationStorage

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Get storage instance
  final IllustrationStorage _storage = IllustrationStorage();
  
  // List to track which items are marked as favorites
  List<String> favoriteIds = [];

  @override
  void initState() {
    super.initState();
    // Load favorites - mark featured items as favorites automatically
    _loadFavorites();
  }

  void _loadFavorites() {
    final allIllustrations = _storage.getAllIllustrations();
    setState(() {
      favoriteIds = allIllustrations
          .where((item) => item.isFeatured)
          .map((item) => item.id)
          .toList();
    });
  }

  // Convert storage data to match your existing UI format
  List<Map<String, dynamic>> get favoriteItems {
    final allIllustrations = _storage.getAllIllustrations();
    final favorites = allIllustrations
        .where((item) => favoriteIds.contains(item.id))
        .toList();

    return favorites.map((item) {
      return {
        'id': item.id,
        'title': item.title,
        'imagePath': item.imagePath, // Real image path from form
        'imageName': item.imageName, // Image name from form
        'category': item.category,
        'price': '\$${(100 + (item.title.length * 10))}',
        'addedDate': _getTimeAgo(item.createdAt),
        'isFavorite': true,
        'description': item.description,
        'originalItem': item, // Keep reference to original item
      };
    }).toList();
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return 'Added ${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return 'Added ${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return 'Added ${difference.inMinutes} minutes ago';
    } else {
      return 'Added just now';
    }
  }

  // Add item to favorites
  void _addToFavorites(String id) {
    setState(() {
      if (!favoriteIds.contains(id)) {
        favoriteIds.add(id);
      }
    });
  }

  // Toggle favorite status
  void _toggleFavorite(String id) {
    if (favoriteIds.contains(id)) {
      setState(() {
        favoriteIds.remove(id);
      });
    } else {
      _addToFavorites(id);
    }
  }

  // Main image widget for cards and details
  Widget _buildImageWidget(Map<String, dynamic> item, {double? width, double? height}) {
    // Extract the original Illustration object if available
    final originalItem = item['originalItem'] as Illustration?;
    final imagePath = originalItem?.imagePath ?? item['imagePath'];
    final imageName = originalItem?.imageName ?? item['imageName'];
    final isDefault = originalItem?.id.startsWith('default_') ?? false;
    
    // Priority 1: Real device image file
    if (imagePath != null && imagePath.isNotEmpty && !kIsWeb) {
      final imageFile = File(imagePath);
      if (imageFile.existsSync()) {
        return Image.file(
          imageFile,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildImagePlaceholder(imageName, isDefault: isDefault, width: width, height: height);
          },
        );
      }
    }
    
    // Priority 2: Network image (for testing/URLs)
    if (imageName != null && (imageName.startsWith('http') || imageName.startsWith('https'))) {
      return Image.network(
        imageName,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder(imageName, isDefault: isDefault, width: width, height: height);
        },
      );
    }
    
    // Priority 3: Asset image (for default illustrations)
    if (imageName != null && imageName.isNotEmpty) {
      return Image.asset(
        'assets/images/$imageName',
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder(imageName, isDefault: isDefault, width: width, height: height);
        },
      );
    }
    
    // Fallback to placeholder
    return _buildImagePlaceholder(imageName, isDefault: isDefault, width: width, height: height);
  }

  // Enhanced image placeholder with better visuals
  Widget _buildImagePlaceholder(String? imageName, {bool isDefault = false, double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDefault 
              ? [Colors.blue[100]!, Colors.blue[200]!]
              : [Colors.purple[100]!, Colors.purple[200]!],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            imageName != null ? Icons.image : Icons.add_photo_alternate,
            size: width != null ? (width * 0.4).clamp(20.0, 40.0) : 30,
            color: isDefault ? Colors.blue[600] : Colors.purple[600],
          ),
          if (imageName != null) ...[
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                imageName.length > 12 ? '${imageName.substring(0, 9)}...' : imageName,
                style: TextStyle(
                  fontSize: width != null ? (width * 0.12).clamp(8.0, 10.0) : 8,
                  color: isDefault ? Colors.blue[700] : Colors.purple[700],
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Show source indicator
            Container(
              margin: EdgeInsets.only(top: 2),
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: isDefault ? Colors.blue[200] : Colors.green[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isDefault ? 'DEFAULT' : 'FORM',
                style: TextStyle(
                  fontSize: 6,
                  color: isDefault ? Colors.blue[800] : Colors.green[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else ...[
            SizedBox(height: 4),
            Text(
              'No Image',
              style: TextStyle(
                fontSize: width != null ? (width * 0.1).clamp(6.0, 8.0) : 8,
                color: isDefault ? Colors.blue[600] : Colors.purple[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Image widget specifically for list items
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
        borderRadius: BorderRadius.circular(8),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Favorites',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.pink,
              size: 28,
            ),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: favoriteItems.isEmpty
          ? _buildEmptyState()
          : _buildFavoritesList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAllIllustrationsDialog();
        },
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.pink, width: 2),
        ),
        child: const Icon(Icons.favorite),
      ),
      bottomNavigationBar: const CustomBottomNavigation(currentIndex: 2),
    );
  }

  Widget _buildEmptyState() {
    final totalItems = _storage.count;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.favorite_border,
                size: 80,
                color: Colors.pink[300],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              totalItems > 0
                  ? 'You have $totalItems illustrations. Add some to favorites!'
                  : 'Start exploring our gallery and add items to your favorites to see them here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (totalItems > 0) {
                  _showAllIllustrationsDialog();
                } else {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                totalItems > 0 ? 'Browse Gallery' : 'Explore Gallery',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    final favorites = favoriteItems;
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with count
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.pink[100]!,
                  Colors.pink[200]!,
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${favorites.length} Favorite Items',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'From ${_storage.count} total illustrations',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'YOUR COLLECTION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              letterSpacing: 1.2,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Favorites List
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return _buildFavoriteCard(favorites[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () {
            _showItemDetails(item);
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Image with proper handling
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildImageWidget(item, width: 80, height: 80),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item['category'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.pink[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            item['price'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item['addedDate'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Actions
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        _removeFromFavorites(item['id']);
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.pink,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _addToCart(item);
                      },
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.orange,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _removeFromFavorites(String id) {
    final item = favoriteItems.firstWhere((item) => item['id'] == id);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Row(
            children: [
              Icon(Icons.favorite_border, color: Colors.pink),
              SizedBox(width: 8),
              Text('Remove from Favorites'),
            ],
          ),
          content: Text(
            'Are you sure you want to remove "${item['title']}" from your favorites?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  favoriteIds.remove(id);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Removed from favorites'),
                    backgroundColor: Colors.pink,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _addToCart(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['title']} added to cart!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );
  }

  void _showItemDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image with proper handling
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: _buildImageWidget(item, height: 200),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Title and Category
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.pink[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item['category'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.pink[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (item['imageName'] != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 14,
                                    color: Colors.blue[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item['imageName'].length > 15 
                                        ? '${item['imageName'].substring(0, 12)}...'
                                        : item['imageName'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        item['addedDate'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      
                      // Show description if available
                      if (item['description'] != null && item['description'].isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                      ],
                      
                      const Spacer(),
                      
                      // Price and Actions
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                item['price'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(width: 20),
                          
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _addToCart(item);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Add to Cart',
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
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSearchDialog() {
    String searchQuery = '';
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Search Favorites'),
          content: TextField(
            onChanged: (value) {
              searchQuery = value;
            },
            decoration: InputDecoration(
              hintText: 'Search your favorite items...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _performSearch(searchQuery);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    
    final results = _storage.searchIllustrations(query);
    final favoriteResults = results.where((item) => favoriteIds.contains(item.id)).toList();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Search Results for "$query"'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: favoriteResults.isEmpty
                ? const Center(child: Text('No matching favorites found'))
                : ListView.builder(
                    itemCount: favoriteResults.length,
                    itemBuilder: (context, index) {
                      final item = favoriteResults[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.category),
                        leading: SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: _buildImageWidget({
                              'imagePath': item.imagePath,
                              'imageName': item.imageName,
                            }, width: 40, height: 40),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          final itemMap = {
                            'id': item.id,
                            'title': item.title,
                            'imagePath': item.imagePath,
                            'imageName': item.imageName,
                            'category': item.category,
                            'price': '\$${(100 + (item.title.length * 10))}',
                            'addedDate': _getTimeAgo(item.createdAt),
                            'isFavorite': true,
                            'description': item.description,
                            'originalItem': item,
                          };
                          _showItemDetails(itemMap);
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAllIllustrationsDialog() {
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.collections, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      'All Illustrations (${allIllustrations.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
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
                              const SizedBox(height: 16),
                              const Text(
                                'No illustrations yet',
                                style: TextStyle(
                                  color: Colors.grey,
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
                            final isFavorite = favoriteIds.contains(illustration.id);
                            
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: _buildImageWidget({
                                      'imagePath': illustration.imagePath,
                                      'imageName': illustration.imageName,
                                    }, width: 50, height: 50),
                                  ),
                                ),
                                title: Text(
                                  illustration.title,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(illustration.category),
                                    if (illustration.description.isNotEmpty)
                                      Text(
                                        illustration.description.length > 30
                                            ? '${illustration.description.substring(0, 30)}...'
                                            : illustration.description,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (illustration.isFeatured)
                                      const Icon(Icons.star, color: Colors.amber, size: 16),
                                    IconButton(
                                      onPressed: () {
                                        _toggleFavorite(illustration.id);
                                        setState(() {});
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isFavorite
                                                  ? '${illustration.title} removed from favorites'
                                                  : '${illustration.title} added to favorites',
                                            ),
                                            backgroundColor: isFavorite ? Colors.red : Colors.green,
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: Colors.pink,
                                      ),
                                    ),
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
}