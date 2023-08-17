import 'package:get/get.dart';
import 'package:intro_widget/data/models/network_response.dart';
import 'package:intro_widget/data/models/task_list_model.dart';
import 'package:intro_widget/data/services/network_caller.dart';
import 'package:intro_widget/data/utils/urls.dart';

class InProgressTaskController extends GetxController {
  bool _getProgressTasksInProgress = false;
  TaskListModel _taskListModel = TaskListModel();

  bool get getProgressTasksInProgress => _getProgressTasksInProgress;

  TaskListModel get taskListModel => _taskListModel;

  Future<bool> getInProgressTasks() async {
    _getProgressTasksInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.inProgressTasks);
    _getProgressTasksInProgress = false;
    update();
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
      return true;
    } else {
      return false;
    }
  }
}
