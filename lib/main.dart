import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screen/product_screen.dart';
import './screen/detail_screen.dart';
import './providers/products.dart';

import './providers/cart.dart';
import './screen/cart_screen.dart';
import 'providers/orders.dart';
import './screen/16.1 splash_screen.dart';
import './screen/orders_screen.dart';
import './screen/User_products_screen.dart';

import './screen/edit_product_screen.dart';
import './screen/4.2 auth_screen.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // list of provider

      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ), //rabtna screen login be screen shopping
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrder) => Orders(
            auth.token,
            auth.userId,
            previousOrder == null ? [] : previousOrder.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductScreen()
              : FutureBuilder(
                  future: auth.truAutoLogin(),
                  builder: (ctx, authResultsnapshot) =>
                      authResultsnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ), // mshfahmaaa?????
          routes: {
            ProductDetailScreen.routeName: (ctx) =>
                ProductDetailScreen(), // lma a2pl pushname ba3ml kda
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
