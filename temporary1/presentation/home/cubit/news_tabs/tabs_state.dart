part of 'tabs_cubit.dart';

class TabsState {
  final int currentIndex;
  final Set<int> activeTabs;

  TabsState({required this.currentIndex, required this.activeTabs});

  TabsState copyWith({int? currentIndex, Set<int>? activeTabs}) {
    return TabsState(
      currentIndex: currentIndex ?? this.currentIndex,
      activeTabs: activeTabs ?? this.activeTabs,
    );
  }
}