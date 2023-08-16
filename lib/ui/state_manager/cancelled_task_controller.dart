import 'package:get/get.dart';
import 'package:intro_widget/data/models/network_response.dart';
import 'package:intro_widget/data/models/task_list_model.dart';
import 'package:intro_widget/data/services/network_caller.dart';
import 'package:intro_widget/data/utils/urls.dart';

class CancelledTaskController extends GetxController {
  bool _getCanceledTasksInProgress = false;

  bool get getCanceledTasksInProgress => _getCanceledTasksInProgress;

  TaskListModel _taskListModel = TaskListModel();

  TaskListModel get taskListModel => _taskListModel;

  Future<bool> getCanceledTasks() async {
    _getCanceledTasksInProgress = true;
    update();

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.canceledTasks);

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
      _getCanceledTasksInProgress = false;
      update();
      return true;
    } else {
      return false;
    }
  }
}
