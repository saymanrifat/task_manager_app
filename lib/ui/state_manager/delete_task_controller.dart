import 'package:get/get.dart';
import 'package:intro_widget/data/models/network_response.dart';
import 'package:intro_widget/data/services/network_caller.dart';
import 'package:intro_widget/data/utils/urls.dart';

class DeleteTaskController extends GetxController {
  Future<bool> deleteTask(String taskId, taskListModel) async {
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
      taskListModel.data!.removeWhere((element) => element.sId == taskId);
      update();
      return true;
    } else {
      return false;
      // ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Deletion of task has been failed')));
    }
  }
}
