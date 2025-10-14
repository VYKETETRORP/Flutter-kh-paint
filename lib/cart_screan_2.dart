import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, this.cartItems = const []});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];
  // String selectedDelivery = 'Standard (5-20 mins)';

  final List<PopularItem> popularItems = [
    PopularItem(
      name: '96. Jasmine Rice',
      price: 0.88,
      originalPrice: null,
      image: 'assets/2.jpg',
    ),
    PopularItem(
      name: '17. Iced Cappuccino',
      price: 1.89,
      originalPrice: 3.78,
      image: 'assets/1.jpg',
    ),
    PopularItem(
      name: '76. Grilled Pork',
      price: 5.29,
      originalPrice: null,
      image: 'assets/3.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    cartItems = List.from(widget.cartItems);
    if (cartItems.isEmpty) {
      // Add sample item
      cartItems.add(
        CartItem(
          name: '54.Thai Iced Tea',
          price: 1.62,
          originalPrice: 3.24,
          quantity: 1,
          image: 'assets/4.jpg',
        ),
      );
    }
  }

  double get subtotal {
    return cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get total {
    return subtotal; // Add tax/fees calculation if needed
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index].quantity = newQuantity;
      }
    });
  }

  void _addPopularItem(PopularItem item) {
    setState(() {
      // Check if item already exists in cart
      int existingIndex = cartItems.indexWhere((cartItem) => cartItem.name == item.name);
      
      if (existingIndex != -1) {
        cartItems[existingIndex].quantity += 1;
      } else {
        cartItems.add(
          CartItem(
            name: item.name,
            price: item.price,
            originalPrice: item.originalPrice,
            quantity: 1,
            image: item.image,
          ),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart'),
        duration: Duration(seconds: 1),
      ),
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
          icon: Icon(Icons.close, color: Colors.black),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'Black Canyon (Battambang)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                _buildProgressStep(1, 'Menu', true, true),
                Expanded(child: Container(height: 2, color: Colors.grey[300])),
                _buildProgressStep(2, 'Cart', true, false),
                Expanded(child: Container(height: 2, color: Colors.grey[300])),
                _buildProgressStep(3, 'Checkout', false, false),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),

                  // Cart items
                  ...cartItems.asMap().entries.map((entry) {
                    int index = entry.key;
                    CartItem item = entry.value;
                    
                    return Container(
                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Row(
                        children: [
                          // Item image
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: item.image.isNotEmpty
                                  ? Image.asset(
                                      item.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Colors.orange[200]!, Colors.red[200]!],
                                            ),
                                          ),
                                          child: Icon(Icons.local_cafe, color: Colors.white),
                                        );
                                      },
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.orange[200]!, Colors.red[200]!],
                                        ),
                                      ),
                                      child: Icon(Icons.local_cafe, color: Colors.white),
                                    ),
                            ),
                          ),

                          SizedBox(width: 16),

                          // Item details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    // Quantity controls
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: item.quantity > 1
                                                ? Icon(Icons.remove, size: 18)
                                                : Icon(Icons.delete_outline, size: 18),
                                            onPressed: () => _updateQuantity(index, item.quantity - 1),
                                            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                                            padding: EdgeInsets.zero,
                                          ),
                                          Container(
                                            width: 30,
                                            child: Text(
                                              '${item.quantity}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => _updateQuantity(index, item.quantity + 1),
                                            icon: Icon(Icons.add, size: 18),
                                            constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    // Price
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '\$ ${(item.price * item.quantity).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        ),
                                        if (item.originalPrice != null)
                                          Text(
                                            '\$ ${(item.originalPrice! * item.quantity).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  // Add more items button
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.add, color: Colors.grey[700]),
                      label: Text(
                        'Add more items',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Popular with your order
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Popular with your order',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Other customers also bought these',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Popular items
                  Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: popularItems.length,
                      itemBuilder: (context, index) {
                        final item = popularItems[index];
                        return Container(
                          width: 160,
                          margin: EdgeInsets.only(right: 12),
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
                              // Image
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                    color: Colors.grey[200],
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: item.image.isNotEmpty
                                              ? Image.asset(
                                                  item.image,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [Colors.orange[200]!, Colors.red[200]!],
                                                        ),
                                                      ),
                                                      child: Icon(Icons.restaurant, color: Colors.white, size: 40),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [Colors.orange[200]!, Colors.red[200]!],
                                                    ),
                                                  ),
                                                  child: Icon(Icons.restaurant, color: Colors.white, size: 40),
                                                ),
                                        ),
                                      ),
                                      // Add button
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
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            onPressed: () => _addPopularItem(item),
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.add, size: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Item details
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '\$ ${item.price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        if (item.originalPrice != null) ...[
                                          SizedBox(width: 8),
                                          Text(
                                            '\$ ${item.originalPrice!.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[500],
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$ ${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '\$ ${(total * 1.1).toStringAsFixed(2)}', // Simulated original price
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            // Checkout button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: cartItems.isEmpty ? null : () {
                  // Navigate to checkout
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(cartItems: cartItems),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text(
                  'Review payment and address',
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
    );
  }

  Widget _buildProgressStep(int step, String title, bool isCompleted, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.black : (isActive ? Colors.grey[800] : Colors.grey[300]),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
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
            color: isCompleted || isActive ? Colors.black : Colors.grey[500],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class CartItem {
  final String name;
  final double price;
  final double? originalPrice;
  int quantity;
  final String image;

  CartItem({
    required this.name,
    required this.price,
    this.originalPrice,
    required this.quantity,
    required this.image,
  });
}

class PopularItem {
  final String name;
  final double price;
  final double? originalPrice;
  final String image;

  PopularItem({
    required this.name,
    required this.price,
    this.originalPrice,
    required this.image,
  });
}

// Placeholder checkout screen
class CheckoutScreen extends StatelessWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Center(
        child: Text('Checkout Screen - ${cartItems.length} items'),
      ),
    );
  }
}