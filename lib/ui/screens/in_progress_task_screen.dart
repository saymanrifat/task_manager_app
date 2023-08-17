import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_widget/data/models/task_list_model.dart';
import 'package:intro_widget/ui/screens/update_task_status_sheet.dart';
import 'package:intro_widget/ui/state_manager/delete_task_controller.dart';
import 'package:intro_widget/ui/state_manager/in_progress_task_controller.dart';
import 'package:intro_widget/ui/widgets/task_list_tile.dart';
import 'package:intro_widget/ui/widgets/user_profile_banner.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({Key? key}) : super(key: key);

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  final InProgressTaskController _inProgressTaskController =
      Get.find<InProgressTaskController>();

  final DeleteTaskController _deleteTaskController =
      Get.find<DeleteTaskController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _inProgressTaskController.getInProgressTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserProfileBanner(),
            GetBuilder<InProgressTaskController>(
                builder: (inProgressTaskController) {
              return Expanded(
                child: inProgressTaskController.getProgressTasksInProgress
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemCount: inProgressTaskController
                                .taskListModel.data?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return TaskListTile(
                            data: inProgressTaskController
                                .taskListModel.data![index],
                            onDeleteTap: () {
                              _deleteTaskController
                                  .deleteTask(
                                      inProgressTaskController
                                          .taskListModel.data![index].sId!,
                                      inProgressTaskController.taskListModel)
                                  .then((value) {
                                if (value) {
                                  Get.snackbar('Success', "Task");
                                  inProgressTaskController.getInProgressTasks();
                                } else {
                                  Get.snackbar('failed', "Task");
                                }
                              });
                            },
                            onEditTap: () {
                              // showEditBottomSheet(_taskListModel.data![index]);
                              showStatusUpdateBottomSheet(
                                  inProgressTaskController
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
              _inProgressTaskController.getInProgressTasks();
            });
      },
    );
  }
}
