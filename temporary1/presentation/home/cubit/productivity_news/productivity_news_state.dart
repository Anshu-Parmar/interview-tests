part of 'productivity_news_cubit.dart';

sealed class ProductivityNewsState {}

final class ProductivityNewsLoading extends ProductivityNewsState {}
final class ProductivityNewsLoaded extends ProductivityNewsState {
  final List<BookMarkItem?> items;
  ProductivityNewsLoaded({required this.items});
}
final class ProductivityNewsError extends ProductivityNewsState {
  final String message;

  ProductivityNewsError({required this.message});
}

