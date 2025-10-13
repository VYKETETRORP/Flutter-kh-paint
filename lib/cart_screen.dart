import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart'; 


class CartScreen extends StatefulWidget {
  final Ticket ticket;

  const CartScreen({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Product> _cartProducts;
  TextEditingController _promoController = TextEditingController();
  
  // Cart calculations
  double get _subtotal {
    return _cartProducts.fold(0.0, (sum, product) => sum + (product.price * product.quantity));
  }
  
  double get _deliveryFee => 5.0; // Fixed delivery fee
  
  double get _total => _subtotal + _deliveryFee;

  @override
  void initState() {
    super.initState();
    _cartProducts = List.from(widget.ticket.products);
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity > 0) {
      setState(() {
        _cartProducts[index].quantity = newQuantity;
      });
    }
  }

  void _removeProduct(int index) {
    setState(() {
      _cartProducts.removeAt(index);
    });
  }

  void _applyPromoCode() {
    // Implement promo code logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Promo code applied!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _proceedToCheckout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text('Order Confirmed!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your order has been placed successfully.'),
              SizedBox(height: 8),
              Text(
                'Order ID: ${widget.ticket.id}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Total: \$${_total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: Text('OK'),
            ),
          ],
        );
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cart',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.black),
            onPressed: () {
              setState(() {
                _cartProducts.clear();
              });
            },
          ),
        ],
      ),
      body: _cartProducts.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Cart Items
                        ..._cartProducts.asMap().entries.map((entry) {
                          final index = entry.key;
                          final product = entry.value;
                          return _buildCartItem(product, index);
                        }).toList(),
                        
                        SizedBox(height: 20),
                        
                        // Promo Code Section
                        _buildPromoCodeSection(),
                        
                        SizedBox(height: 20),
                        
                        // Summary Section
                        _buildSummarySection(),
                        
                        SizedBox(height: 100), // Space for checkout button
                      ],
                    ),
                  ),
                ),
                
                // Checkout Button (Fixed at bottom)
                _buildCheckoutButton(),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add some products to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Product product, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.local_cafe,
              color: Colors.orange[600],
              size: 30,
            ),
          ),
          
          SizedBox(width: 16),
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity Controls
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (product.quantity > 1) {
                    _updateQuantity(index, product.quantity - 1);
                  } else {
                    _removeProduct(index);
                  }
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: product.quantity == 1 ? Colors.red[100] : Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    product.quantity == 1 ? Icons.delete : Icons.remove,
                    size: 18,
                    color: product.quantity == 1 ? Colors.red : Colors.grey[600],
                  ),
                ),
              ),
              
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '${product.quantity}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              GestureDetector(
                onTap: () => _updateQuantity(index, product.quantity + 1),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Row(
        children: [
          Icon(Icons.local_offer_outlined, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _promoController,
              decoration: InputDecoration(
                hintText: 'Promo code',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
            ),
          ),
          TextButton(
            onPressed: _applyPromoCode,
            child: Text(
              'Apply',
              style: TextStyle(
                color: Colors.green[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: EdgeInsets.all(20),
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
        children: [
          _buildSummaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}', false),
          SizedBox(height: 12),
          _buildSummaryRow('Delivery', '\$${_deliveryFee.toStringAsFixed(2)}', false),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 16),
          _buildSummaryRow('Total', '\$${_total.toStringAsFixed(2)}', true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.green[600] : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
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
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _cartProducts.isEmpty ? null : _proceedToCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[500],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: Text(
              'Checkout • \$${_total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}