import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF125D98),
        accentColor: Color(0xFFF5A962),
        scaffoldBackgroundColor: Color(0xFFDDDDDD),
        // primarySwatch: Colors.cyan,
        // accentColor: Colors.deepOrange,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: ProductOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        CartScreen.routeName: (context) => CartScreen(),
        OrdersScreen.routeName: (ctx) => OrdersScreen(),
        UserProductsScreen.routeName: (context) => UserProductsScreen(),
        EditProductScreen.routeName: (ctx) => EditProductScreen(),
      },
    );
  }
}
