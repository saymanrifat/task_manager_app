import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_widget/data/models/task_list_model.dart';
import 'package:intro_widget/ui/screens/update_task_status_sheet.dart';
import 'package:intro_widget/ui/state_manager/completed_task_controller.dart';
import 'package:intro_widget/ui/state_manager/delete_task_controller.dart';
import 'package:intro_widget/ui/widgets/task_list_tile.dart';
import 'package:intro_widget/ui/widgets/user_profile_banner.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({Key? key}) : super(key: key);

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final CompletedTaskController _completedTaskController =
      Get.find<CompletedTaskController>();

  final DeleteTaskController _deleteTaskController =
      Get.find<DeleteTaskController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _completedTaskController.getCompletedTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserProfileBanner(),
            GetBuilder<CompletedTaskController>(
                builder: (completedTaskController) {
              return Expanded(
                child: completedTaskController.getCompletedTasksInProgress
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemCount: completedTaskController
                                .taskListModel.data?.length ??
                            0,
                        itemBuilder: (context, index) {
                          return TaskListTile(
                            data: completedTaskController
                                .taskListModel.data![index],
                            onDeleteTap: () {
                              _deleteTaskController
                                  .deleteTask(
                                      completedTaskController
                                          .taskListModel.data![index].sId!,
                                      completedTaskController.taskListModel)
                                  .then((value) {
                                if (value) {
                                  Get.snackbar('Success', "Task Deleted");
                                  completedTaskController.getCompletedTasks();
                                } else {
                                  Get.snackbar('failed', "Task Deleted failed");
                                }
                              });
                            },
                            onEditTap: () {
                              // showEditBottomSheet(_taskListModel.data![index]);
                              showStatusUpdateBottomSheet(
                                  completedTaskController
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
              _completedTaskController.getCompletedTasks();
            });
      },
    );
  }
}
