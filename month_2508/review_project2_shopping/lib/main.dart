import 'package:flutter/material.dart';
import 'package:review_project2_shopping/screens/product_content_screen.dart';
import 'package:review_project2_shopping/screens/product_list_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => ProductListScreen(),
        "/productContent": (context) => ProductContentScreen(),
      },
    ),
  );
}
