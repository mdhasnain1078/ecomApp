import 'package:ecomapp/widget/productItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.showFavoritesOnly});
  final bool showFavoritesOnly;

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: showFavoritesOnly ? products.favoriteItem.length : products.items.length,
            // gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 4,
            //   mainAxisSpacing: 10,
            //   crossAxisSpacing: 10,
            //   staggeredTileBuilder: (int index) => StaggeredTile.count(2, index.isEven ? 2: 1),
            // ),
            itemBuilder: (context, i) =>
            
            ChangeNotifierProvider(
              create: (BuildContext context) =>showFavoritesOnly ? products.favoriteItem[i] : products.items[i],
              child: const ProductItem()), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 3/2),);
  }
}