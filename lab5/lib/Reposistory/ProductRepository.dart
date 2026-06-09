import 'package:exam/Entity/Product.dart';
import 'package:exam/Reposistory/ProductDAO.dart';

/// Repository layer — bọc ProductDAO, không sửa file DAO gốc.
class ProductRepository {
  final ProductDAO _dao = ProductDAO();

  List<Product> getAllProducts() {
    return _dao.getAllProduct();
  }

  Product? getProductById(String id) {
    try {
      return getAllProducts().firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
