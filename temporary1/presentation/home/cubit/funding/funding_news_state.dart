part of 'funding_news_cubit.dart';

sealed class FundingNewsState {}

final class FundingNewsLoading extends FundingNewsState {}
final class FundingNewsLoaded extends FundingNewsState {
  final List<BookMarkItem?> items;
  FundingNewsLoaded({required this.items});
}
final class FundingNewsError extends FundingNewsState {
  final String message;
  FundingNewsError({required this.message});
}
