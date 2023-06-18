import 'package:ecomapp/constant/colors.dart';
import 'package:ecomapp/helpers/custom_route.dart';
import 'package:ecomapp/provider/auth.dart';
import 'package:ecomapp/provider/order.dart';
import 'package:ecomapp/provider/products.dart';
import 'package:ecomapp/screen/auth_screen.dart';
import 'package:ecomapp/screen/cartScreen.dart';
import 'package:ecomapp/screen/editing_product_screen.dart';
import 'package:ecomapp/screen/orderScreen.dart';
import 'package:ecomapp/screen/product_detail_screen.dart';
import 'package:ecomapp/screen/products_overView_screen.dart';
import 'package:ecomapp/screen/splashScreen.dart';
import 'package:ecomapp/screen/user_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './provider/card.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previousProduct) => Products(
              auth.token ?? '',
              previousProduct == null ? [] : previousProduct.items,
              auth.userId ?? ''),
          create: (context) => Products("", [], ""),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Order>(
            update: (context, auth, previousOrder) => Order(
                auth.token ?? '',
                previousOrder == null ? [] : previousOrder.orders,
                auth.userId ?? ''),
            create: (context) => Order("", [], "")),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
            textTheme: GoogleFonts.latoTextTheme(),
            useMaterial3: true,
            colorScheme: kColorScheme,
            appBarTheme: appBarTheme,
          ),
          home: auth.isAuth
              ? const ProductOverViewScreen()
              : FutureBuilder(
                future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const LoginScreen()),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CardScreen.routeName: (context) => const CardScreen(),
            OrderScreen.routeName: (context) => const OrderScreen(),
            UserProduct.routeName: (context) => const UserProduct(),
            EditingProductScreen.routeName: (context) =>
                const EditingProductScreen()
          },
        ),
      ),
    );
  }
}
