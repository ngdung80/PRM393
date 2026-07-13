import '../models/product.dart';

class ProductRepository {
  // Mock product database
  final List<Product> _products = const [
    Product(
      id: 1,
      name: 'iPhone 15 Pro Max',
      description:
          'Experience titanium design, 5x Telephoto camera, and the industry-leading A17 Pro chip for top-tier mobile performance.',
      price: 1199.00,
      discountPercent: 10.0,
      imageUrl:
          'https://images.unsplash.com/photo-1695048133142-1a20484d2569?q=80&w=600',
    ),
    Product(
      id: 2,
      name: 'MacBook Pro M3 Max',
      description:
          'The ultimate professional laptop. Powered by the M3 Max chip, featuring a stunning Liquid Retina XDR display and up to 22 hours of battery life.',
      price: 2499.00,
      discountPercent: 12.0,
      imageUrl:
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=600',
    ),
    Product(
      id: 3,
      name: 'Sony WH-1000XM5',
      description:
          'Industry-leading noise-canceling wireless headphones. Experience gold-standard sound quality, crystal-clear hands-free calling, and long-lasting comfort.',
      price: 399.00,
      discountPercent: 15.0,
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=600',
    ),
    Product(
      id: 4,
      name: 'Apple Watch Ultra 2',
      description:
          'The ultimate sports and adventure watch. Featuring a rugged titanium case, dual-frequency GPS, and up to 72 hours of battery life in low-power mode.',
      price: 799.00,
      discountPercent: 5.0,
      imageUrl:
          'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?q=80&w=600',
    ),
    Product(
      id: 5,
      name: 'iPad Air M1',
      description:
          'Supercharged by the Apple M1 chip. 10.9-inch Liquid Retina display, 12MP Ultra Wide front camera with Center Stage, and compatibility with Apple Pencil.',
      price: 599.00,
      discountPercent: 20.0,
      imageUrl:
          'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?q=80&w=600',
    ),
    Product(
      id: 6,
      name: 'Kindle Paperwhite 11th Gen',
      description:
          'Purpose-built for reading. Now with a 6.8" display, thinner borders, adjustable warm light, and up to 10 weeks of battery life.',
      price: 139.00,
      discountPercent: 8.0,
      imageUrl:
          'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=600',
    ),
    Product(
      id: 7,
      name: 'Sony PlayStation 5 Slim',
      description:
          'Experience lightning-fast loading with an ultra-high-speed SSD, deeper immersion with support for haptic feedback, adaptive triggers, and 3D Audio.',
      price: 499.00,
      discountPercent: 0.0,
      imageUrl:
          'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?q=80&w=600',
    ),
    Product(
      id: 8,
      name: 'Nintendo Switch OLED Model',
      description:
          'Play at home on the TV or on-the-go with a vibrant 7-inch OLED screen, a wide adjustable stand, a wired LAN port, and 64 GB of internal storage.',
      price: 349.00,
      discountPercent: 6.0,
      imageUrl:
          'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?q=80&w=600',
    ),
    Product(
      id: 9,
      name: 'Bose SoundLink Flex',
      description:
          'A waterproof outdoor speaker built to go wherever you go. Delivers deep, clear, immersive sound in a highly durable, rugged form factor.',
      price: 149.00,
      discountPercent: 10.0,
      imageUrl:
          'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?q=80&w=600',
    ),
    Product(
      id: 10,
      name: 'DJI Mini 4 Pro Drone',
      description:
          'Mini drone under 249 grams with a high-performance 4K HDR camera, 34-minute flight time, omnidirectional obstacle sensing, and automated tracking.',
      price: 759.00,
      discountPercent: 15.0,
      imageUrl:
          'https://images.unsplash.com/photo-1508614589041-895b88991e3e?q=80&w=600',
    ),
  ];

  /// Returns all available products.
  List<Product> getAllProducts() {
    return _products;
  }

  /// Searches for products whose names contain the given query string (case-insensitive).
  List<Product> findProductsByName(String query) {
    if (query.trim().isEmpty) {
      return _products;
    }
    return _products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase().trim()))
        .toList();
  }
}
