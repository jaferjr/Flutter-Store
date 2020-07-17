import 'package:flutter/material.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context).settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.description),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text('R\$ ${product.price}'),
            SizedBox(height: 10),
            Container(
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
          ],
        ),
      ),
    );
  }
}
