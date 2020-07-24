import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (ctx, i) => ChangeNotifierProvider.value(
          // builder: (c) => products[i],
          value: products[i],
          child: Container(
            color: Colors.red[50],
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: i == products.length - 1 ? 10 : 0),
            child: ProductItem(
                // products[i].id,
                // products[i].title,
                // products[i].imageUrl,
                ),
          ),
        ),
        childCount: products.length,

        //padding: const EdgeInsets.all(10.0),
        //itemCount: products.length,
        //itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // builder: (c) => products[i],
        //     value: products[i],
        //      child: ProductItem(
        // products[i].id,
        // products[i].title,
        // products[i].imageUrl,
        //         ),
        //    ),
        //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //  crossAxisCount: 1,
        //  childAspectRatio: 3 / 2,
        //  crossAxisSpacing: 10,
        //  mainAxisSpacing: 10,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        //crossAxisSpacing: 10,
        //mainAxisSpacing: 10,
      ),
    );
  }
}
