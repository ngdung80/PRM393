import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// ViewModel cho màn hình chi tiết sản phẩm.
///
/// Chịu trách nhiệm:
/// - Giữ thông tin sản phẩm được chọn
/// - Xử lý hành động "Thêm vào giỏ hàng"
/// - Thông báo cho View khi trạng thái thay đổi
class ProductDetailViewModel extends ChangeNotifier {
  final Product product;
  bool _addedToCart = false;

  ProductDetailViewModel({required this.product});

  // --- Getters ---
  bool get addedToCart => _addedToCart;

  double get discountedPrice => product.discountedPrice;
  bool get hasDiscount => product.discountPercent > 0;

  /// Xử lý hành động thêm sản phẩm vào giỏ hàng.
  /// Trả về [true] nếu thêm thành công.
  bool addToCart() {
    // TODO: Mở rộng sau - kết nối CartRepository hoặc CartViewModel toàn cục
    _addedToCart = true;
    notifyListeners();
    return true;
  }

  /// Reset trạng thái giỏ hàng (dùng khi cần).
  void resetCartState() {
    _addedToCart = false;
    notifyListeners();
  }
}
