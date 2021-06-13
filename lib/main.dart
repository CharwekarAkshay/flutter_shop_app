import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(token: '', itemsList: []),
          update: (ctx, auth, previousProducs) => Products(
            token: auth.token!,
            itemsList: previousProducs == null ? [] : previousProducs.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(
            authToken: '',
            ordersList: [],
          ),
          update: (ctx, auth, previousOrders) => Orders(
            authToken: auth.token!,
            ordersList: previousOrders == null ? [] : previousOrders.ordersList,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) {
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
          // home: ProductOverviewScreen(),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        );
      },
    );
  }
}
