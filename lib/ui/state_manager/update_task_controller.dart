import 'package:get/get.dart';
import 'package:intro_widget/data/models/network_response.dart';
import 'package:intro_widget/data/services/network_caller.dart';
import 'package:intro_widget/data/utils/urls.dart';

class UpdateTaskController extends GetxController{

  bool _updateTaskInProgress = false;

  bool get updateTaskInProgress => _updateTaskInProgress;

  Future<bool> updateTask(title, desc) async {
    _updateTaskInProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "title": title,
      "description": desc,
    };
    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.createTask, requestBody);
    _updateTaskInProgress = false;
    update();
    if (response.isSuccess) {

      return true;

    } else {
      return false;
    }
  }

}