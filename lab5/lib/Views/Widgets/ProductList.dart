import 'package:exam/Entity/Product.dart';
import 'package:exam/Views/Widgets/ProductWidget.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  List<Product> products;
  ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (context, index) =>
          ProductWidgetStateFull(product: products[index]),
      itemBuilder: (context, index) =>
          ProductWidgetStateFull(product: products[index]),
    );
  }
}

class ProductListReponsive extends StatelessWidget {
  List<Product> products;
  ProductListReponsive({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GridView.count(
        //Bước 2: Điều chỉnh layout hiển thị Widget Hiển thị sản phẩm
        crossAxisCount: constraints.maxWidth <= 450 ? 1 : 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          for (int i = 0; i < 5; i++)
            ProductWidgetStateFull(product: products[i]),
        ],
      ),
    );
  }
}
