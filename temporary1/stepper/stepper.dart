// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:easy_stepper/easy_stepper.dart';
// import 'package:get_it/get_it.dart';
// import 'package:intl/intl.dart';
//
// // Service Locator
// final GetIt sl = GetIt.instance;
//
// void setupLocator() {
//   sl.registerSingleton<StepCubit>(StepCubit());
//   sl.registerSingleton<SelectionCubit>(SelectionCubit());
// }
//
// // Step Cubit
// class StepCubit extends Cubit<int> {
//   StepCubit() : super(0);
//   void nextStep() => emit(state < 5 ? state + 1 : state);
//   void previousStep() => emit(state > 0 ? state - 1 : state);
// }
//
// // Selection Cubit
// class SelectionCubit extends Cubit<int> {
//   SelectionCubit() : super(0);
//   void selectOption() => emit(state + 1);
// }
//
// // ViewModel
// class StepViewModel {
//   final StepCubit stepCubit;
//   final SelectionCubit selectionCubit;
//   StepViewModel(this.stepCubit, this.selectionCubit);
// }
//
// void main() {
//   setupLocator(); // Initialize dependencies
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => sl<StepCubit>()),
//         BlocProvider(create: (_) => sl<SelectionCubit>()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: StepperScreen(),
//       ),
//     );
//   }
// }
//
// class StepperScreen extends StatelessWidget {
//   final Map<int, int> stepOptions = {
//     0: 1,
//     1: 2,
//     2: 3,
//     3: 1,
//     4: 1,
//     5: 1,
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     final stepCubit = context.watch<StepCubit>();
//     final selectionCubit = context.watch<SelectionCubit>();
//
//     double percentage = ((selectionCubit.state / (stepOptions[stepCubit.state] ?? 1)) * 100).clamp(0, 100);
//
//     return WillPopScope(
//       onWillPop: () async {
//         if (stepCubit.state > 0) {
//           stepCubit.previousStep();
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(title: Text("MVVM Stepper")),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             EasyStepper(
//               activeStep: stepCubit.state,
//               lineStyle: LineStyle(
//                 lineLength: MediaQuery.sizeOf(context).width / 7,
//                 lineThickness: 4,
//                 defaultLineColor: Colors.grey,
//                 activeLineColor: Colors.green,
//                 lineType: LineType.normal,
//               ),
//               stepShape: StepShape.circle,
//               stepRadius: 15,
//               finishedStepBorderColor: Colors.green,
//               activeStepBorderColor: Colors.green,
//               activeStepIconColor: Colors.white,
//               activeStepBackgroundColor: Colors.green,
//               finishedStepBackgroundColor: Colors.green,
//               showLoadingAnimation: false,
//               internalPadding: 0,
//               steps: List.generate(6, (index) =>
//                   EasyStep(
//                     icon: index <= stepCubit.state ? Icon(Icons.check, color: Colors.white) : Icon(Icons.circle, color: Colors.grey),
//                     topTitle: true,
//                     // customStep: Column(
//                     //   mainAxisAlignment: MainAxisAlignment.center,
//                     //   children: [
//                     //     Text("${index <= stepCubit.state ? ((index + 1) / 6 * 100).toInt() : 0}%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
//                     //     SizedBox(height: 4),
//                     //     CircleAvatar(
//                     //       radius: 20,
//                     //       backgroundColor: index <= stepCubit.state ? Colors.green : Colors.grey,
//                     //       child: index <= stepCubit.state ? Icon(Icons.check, color: Colors.white) : Icon(Icons.circle, color: Colors.white60),
//                     //     ),
//                     //   ],
//                     // ),
//                     title: "${index <= stepCubit.state ? ((index + 1) / 6 * 100).toInt() : 0}%",
//                     enabled: index <= stepCubit.state,
//                   )
//               ),
//               onStepReached: (index) {},
//             ),
//
//             SizedBox(height: 20),
//             Text("Completion: ${percentage.toStringAsFixed(0)}%", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//
//             SizedBox(height: 30),
//             getStepContent(context, stepCubit.state, selectionCubit),
//
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: selectionCubit.state >= (stepOptions[stepCubit.state] ?? 1) ? () {
//                 selectionCubit.emit(0);
//                 stepCubit.nextStep();
//               } : null,
//               child: Text("Next Step"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget getStepContent(BuildContext context, int step, SelectionCubit selectionCubit) {
//     if (step == 5) {
//       return Column(
//         children: [
//           Text("Select a date and time"),
//           ElevatedButton(
//             onPressed: () async {
//               DateTime? selectedDate = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime.now(),
//                 lastDate: DateTime(2100),
//               );
//               if (selectedDate != null) {
//                 selectionCubit.selectOption();
//               }
//             },
//             child: Text("Pick Date"),
//           ),
//         ],
//       );
//     }
//
//     return Column(
//       children: List.generate(stepOptions[step] ?? 1, (index) => ElevatedButton(
//         onPressed: () => selectionCubit.selectOption(),
//         child: Text("Option ${index + 1}"),
//       )),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

// Service Locator
final GetIt sl = GetIt.instance;

void setupLocator() {
  sl.registerSingleton<StepCubit>(StepCubit());
  sl.registerSingleton<SelectionCubit>(SelectionCubit());
}

// Step Cubit
class StepCubit extends Cubit<int> {
  StepCubit() : super(0);
  void nextStep() => emit(state < 5 ? state + 1 : state);
  void previousStep() => emit(state > 0 ? state - 1 : state);
}

// Selection Cubit
class SelectionCubit extends Cubit<int> {
  SelectionCubit() : super(0);
  void selectOption() => emit(state + 1);
}

// ViewModel
class StepViewModel {
  final StepCubit stepCubit;
  final SelectionCubit selectionCubit;
  StepViewModel(this.stepCubit, this.selectionCubit);
}

void main() {
  setupLocator(); // Initialize dependencies
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<StepCubit>()),
        BlocProvider(create: (_) => sl<SelectionCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StepperScreen(),
      ),
    );
  }
}

