part of 'product_cubit.dart';

sealed class ProductState {}

final class ProductInitial extends ProductState {}
final class ProductLoading extends ProductState {}
final class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded({required this.products});
}
final class ProductError extends ProductState {
  final String msg;

  ProductError({required this.msg});
}

