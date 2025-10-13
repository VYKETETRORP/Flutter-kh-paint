import 'package:flutter/material.dart';
import 'cart_screan_2.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  String selectedCategory = 'Popular';

  final List<String> categories = ['Popular', 'Coffee', 'Chicken'];

  final List<MenuItem> menuItems = [
    MenuItem(
      name: 'Coffee Latte',
      price: 6.90,
      image: 'assets/images/coffee_latte.jpg',
      category: 'Popular',
      description:
          'Rich and creamy coffee latte made with premium espresso beans and steamed milk (For ref only)',
    ),
    MenuItem(
      name: 'Chicken Burger',
      price: 8.50,
      image: 'assets/images/chicken_burger.jpg',
      category: 'Popular',
      description:
          'Juicy grilled chicken burger with fresh lettuce, tomato and special sauce (For ref only)',
    ),
    MenuItem(
      name: 'Pan Pizza Seafood (M)',
      price: 13.20,
      image: 'assets/images/pepperoni_pizza.jpg',
      category: 'Popular',
      description:
          'Pan crust pizza topped with pizza sauce, cheese, shrimp, crab stick, squid, mussels and pineapple (For ref only)',
    ),
    MenuItem(
      name: 'Spaghetti Carbonara',
      price: 10.50,
      image: 'assets/images/spaghetti_carbonara.jpg',
      category: 'Popular',
      description:
          'Classic Italian pasta with creamy sauce, bacon and parmesan cheese (For ref only)',
    ),
  ];

  List<MenuItem> get filteredItems {
    if (selectedCategory == 'Popular') {
      return menuItems;
    }
    return menuItems
        .where((item) => item.category == selectedCategory)
        .toList();
  }

  void _showItemDetail(MenuItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ItemDetailModal(item: item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search ...',
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Tabs
          Container(
            height: 50,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 24),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected ? Colors.black : Colors.grey[600],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Subtitle
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Text(
              'Most ordered right now.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),

          // Menu Items Grid
          Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                padding: EdgeInsets.only(bottom: 100),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return MenuItemCard(
                    item: item,
                    onTap: () => _showItemDetail(item), // Add onTap callback
                  );
                },
              ),
            ),
          ),
        ],
      ),
     
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback? onTap;

  const MenuItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Add GestureDetector for tap functionality
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.grey[200],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey[200],
                        child: item.image.isNotEmpty
                            ? Image.asset(
                                item.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholderImage();
                                },
                              )
                            : _buildPlaceholderImage(),
                      ),
                    ),
                    // Add Button
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Add to cart functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.name} added to cart'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.add,
                            color: Colors.grey[700],
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Item Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$ ${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[200]!, Colors.red[200]!],
        ),
      ),
      child: Icon(Icons.restaurant, color: Colors.white, size: 40),
    );
  }
}

// Item Detail Modal Widget
class ItemDetailModal extends StatefulWidget {
  final MenuItem item;

  const ItemDetailModal({super.key, required this.item});

  @override
  State<ItemDetailModal> createState() => _ItemDetailModalState();
}

class _ItemDetailModalState extends State<ItemDetailModal> {
  int quantity = 1;
  List<AddOnItem> selectedAddOns = [];

  final List<AddOnItem> availableAddOns = [
    AddOnItem(
      name: 'French Fries',
      price: 3.80,
      image: 'assets/images/french_fries.jpg',
    ),
    AddOnItem(
      name: 'BBQ Chicken Wings',
      price: 5.50,
      image: 'assets/images/bbq_wings.jpg',
    ),
    AddOnItem(
      name: 'Spicy Corner Crispy Wings 6pcs',
      price: 6.10,
      image: 'assets/images/spicy_wings.jpg',
    ),
    AddOnItem(
      name: 'Pan Pizza Hawaiian (S)',
      price: 6.90,
      image: 'assets/images/hawaiian_pizza.jpg',
    ),
  ];

  double get totalPrice {
    double addOnTotal = selectedAddOns.fold(
      0.0,
      (sum, item) => sum + item.price,
    );
    return (widget.item.price + addOnTotal) * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header with image
          Container(
            height: 300,
            width: double.infinity,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey[200],
                    child: widget.item.image.isNotEmpty
                        ? Image.asset(
                            widget.item.image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                          )
                        : _buildPlaceholderImage(),
                  ),
                ),
                // Close button
                Positioned(
                  top: 40,
                  left: 16,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item name and price
                  Text(
                    widget.item.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$ ${widget.item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Description
                  Text(
                    widget.item.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Frequently bought together section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Frequently bought together',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Other customers also ordered these',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'Optional',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Add-ons list
                  ...availableAddOns.map((addOn) {
                    final isSelected = selectedAddOns.contains(addOn);
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          // Add-on image
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: addOn.image.isNotEmpty
                                  ? Image.asset(
                                      addOn.image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.restaurant,
                                              color: Colors.grey,
                                            );
                                          },
                                    )
                                  : Icon(Icons.restaurant, color: Colors.grey),
                            ),
                          ),
                          SizedBox(width: 12),

                          // Add-on details
                          Expanded(
                            child: Text(
                              addOn.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // Price and checkbox
                          Text(
                            '+ \$ ${addOn.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedAddOns.remove(addOn);
                                } else {
                                  selectedAddOns.add(addOn);
                                }
                              });
                            },
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(4),
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Bottom section with quantity and add to cart
          Container(
            padding: EdgeInsets.all(20),
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
            child: Row(
              children: [
                // Quantity controls
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: quantity > 1
                            ? () {
                                setState(() {
                                  quantity--;
                                });
                              }
                            : null,
                        icon: Icon(Icons.remove, size: 18),
                        constraints: BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                      ),
                      Container(
                        width: 40,
                        child: Text(
                          '$quantity',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: Icon(Icons.add, size: 18),
                        constraints: BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 16),

                // Add to cart button
                Expanded(
                  child: // Update the Add to cart button in ItemDetailModal:
                  ElevatedButton(
                    onPressed: () {
                      // Create cart item
                      CartItem cartItem = CartItem(
                        name: widget.item.name,
                        price: widget.item.price,
                        originalPrice: null,
                        quantity: quantity,
                        image: widget.item.image,
                      );

                      // Add selected add-ons to the cart item name/price
                      double totalItemPrice = widget.item.price;
                      String itemName = widget.item.name;

                      if (selectedAddOns.isNotEmpty) {
                        totalItemPrice += selectedAddOns.fold(
                          0.0,
                          (sum, addon) => sum + addon.price,
                        );
                        itemName += ' + ${selectedAddOns.length} add-on(s)';
                      }

                      cartItem = CartItem(
                        name: itemName,
                        price: totalItemPrice,
                        originalPrice: null,
                        quantity: quantity,
                        image: widget.item.image,
                      );

                      // Navigate to cart screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              CartScreen(cartItems: [cartItem]),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Add to cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[200]!, Colors.red[200]!],
        ),
      ),
      child: Icon(Icons.restaurant, color: Colors.white, size: 80),
    );
  }
}

class MenuItem {
  final String name;
  final double price;
  final String image;
  final String category;
  final String description;

  MenuItem({
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
  });
}

class AddOnItem {
  final String name;
  final double price;
  final String image;

  AddOnItem({required this.name, required this.price, required this.image});
}

// Usage example
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Screen Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ItemScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
