import 'package:ecomapp/provider/auth.dart';
import 'package:ecomapp/provider/product.dart';
import 'package:ecomapp/provider/card.dart';
import 'package:ecomapp/screen/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../constant/colors.dart';


class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final card = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                  onPressed: () {
                    product.toggleFavourite(auth.token!, auth.userId?? '');
                  },
                  icon: Icon(
                    product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                    color: iconColor,
                  )),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  card.addItems(product.id!, product.title, product.price);
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      duration: const Duration(seconds: 2),
                      content: const Text("Product added in the card"), action: SnackBarAction(label: "Undo", onPressed: (){
                        card.removeSingleItem(product.id!);
                  }),), );
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: iconColor,
                )),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetailScreen.routeName, arguments: {
                "title": product.title,
                "imageUrl": product.imageUrl,
                "description": product.description,
                "id": product.id
              });
            },
            child: Hero(
              tag: product.id!,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                  product.imageUrl,
                  scale: 2,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
