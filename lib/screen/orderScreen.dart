import 'package:ecomapp/provider/order.dart';
import 'package:ecomapp/widget/appDrawe.dart';
import 'package:ecomapp/widget/singleOrder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  static const routeName = "/orderScreen";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}


class _OrderScreenState extends State<OrderScreen> {

// @override
// void initState() {
//   Provider.of<Order>(context, listen: false).fetchData();
//   super.initState();
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your bills", style: TextStyle(color: Colors.white),),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).fetchData(),
        builder: (context, snapShot){
        if(snapShot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        else{
        if(snapShot.error != null){
          return const Center(child: Text("AN erorr occure"),);
        }
        else{
            return RefreshIndicator(
          onRefresh: () => Provider.of<Order>(context, listen: false).fetchData(),
          child: Consumer<Order>(
            builder: (context, order, _)=>
            ListView.builder(
            itemCount: order.orders.length,
            itemBuilder: (ctx, i)=> ChangeNotifierProvider.value(
              value: order.orders[i],
              child: const SingleOrder())),
          ),
      );
        }
        }
        })
      
    );
  }
}
