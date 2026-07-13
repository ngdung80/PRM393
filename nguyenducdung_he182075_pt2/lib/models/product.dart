// ignore_for_file: file_names
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double discountPercent;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discountPercent,
    required this.imageUrl,
  });

  // Calculate discounted price
  double get discountedPrice => price * (1 - discountPercent / 100);
}
