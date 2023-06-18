import 'package:ecomapp/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
  });

  static const routeName = "/ProductDetailScreen";

  @override
  Widget build(BuildContext context) {
    final productDetail =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // final title = productDetail['title'];
    // final imageUrl = productDetail['imageUrl'];
    // final description = productDetail['description'];
    final id = productDetail['id'];
    final product = Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
        flexibleSpace: FlexibleSpaceBar(
          title:  Text(
          product.title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            
            color: Colors.black),
                ), background: Hero(
              tag: id,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
              ),
            ),),
          ),
          SliverList(delegate: SliverChildListDelegate([
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
              height: 20,
            ),
            Text("\$${product.price}"),
            Text(product.description),
            const SizedBox(height: 800,)
              ],
            ),
          ]))
        ],
        
      ),
    );
  }
}
