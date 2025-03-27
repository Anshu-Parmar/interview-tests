part of 'business_news_cubit.dart';

sealed class BusinessNewsState {}

final class BusinessNewsLoading extends BusinessNewsState {}
final class BusinessNewsLoaded extends BusinessNewsState {
  final List<BookMarkItem?> items;
  BusinessNewsLoaded({required this.items});
}
final class BusinessNewsError extends BusinessNewsState {
  final String message;
  BusinessNewsError({required this.message});
}
