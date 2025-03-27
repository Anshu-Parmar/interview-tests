part of 'management_news_cubit.dart';

sealed class ManagementNewsState {}

final class ManagementNewsLoading extends ManagementNewsState {}
final class ManagementNewsLoaded extends ManagementNewsState {
  final List<BookMarkItem?> items;
  ManagementNewsLoaded({required this.items});
}
final class ManagementNewsError extends ManagementNewsState {
  final String message;
  ManagementNewsError({required this.message});
}