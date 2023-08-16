
import 'package:get/get.dart';

class GetxRouting {
  void to(route) {
    Get.to(route);
  }

  void toOffReplacement(route) {
    Get.off(route);
  }

  void toOffAll(route) {
    Get.off(route);
  }
}
