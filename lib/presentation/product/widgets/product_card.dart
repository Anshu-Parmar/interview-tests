import 'package:cached_network_image/cached_network_image.dart';
import 'package:challenges/data/models/product_model.dart';
import 'package:challenges/presentation/product/single_product_screen.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final double screenWidth;

  const ProductCard({super.key, required this.product, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.withValues(alpha: 0.8),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SingleProductScreen(product: product, screenWidth: screenWidth),));
        },
        borderRadius: BorderRadius.circular(5),
        child: ListTile(
          title: Text(product.title),
          subtitle: Text('${product.price} \$'),
          contentPadding: EdgeInsets.all(5),
          leading: SizedBox(
            width: 100,
            child: Hero(
              tag: product.title,
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.scaleDown,
                errorWidget: (BuildContext context, String url, error) {
                  return Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.orange),
              Text('${product.rating}'),
              const SizedBox(width: 10,)
            ],
          ),
        ),
      ),
    );
  }
}
