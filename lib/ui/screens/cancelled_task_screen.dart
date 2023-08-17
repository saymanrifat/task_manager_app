import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_widget/data/models/task_list_model.dart';
import 'package:intro_widget/ui/screens/update_task_status_sheet.dart';
import 'package:intro_widget/ui/state_manager/cancelled_task_controller.dart';
import 'package:intro_widget/ui/state_manager/delete_task_controller.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/user_profile_banner.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({Key? key}) : super(key: key);

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  final CancelledTaskController _cancelledTaskController =
      Get.find<CancelledTaskController>();
  final DeleteTaskController _deleteTaskController =
      Get.find<DeleteTaskController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _cancelledTaskController.getCanceledTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserProfileBanner(),
            GetBuilder<CancelledTaskController>(
                builder: (cancelledTaskController) {
              return Expanded(
                child: cancelledTaskController.getCanceledTasksInProgress
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemCount: cancelledTaskController
                                .taskListModel.data?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return TaskListTile(
                            data: cancelledTaskController
                                .taskListModel.data![index],
                            onDeleteTap: () {
                              _deleteTaskController
                                  .deleteTask(
                                      cancelledTaskController
                                          .taskListModel.data![index].sId!,
                                      cancelledTaskController.taskListModel)
                                  .then((value) {
                                if (value) {
                                  Get.snackbar('Success', "Task Deleted");
                                  _cancelledTaskController.getCanceledTasks();
                                } else {
                                  Get.snackbar('failed', "Task Deleted failed");
                                }
                              });
                            },
                            onEditTap: () {
                              // showEditBottomSheet(_taskListModel.data![index]);
                              showStatusUpdateBottomSheet(
                                  cancelledTaskController
                                      .taskListModel.data![index]);
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 4,
                          );
                        },
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void showStatusUpdateBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskStatusSheet(
            task: task,
            onUpdate: () {
              _cancelledTaskController.getCanceledTasks();
            });
      },
    );
  }
}