class StepperScreen extends StatelessWidget {
  final Map<int, int> stepOptions = {
    0: 1,
    1: 2,
    2: 3,
    3: 1,
    4: 1,
    5: 1,
  };

  @override
  Widget build(BuildContext context) {
    final stepCubit = context.watch<StepCubit>();
    final selectionCubit = context.watch<SelectionCubit>();
    final width = MediaQuery.sizeOf(context).width;
    double percentage = ((selectionCubit.state / (stepOptions[stepCubit.state] ?? 1)) * 100).clamp(0, 100);

    return WillPopScope(
      onWillPop: () async {
        if (stepCubit.state > 0) {
          stepCubit.previousStep();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text("MVVM Stepper")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: EasyStepper(
                activeStep: stepCubit.state,
                lineStyle: LineStyle(
                  lineLength: (width - 204)/6,
                  lineThickness: 6,
                  defaultLineColor: Colors.grey,
                  activeLineColor: Colors.green,
                  lineType: LineType.normal,
                ),
                stepShape: StepShape.circle,
                stepRadius: 15,
                finishedStepBorderColor: Colors.green,
                activeStepBorderColor: Colors.green,
                activeStepIconColor: Colors.white,
                activeStepBackgroundColor: Colors.green,
                finishedStepBackgroundColor: Colors.green,
                showLoadingAnimation: false,
                internalPadding: 0,
                steps: List.generate(6, (index) {
                  final String title = index <= stepCubit.state ? "${((index + 1) / 6 * 100).toInt()}%" : "";
                  return EasyStep(
                    // icon: index < stepCubit.state ? Icon(Icons.check, color: Colors.white) : Icon(Icons.circle, color: Colors.grey),
                    topTitle: true,
                    customStep: CircleAvatar(
                      radius: 15,
                      backgroundColor: index < stepCubit.state ? Colors.green : Colors.grey,
                      child: index < stepCubit.state
                          ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                        weight: 2,
                      )
                          : SizedBox(),
                    ),
                    title: title,
                    enabled: index <= stepCubit.state,
                  );
                },

                    // EasyStep(
                    //   customStep: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text("${index <= stepCubit.state ? ((index + 1) / 6 * 100).toInt() : 0}%", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                    //       SizedBox(height: 4),
                    //       CircleAvatar(
                    //         radius: 20,
                    //         backgroundColor: index < stepCubit.state ? Colors.green : Colors.grey,
                    //         child: index < stepCubit.state ? Icon(Icons.check, color: Colors.white) : Icon(Icons.circle, color: Colors.white60),
                    //       ),
                    //     ],
                    //   ),
                    //   title: '',
                    //   enabled: index <= stepCubit.state,
                    // )
                ),
                onStepReached: (index) {},
              ),
            ),

            SizedBox(height: 20),
            Text("Completion: ${percentage.toStringAsFixed(0)}%", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 30),
            getStepContent(context, stepCubit.state, selectionCubit),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectionCubit.state >= (stepOptions[stepCubit.state] ?? 1) ? () {
                selectionCubit.emit(0);
                stepCubit.nextStep();
              } : null,
              child: Text("Next Step"),
            ),
          ],
        ),
      ),
    );
  }

  Widget getStepContent(BuildContext context, int step, SelectionCubit selectionCubit) {
    if (step == 5) {
      return Column(
        children: [
          Text("Select a date and time"),
          ElevatedButton(
            onPressed: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                selectionCubit.selectOption();
              }
            },
            child: Text("Pick Date"),
          ),
        ],
      );
    }

    return Column(
      children: List.generate(stepOptions[step] ?? 1, (index) => ElevatedButton(
        onPressed: () => selectionCubit.selectOption(),
        child: Text("Option ${index + 1}"),
      )),
    );
  }
}


