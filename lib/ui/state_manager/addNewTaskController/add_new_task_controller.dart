import 'package:get/get.dart';
import 'package:intro_widget/data/models/network_response.dart';
import 'package:intro_widget/data/services/network_caller.dart';
import 'package:intro_widget/data/utils/urls.dart';

class AddNewTaskController extends GetxController {
  bool _addNewTaskInProgress = false;

  bool get addNewTaskInProgress => _addNewTaskInProgress;

  Future<bool> addNewTask(title, desc) async {
    _addNewTaskInProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "title": title,
      "description": desc,
      "status": "New"
    };
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.createTask, requestBody);
    _addNewTaskInProgress = false;
    update();
    if (response.isSuccess) {
      return true;
    } else {
      return false;
    }
  }
}
