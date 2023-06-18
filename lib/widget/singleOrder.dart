import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../provider/order.dart';

class SingleOrder extends StatefulWidget {
  const SingleOrder({super.key});

  @override
  State<SingleOrder> createState() => _SingleOrderState();
}

class _SingleOrderState extends State<SingleOrder> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final orderItem = Provider.of<OrderItem>(context);
    final orders = Provider.of<Order>(context);
    return Dismissible(
      key: ValueKey(orderItem.id),
      background: Container(color: Colors.red,),
      onDismissed: (direction)=>orders.deleteOrder(orderItem.id),
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        duration: const Duration(milliseconds: 300),
        height: _isExpanded ? min(orderItem.products.length * 20 + 110, 200) : 95,
        child: Card(
          child: Column(
            children: [
              ListTile(
                title: Text("\$${orderItem.amount.toInt()}"),
                subtitle: Text(
                    DateFormat("dd/mm/yyyy hh:mm").format(orderItem.dateTime)),
                trailing: IconButton(
                  icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isExpanded
                      ? min(orderItem.products.length * 20 + 10, 100)
                      : 0,
                      
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                        children: orderItem.products
                            .map((prod) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(prod.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text(
                                      '${prod.quantity} x ₹${prod.price} = ${prod.price * prod.quantity}',
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    )
                                  ],
                                ))
                            .toList()),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
