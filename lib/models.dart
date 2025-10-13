// Product model
class Product {
  final String id;
  final String code;
  final String name;
  final String nameKhmer;
  final double price;
  final String? imageUrl;
  final String? localImagePath;
  int quantity;

  Product({
    required this.id,
    required this.code,
    required this.name,
    required this.nameKhmer,
    required this.price,
    this.imageUrl,
    this.localImagePath,
    this.quantity = 1,
  });
}

// Outlet model
class Outlet {
  final String id;
  final String name;
  final String address;
  final bool isActive;

  Outlet({
    required this.id,
    required this.name,
    required this.address,
    this.isActive = true,
  });
}

// Ticket model
class Ticket {
  final String id;
  final DateTime createdAt;
  final String outletId;
  final String? notes;
  final List<Product> products;
  final double totalAmount;
  

  Ticket({
    required this.id,
    required this.createdAt,
    required this.outletId,
    this.notes,
    required this.products,
    required this.totalAmount,
  });
}