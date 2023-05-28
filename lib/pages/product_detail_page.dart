import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/pages/products_page.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Product item;

  const ProductDetailPage({this.item});

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    final String pictureUrl =
        'http://192.168.100.14:1337${item.picture['url']}';
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: Container(
        decoration: gradientBackground,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Hero(
                tag: item,
                child: Image.network(
                  pictureUrl,
                  width: orientation == Orientation.portrait ? 600 : 250,
                  height: orientation == Orientation.portrait ? 400 : 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // ignore: deprecated_member_use
            Text(
              item.name,
              // ignore: deprecated_member_use
              style: Theme.of(context).textTheme.headline6,
            ),
            // ignore: deprecated_member_use
            Text(
              '\$${item.price}',
              // ignore: deprecated_member_use
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  child: Text(item.description),
                  padding:
                      EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
