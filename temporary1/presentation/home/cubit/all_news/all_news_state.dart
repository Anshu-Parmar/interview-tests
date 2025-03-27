part of 'all_news_cubit.dart';

sealed class AllNewsState {}

final class AllNewsInitial extends AllNewsState {}

final class AllNewsLoading extends AllNewsState {}

final class AllNewsLoaded extends AllNewsState {
  final List<Channel?> allTopics;

  AllNewsLoaded({required this.allTopics});
}

final class AllNewsFailure extends AllNewsState {
  final String message;

  AllNewsFailure({required this.message});
}
