import 'package:exam/Views/Widgets/ProductList.dart';
import 'package:flutter/material.dart';
import 'package:exam/Views/Widgets/ButtonBar.dart';
import 'package:exam/Views/Widgets/Product_Widget.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        /*
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.home),
        ),
      */
        title: Center(child: Text("About Page")),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(border: Border.all(color: Colors.red)),

          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width < 700 ? 1 : 2,
            children: [
              Text("Cot 1"),
              Text("Cot 1"),
              Text("Cot 1"),
              Text("Cot 1"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Buttonbar(),
    );
  }
}
