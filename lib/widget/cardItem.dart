import 'package:ecomapp/provider/card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardItem extends StatelessWidget {
  const CardItem({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<CartItem>(context);
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(cartItem.id);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: const Text(
                      "Do you want to remove the item from your card?"),
                  title: const Text("Are you sure"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Yes"))
                  ],
                ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.deepPurple,
                child: FittedBox(
                    child: Text(cartItem.price.toString(),
                        style: const TextStyle(color: Colors.white)))),
            title: Text(
              cartItem.title,
            ),
            trailing: Text("x${cartItem.quantity}"),
          ),
        ),
      ),
    );
  }
}
