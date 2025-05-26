class Product {
  final int? id;
  final String name;
  final String category;
  final int quantity;
  final double price;
  final String? description;
  final String? location;
  final DateTime createdAt;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.price,
    this.description,
    this.location,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'price': price,
      'description': description,
      'location': location,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: map['category'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] is int ? (map['price'] as int).toDouble() : map['price'] as double,
      description: map['description'] as String?,
      location: map['location'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Product copyWith({
    int? id,
    String? name,
    String? category,
    int? quantity,
    double? price,
    String? description,
    String? location,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      description: description ?? this.description,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 