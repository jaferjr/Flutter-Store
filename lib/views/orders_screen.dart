import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_widget.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Meus Pedidos'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).loadOrders(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapShot.error != null) {
              return Center(child: Text('ocorreu um erro'));
            } else if (snapShot == null) {
              return Center(child: Text('seu carrinho está vazio'));
            } else {
              return Consumer<Orders>(
                builder: (ctx, orders, _) {
                  return ListView.builder(
                      itemCount: orders.itemsCount,
                      itemBuilder: (ctx, i) => OrderWidget(orders.items[i]));
                },
              );
            }
          },
        ));
  }
}
