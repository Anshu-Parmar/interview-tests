import 'package:cached_network_image/cached_network_image.dart';
import 'package:challenges/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(product.title),
          subtitle: Text('${product.price} \$'),
          contentPadding: EdgeInsets.all(5),
          leading: CachedNetworkImage(
            imageUrl: product.image,
            fit: BoxFit.cover,
            errorWidget: (BuildContext context, String url, error) {
              return Center(
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              );
            },
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.orange),
              Text('${product.rating}'),
            ],
          ),
        ),
      ),
    );
  }
}
