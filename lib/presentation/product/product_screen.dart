import 'package:challenges/presentation/product/cubits/product_cubit.dart';
import 'package:challenges/presentation/product/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return BlocProvider<ProductCubit>(create: (_) => ProductCubit()..fetchProducts(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Product List'),
          ),
          body: SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.purple,),
                    );
                  }

                  if (state is ProductLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(
                        child: Text("No data!!"),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(product: state.products[index], screenWidth: width);
                        },
                      ),
                    );
                  }

                  if (state is ProductError) {
                    return Center(
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 30,),
                          const SizedBox(height: 10,),
                          Text("Error occurred - ${state.msg}")
                        ],
                      ),
                    );
                  }

                  return SizedBox();
                },
              )
          )
      ),
    );
  }
}

