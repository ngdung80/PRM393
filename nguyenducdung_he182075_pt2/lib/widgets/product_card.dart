// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isHorizontal;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.isHorizontal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double discPrice = product.discountedPrice;
    final bool hasDiscount = product.discountPercent > 0;

    if (isHorizontal) {
      return _buildHorizontalCard(discPrice, hasDiscount);
    } else {
      return _buildVerticalCard(discPrice, hasDiscount);
    }
  }

  // --- Horizontal (Row) card layout khi 1 cột ---
  Widget _buildHorizontalCard(double discPrice, bool hasDiscount) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.withOpacity(0.15), width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                // Hình ảnh sản phẩm
                Hero(
                  tag: 'product-img-${product.id}',
                  child: Image.network(
                    product.imageUrl,
                    width: 120,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      color: Colors.grey[200],
                      child: const Icon(
                          Icons.image_not_supported,
                          size: 30,
                          color: Colors.grey),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 120,
                        color: Colors.grey[100],
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Thông tin sản phẩm
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        _priceRow(discPrice, hasDiscount, 16, 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Badge discount góc trên bên phải của toàn bộ card
        if (hasDiscount)
          Positioned(
            top: 8,
            right: 8,
            child: _discountBadge(product.discountPercent),
          ),
      ],
    );
  }

  // --- Vertical (Grid) card layout khi 2 hoặc 3 cột ---
  Widget _buildVerticalCard(double discPrice, bool hasDiscount) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.withOpacity(0.15), width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hình ảnh sản phẩm
                Expanded(
                  child: Hero(
                    tag: 'product-img-${product.id}',
                    child: Image.network(
                      product.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey),
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[100],
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Thông tin sản phẩm
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      _priceRowWithFlexible(discPrice, hasDiscount),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Badge discount góc trên bên phải của toàn bộ card
        if (hasDiscount)
          Positioned(
            top: 8,
            right: 8,
            child: _discountBadge(product.discountPercent),
          ),
      ],
    );
  }

  // --- Badge giảm giá ---
  Widget _discountBadge(double discountPercent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '-${discountPercent.toStringAsFixed(0)}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- Hàng giá cho horizontal card ---
  Widget _priceRow(
      double discPrice, bool hasDiscount, double mainSize, double strikeSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        if (hasDiscount) ...[
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: strikeSize,
              color: Colors.grey[500],
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          '\$${discPrice.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: mainSize,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  // --- Hàng giá cho vertical card (có Flexible để tránh overflow) ---
  Widget _priceRowWithFlexible(double discPrice, bool hasDiscount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        if (hasDiscount) ...[
          Flexible(
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
                decoration: TextDecoration.lineThrough,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          '\$${discPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}
