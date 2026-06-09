import 'package:exam/Entity/Product.dart';
import 'package:exam/Navigation/ProductNavigator.dart';
import 'package:flutter/material.dart';

/// Item sản phẩm — tap để mở trang chi tiết (file mới).
class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => ProductNavigator.openDetail(context, product),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: product.image != null
                  ? Image.asset(product.image!, fit: BoxFit.cover)
                  : const ColoredBox(color: Colors.grey),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${product.price.toStringAsFixed(0)} đ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mã: ${product.id}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
