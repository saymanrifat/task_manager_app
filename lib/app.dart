import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_widget/ui/screens/splash_screen.dart';
import 'package:intro_widget/ui/state_manager/addNewTaskController/add_new_task_controller.dart';
import 'package:intro_widget/ui/state_manager/cancelled_task_controller.dart';
import 'package:intro_widget/ui/state_manager/completed_task_controller.dart';
import 'package:intro_widget/ui/state_manager/delete_task_controller.dart';
import 'package:intro_widget/ui/state_manager/in_progress_task_controller.dart';
import 'package:intro_widget/ui/state_manager/login_controller.dart';
import 'package:intro_widget/ui/state_manager/new_task_controller.dart';
import 'package:intro_widget/ui/state_manager/summeryCountController.dart';
import 'package:intro_widget/ui/state_manager/update_task_controller.dart';
import 'package:intro_widget/ui/state_manager/user_signup_controller.dart';

class TaskManagerApp extends StatefulWidget {
  static GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  const TaskManagerApp({Key? key}) : super(key: key);

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      key: TaskManagerApp.globalKey,
      title: 'Task Manager',
      initialBinding: ControllerBinding(),
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(SummaryCountController());
    Get.put(SignupController());
    Get.put(CancelledTaskController());
    Get.put(AddNewTaskController());
    Get.put(CancelledTaskController());
    Get.put(NewTaskController());
    Get.put(CompletedTaskController());
    Get.put(DeleteTaskController());
    Get.put(InProgressTaskController());
    Get.put(UpdateTaskController());
  }
}
