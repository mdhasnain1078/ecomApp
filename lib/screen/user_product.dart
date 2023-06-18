import 'package:ecomapp/provider/products.dart';
import 'package:ecomapp/screen/editing_product_screen.dart';
import 'package:ecomapp/widget/appDrawe.dart';
import 'package:ecomapp/widget/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProduct extends StatelessWidget {
  const UserProduct({super.key});
  static const routeName = "/userProduct";

  Future<void> _refreshData(BuildContext context)async {
   await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product', style: TextStyle(color: Colors.white),),
        actions: [IconButton(onPressed: () {
          Navigator.of(context).pushNamed(EditingProductScreen.routeName);
        }, icon: const Icon(Icons.add,), color: Colors.white,)],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshData(context),
        builder: (context, snapshot)=>
        snapshot.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator.adaptive(),) :
         RefreshIndicator(
          onRefresh: () =>
            _refreshData(context),
          child: Consumer<Products>(
            builder: (context, productsData, _) => Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: productsData.items.length,
                  itemBuilder: (context, i) => Column(
                    children: [
                      UserProductItem(
                          id : productsData.items[i].id!,
                          title: productsData.items[i].title,
                          imageUrl: productsData.items[i].imageUrl),
                          const Divider()
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
