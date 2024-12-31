import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/products/screens/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Task',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductListScreen(),
    );
  }
}
