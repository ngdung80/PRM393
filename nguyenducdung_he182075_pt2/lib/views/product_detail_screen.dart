// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../viewmodels/product_detail_viewmodel.dart';

/// View: Màn hình chi tiết sản phẩm.
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductDetailViewModel(product: product),
      child: const _ProductDetailView(),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget nội bộ: Toàn bộ UI chi tiết sản phẩm
// ---------------------------------------------------------------------------
class _ProductDetailView extends StatefulWidget {
  const _ProductDetailView();

  @override
  State<_ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<_ProductDetailView> {
  int _selectedIndex = 1;

  static const Color _primaryBlue = Color(0xFF1A73E8);
  static const Color _lightBlue = Color(0xFF4A90E2);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductDetailViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Product Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryBlue, _lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ảnh sản phẩm lớn ở trên nền trắng
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Hero(
                  tag: 'product-img-${vm.product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      vm.product.imageUrl,
                      width: 220,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 220,
                        height: 220,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported,
                            size: 60, color: Colors.grey),
                      ),
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          width: 220,
                          height: 220,
                          color: Colors.grey[100],
                          child: const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF1A73E8)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Thông tin sản phẩm
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Text(
                    vm.product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Rating
                  Row(
                    children: [
                      ...List.generate(4, (i) => const Icon(
                            Icons.star,
                            color: Color(0xFFFFB800),
                            size: 16,
                          )),
                      const Icon(Icons.star_half,
                          color: Color(0xFFFFB800), size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '4.5 / 120 reviews',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Giá
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (vm.hasDiscount) ...[
                        Text(
                          '\$${vm.product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        '\$${vm.discountedPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A73E8),
                        ),
                      ),
                      if (vm.hasDiscount) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${vm.product.discountPercent.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Divider(color: Color(0xFFEEEEEE), thickness: 1),
                  const SizedBox(height: 16),

                  // Mô tả
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vm.product.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Nút Add to Cart (chỉ hiển thị, không có chức năng)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 20,
                      ),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        // Không làm gì
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            // Home → quay về màn hình danh sách sản phẩm
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1A73E8),
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Product Detail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}
