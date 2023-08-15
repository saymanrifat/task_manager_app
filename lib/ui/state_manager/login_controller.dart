import 'package:get/get.dart';
import 'package:intro_widget/data/models/auth_utility.dart';
import 'package:intro_widget/data/models/login_model.dart';
import 'package:intro_widget/data/models/network_response.dart';
import 'package:intro_widget/data/services/network_caller.dart';
import 'package:intro_widget/data/utils/urls.dart';

class LoginController extends GetxController {
  bool _loginInProgress = false;

  bool get loginInProgress => _loginInProgress;

  Future<bool> login(String email, String password) async {
    _loginInProgress = true;

    update();

    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };
    final NetworkResponse response = await NetworkCaller()
        .postRequest(Urls.login, requestBody, isLogin: true);
    _loginInProgress = false;
    update();
    if (response.isSuccess) {
      LoginModel model = LoginModel.fromJson(response.body!);
      await AuthUtility.saveUserInfo(model);

      return true;
      // if (mounted) {
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => const BottomNavBaseScreen()),
      //           (route) => false);
      // }
    } else {
      return false;
      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Incorrect email or password')));
      // }
    }
  }
}