//Radio button
class FormData {
  String? selectedRadioOption;
  String? searchQuery;
  List<String>? option2;
  List<String>? option3;
  String? option4;
  String? option5;
  DateTime? selectedDate;

  Map<String, dynamic> toJson() {
    return {
      "selectedRadioOption": selectedRadioOption,
      "searchQuery": searchQuery,
      "option2": option2,
      "option3": option3,
      "option4": option4,
      "option5": option5,
      "selectedDate": selectedDate?.toIso8601String(),
    };
  }
}

class FormCubit extends Cubit<FormData> {
  FormCubit() : super(FormData());

  void updateForm({
    String? selectedRadioOption,
    String? searchQuery,
    List<String>? option2,
    List<String>? option3,
    String? option4,
    String? option5,
    DateTime? selectedDate,
  }) {
    emit(FormData()
      ..selectedRadioOption = selectedRadioOption ?? state.selectedRadioOption
      ..searchQuery = searchQuery ?? state.searchQuery
      ..option2 = option2 ?? state.option2
      ..option3 = option3 ?? state.option3
      ..option4 = option4 ?? state.option4
      ..option5 = option5 ?? state.option5
      ..selectedDate = selectedDate ?? state.selectedDate);
  }
}

Widget getStepContent(BuildContext context, int step, FormCubit formCubit) {
  final formData = context.watch<FormCubit>().state;

  if (step == 0) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select an option:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

        RadioListTile<String>(
          title: Text("Option A"),
          value: "Option A",
          groupValue: formData.selectedRadioOption,
          onChanged: (value) => formCubit.updateForm(selectedRadioOption: value),
        ),
        RadioListTile<String>(
          title: Text("Option B"),
          value: "Option B",
          groupValue: formData.selectedRadioOption,
          onChanged: (value) => formCubit.updateForm(selectedRadioOption: value),
        ),

        SizedBox(height: 20),

        TextField(
          decoration: InputDecoration(
            labelText: "Search",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => formCubit.updateForm(searchQuery: value),
        ),
      ],
    );
  }

  return Text("Other step content");
}

//Api value selection
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiCubit extends Cubit<List<String>> {
  ApiCubit() : super([]);

  void fetchData() async {
    final response = await http.get(Uri.parse("https://api.example.com/items"));

    if (response.statusCode == 200) {
      List<String> data = List<String>.from(jsonDecode(response.body));
      emit(data);
    } else {
      emit([]);
    }
  }
}

Widget getStepContent(BuildContext context, int step, FormCubit formCubit) {
  final formData = context.watch<FormCubit>().state;
  final apiCubit = context.watch<ApiCubit>();

  if (step == 1) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: "Search items",
            border: OutlineInputBorder(),
          ),
          onChanged: (query) {
            formCubit.updateForm(searchQuery: query);
            List<String> filteredData = apiCubit.state
                .where((item) => item.toLowerCase().contains(query.toLowerCase()))
                .toList();
            apiCubit.emit(filteredData);
          },
        ),
        
        SizedBox(height: 10),

        ElevatedButton(
          onPressed: () => apiCubit.fetchData(), 
          child: Text("Fetch Data"),
        ),

        SizedBox(height: 10),

        Expanded(
          child: ListView.builder(
            itemCount: apiCubit.state.length,
            itemBuilder: (context, index) {
              String item = apiCubit.state[index];
              bool isSelected = formData.selectedItems?.contains(item) ?? false;

              return ListTile(
                title: Text(item),
                trailing: isSelected ? Icon(Icons.check, color: Colors.green) : null,
                onTap: () {
                  List<String> updatedSelection = List.from(formData.selectedItems ?? []);
                  if (isSelected) {
                    updatedSelection.remove(item);
                  } else {
                    updatedSelection.add(item);
                  }
                  formCubit.updateForm(selectedItems: updatedSelection);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  return Text("Other step content");
}

ElevatedButton(
  onPressed: (formData.selectedItems != null && formData.selectedItems!.isNotEmpty) ? () {
    stepCubit.nextStep();
  } : null,
  child: Text("Next Step"),
),
