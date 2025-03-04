import 'package:flutter/material.dart';

class TaskUi extends StatelessWidget {
  const TaskUi({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 5,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 30),
            indicatorColor: Colors.black,
            padding: const EdgeInsets.only(top: 20),
            labelPadding: const EdgeInsets.only(top: 20),
            tabs: [
              Tab(icon: Icon(Icons.flight)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_car)),
            ],
          ),
          title: Text('Tabs Demo'),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.flight, size: 350),
            Icon(Icons.directions_transit, size: 350),
            Icon(Icons.directions_car, size: 350),
          ],
        ),
      ),
    );
  }
}
