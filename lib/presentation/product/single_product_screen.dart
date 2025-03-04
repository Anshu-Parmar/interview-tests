import 'package:cached_network_image/cached_network_image.dart';
import 'package:challenges/data/models/product_model.dart';
import 'package:flutter/material.dart';

class SingleProductScreen extends StatelessWidget {
  final Product product;
  final double screenWidth;
  const SingleProductScreen({super.key, required this.product, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Hero(
                  tag: product.title,
                  child: CachedNetworkImage(
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
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth/2,
                      child: Text(
                        product.title,
                        maxLines: 3,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    Text(
                      "\$${product.price}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                height: 30,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.withValues(alpha: 0.5)
                ),
                child: Text(product.category),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                width: double.maxFinite,
                child: Text(
                  product.description,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
