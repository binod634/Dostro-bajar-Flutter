class Product {
  int? id;
  String ownerName;
  String name;
  String? uuid;
  String description;
  int price;
  int quantity;
  String imageUrl;

  Product(
      {this.id,
      required this.name,
      required this.ownerName,
      this.uuid,
      required this.description,
      required this.price,
      required this.quantity,
      required this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String,
      ownerName: json['ownerName'] as String,
      uuid: json['uuid'] as String?,
      description: json['description'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ownerName': ownerName,
      'uuid': uuid,
      'description': description,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}
