import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
          ), //là góc bên trái app bar
          title: Center(child: Text('Home')),
          backgroundColor: Colors.grey,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          ],
        ),

        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.height,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.blue),
            ),
            child: Image.asset('assets/images/cx5.png', fit: BoxFit.fill),
          ),
        ),

        backgroundColor: Colors.white,

        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              label: 'Liên hệ',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
          ],
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }

}