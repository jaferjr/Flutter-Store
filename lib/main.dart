import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './utils/routes.dart';

import './providers/orders.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './providers/auth.dart';

import './views/auth_home.dart';
import './views/product_form_screen.dart';
import './views/product_details_screen.dart';
import './views/products_overview_screen.dart';
import './views/products_screen.dart';
import './views/orders_screen.dart';
import './views/cart_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (_, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (_, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        // home: ProductsOverviewScreen(),
        routes: {
          Routes.AUTH_HOME: (context) => AuthOrHome(),
          Routes.HOME: (context) => ProductsOverviewScreen(),
          Routes.PRODUCT_DETAIL: (context) => ProductDetailScreen(),
          Routes.CART: (context) => CartScreen(),
          Routes.ORDER: (context) => OrdersScreen(),
          Routes.PRODUCT: (context) => ProductsScreen(),
          Routes.PRODUCT_FORM: (context) => ProducFormScreen(),
        },
      ),
    );
  }
}
