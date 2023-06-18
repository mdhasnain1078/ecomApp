import 'package:ecomapp/provider/card.dart';
import 'package:ecomapp/provider/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/cardItem.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});
  static const routeName = "/cardScreen";

  @override
  Widget build(BuildContext context) {
    final card = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your added items", style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Chip(
                    label: Text(
                      "\$${card.totalAmount}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    side: BorderSide.none,
                    labelPadding: EdgeInsets.zero,
                  ),

                  const Button()
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: card.cartLength,
                  itemBuilder: (context, i) => ChangeNotifierProvider.value(
                        value: card.item.values.toList()[i],
                        child: const CardItem(),
                      )))
        ],
      ),
    );
  }
}
class Button extends StatefulWidget {
  const Button({super.key});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final card = Provider.of<Cart>(context);
    return TextButton(
        onPressed: (card.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await Provider.of<Order>(context, listen: false)
                      .addOrder(card.item.values.toList(), card.totalAmount);
                  setState(() {
                    _isLoading = false;
                  });
                  card.clear();
                } catch (e) {
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            title: Text("Erorr occures"),
                            content: Text("Something went wrong"),
                          ));
                }
              },
        child: _isLoading
            ? const CircularProgressIndicator.adaptive()
            : const Text("Order Now"));
  }
}
