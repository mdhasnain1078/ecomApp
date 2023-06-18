import 'package:ecomapp/provider/auth.dart';
import 'package:ecomapp/screen/user_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/custom_route.dart';
import '../screen/orderScreen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // MainAxisAlignment alignment = MainAxisAlignment.spaceEvenly;
    SizedBox space = const SizedBox(
      width: 20,
    );
    return Drawer(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 50,
        ),
        child: Column(
          children: [
            const Text(
              "Features",
              style: TextStyle(fontSize: 30),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                
                children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        // mainAxisAlignment: alignment,
                        children: [
                          const Icon(Icons.shop),
                          space,
                          const Text(
                            "Shop",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigator.pushReplacementNamed(context, OrderScreen.routeName);
                    Navigator.of(context).pushReplacement(CustomRoute(
                      builder: (context) => const OrderScreen(),
                    ));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        // mainAxisAlignment: alignment,
                        children: [
                          const Icon(Icons.payment),
                          space,
                          const Text(
                            "Orders",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, UserProduct.routeName);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        // mainAxisAlignment: alignment,
                        children: [
                          const Icon(Icons.edit),
                          space,
                          const Text(
                            "Manage Products",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Provider.of<Auth>(context, listen: false).logout();
                    // Navigator.of(context).pushReplacement(CustomRoute(builder: (context,)=>const OrderScreen(),));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        // mainAxisAlignment: alignment,
                        children: [
                          const Icon(Icons.logout),
                          space,
                          const Text(
                            "LogOut",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
