import 'package:get/get.dart';
import 'package:intro_widget/data/models/network_response.dart';
import 'package:intro_widget/data/models/task_list_model.dart';
import 'package:intro_widget/data/services/network_caller.dart';
import 'package:intro_widget/data/utils/urls.dart';

class CompletedTaskController extends GetxController {
  bool _getCompletedTasksInProgress = false;
  TaskListModel _taskListModel = TaskListModel();

  bool get getCompletedTasksInProgress => _getCompletedTasksInProgress;
  TaskListModel get taskListModel => _taskListModel;

  Future<bool> getCompletedTasks() async {
    _getCompletedTasksInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.completedTasks);
    _getCompletedTasksInProgress = false;
    update();

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);

      return true;
    } else {
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('In progress tasks get failed')));
      // }

      return false;
    }
  }
}
