import 'package:exam/Entity/Product.dart';
import 'package:flutter/material.dart';

/// Trang chi tiết sản phẩm (file mới, không sửa ProductDetailPage.dart gốc).
class ProductDetailViewPage extends StatelessWidget {
  final Product product;

  const ProductDetailViewPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (product.image != null)
              Image.asset(
                product.image!,
                height: 280,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 280,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported, size: 64),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mã sản phẩm: ${product.id}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${product.price.toStringAsFixed(0)} đ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Thêm vào giỏ hàng'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
