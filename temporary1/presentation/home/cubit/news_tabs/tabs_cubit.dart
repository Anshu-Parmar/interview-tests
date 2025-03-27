import 'package:flutter_bloc/flutter_bloc.dart';

part 'tabs_state.dart';

class TabsCubit extends Cubit<TabsState> {
  TabsCubit() : super(TabsState(currentIndex: 0, activeTabs: {0}));

  void changeTab(String title) {
    int index = 0;

    switch (title) {
      case "BUSINESS":
        index = 1;
        break;
      case "FUNDING":
        index = 2;
        break;
      case "MANAGEMENT":
        index = 3;
        break;
      case "PRODUCTIVITY":
        index = 4;
        break;
      case "TECHNOLOGY":
        index = 5;
        break;
      default:
        index = 0;
        break;
    }

    var newActiveTabs = Set<int>.from(state.activeTabs);

    if (newActiveTabs.length > 2) {
      newActiveTabs.removeWhere((tabIndex) => tabIndex != 0);
    }
    newActiveTabs.add(index);

    emit(state.copyWith(currentIndex: index, activeTabs: newActiveTabs));
  }
}
