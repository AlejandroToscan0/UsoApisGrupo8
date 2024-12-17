import 'package:flutter/material.dart';
import 'views/coffee_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tipos de Café',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CoffeeView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
