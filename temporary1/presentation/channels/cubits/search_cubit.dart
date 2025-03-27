import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<List<String>> {
  final List<String> items;

  SearchCubit(this.items) : super(items);

  void search(String query) {
    if (query.isEmpty) {
      emit(items);
    } else {
      emit(items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }
}
