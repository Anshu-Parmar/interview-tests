part of 'tech_news_cubit.dart';

sealed class TechNewsState {}

final class TechNewsLoading extends TechNewsState {}
final class TechNewsLoaded extends TechNewsState {
  final List<BookMarkItem?> items;
  TechNewsLoaded({required this.items});
}
final class TechNewsError extends TechNewsState {
  final String message;
  TechNewsError({required this.message});
}
