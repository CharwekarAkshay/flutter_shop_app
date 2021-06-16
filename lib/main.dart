import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
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
          create: (ctx) => Products(token: '', itemsList: [], userId: ''),
          update: (ctx, auth, previousProducs) => Products(
              token: auth.token,
              itemsList: previousProducs == null ? [] : previousProducs.items,
              userId: auth.userId!),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(
            authToken: '',
            userId: '',
            ordersList: [],
          ),
          update: (ctx, auth, previousOrders) => Orders(
            authToken: auth.token,
            userId: auth.userId!,
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
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.windows: CustomPageTransitionBuilder(), 
                  TargetPlatform.android:  CustomPageTransitionBuilder(),
                  TargetPlatform.iOS:  CustomPageTransitionBuilder(),
                },
              )),
          // home: ProductOverviewScreen(),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapShot) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => checkIfAuthenticated(
                  child: ProductDetailScreen(),
                  auth: auth,
                ),
            CartScreen.routeName: (ctx) => checkIfAuthenticated(
                  child: CartScreen(),
                  auth: auth,
                ),
            OrdersScreen.routeName: (ctx) => checkIfAuthenticated(
                  child: OrdersScreen(),
                  auth: auth,
                ),
            UserProductsScreen.routeName: (ctx) => checkIfAuthenticated(
                  child: UserProductsScreen(),
                  auth: auth,
                ),
            EditProductScreen.routeName: (ctx) => checkIfAuthenticated(
                  child: EditProductScreen(),
                  auth: auth,
                ),
            AuthScreen.routeName: (ctx) => checkIfAuthenticated(
                  child: AuthScreen(),
                  auth: auth,
                ),
          },
        );
      },
    );
  }
}

Widget checkIfAuthenticated({required Widget child, required Auth auth}) {
  if (auth.token != '') {
    return child;
  }
  return AuthScreen();
}
