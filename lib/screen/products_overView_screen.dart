import 'package:ecomapp/provider/card.dart';
import 'package:ecomapp/provider/products.dart';
import 'package:ecomapp/screen/cartScreen.dart';
import 'package:ecomapp/widget/appDrawe.dart';
import 'package:ecomapp/widget/badge.dart';
import 'package:ecomapp/widget/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


enum Items{all, favourite}

class ProductOverViewScreen extends StatefulWidget {
  const ProductOverViewScreen({super.key});

  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {

  bool _showFavoritesOnly = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    // Future.delayed(Duration.zero).then((_) => Provider.of<Products>(context).fetchAndSetProducts());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context, listen: false).fetchAndSetProducts().then((_){
        setState(() {
          _isLoading = false;
        });
      } );
    }
    _isInit = false;
    
    super.didChangeDependencies();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Products",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
          ),

          actions: [
            PopupMenuButton(
            onSelected: (Items items){
              setState(() {
              if(items == Items.favourite){
                _showFavoritesOnly = true;
              }else{
                _showFavoritesOnly = false;
              }
              });
            },
            icon: const Icon(Icons.more_vert, color: Colors.white,),
            itemBuilder: (context)=>[
           const PopupMenuItem(value: Items.all,child: Text("Show all item"),),
           const PopupMenuItem(value: Items.favourite,child: Text("Favorite"),)
          ]), 
          
          Consumer<Cart>(builder: (BuildContext context, cart, Widget? ch) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Bedge(value: cart.cartLength.toString(), color: Colors.red, child: ch!),
            
          ), child: IconButton(onPressed: (){
            Navigator.of(context).pushNamed(CardScreen.routeName);
          }, icon: const Icon(Icons.shopping_cart), color: Colors.blue,),)
          ],
        ),
        body: _isLoading ? const Center(child: CircularProgressIndicator.adaptive()) : ProductGrid(showFavoritesOnly : _showFavoritesOnly),
        drawer: const AppDrawer(),
        );
  }
}
