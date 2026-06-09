import 'package:exam/Entity/Product.dart';

class ProductDAO {
  List<Product>? l;
  ProductDAO();
  List<Product> getAllProduct() {
    //Lấy dữ liệu từ DataBase
    l = Product.products;
    return l!;
  }

  void addProduct(Product p) {
    var index = l!.indexWhere((element) => element.id == p.id);
    if (index < 0) l!.add(p);
  }

  void deleteProduct(String id) {
    l!.removeWhere((element) => element.id == id);
  }

  void updateProduct(Product pNew) {
    var index = l!.indexWhere((element) => element.id == pNew.id);
    var p = l![index];
    l!.remove(p);
    l!.add(pNew);
  }
}
