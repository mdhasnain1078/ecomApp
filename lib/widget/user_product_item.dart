import 'package:ecomapp/provider/products.dart';
import 'package:ecomapp/screen/editing_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({super.key, required this.title, required this.imageUrl, required this.id});
  final String title;
  final String imageUrl;
  final String id;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(children: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(EditingProductScreen.routeName, arguments: id);
          }, icon: const Icon(Icons.edit,), color: Theme.of(context).primaryColor,),
          IconButton(onPressed: () async{
            try{
             await Provider.of<Products>(context, listen: false).removeProduct(id);
            }catch(e){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Deleting failed")));
            }
          }, icon: const Icon(Icons.delete), color: Theme.of(context).errorColor,)
        ],),
      ),
    );
  }
}
