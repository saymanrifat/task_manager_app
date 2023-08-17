import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_widget/data/models/task_list_model.dart';
import 'package:intro_widget/ui/screens/Add%20Task/add_new_task_screen.dart';
import 'package:intro_widget/ui/screens/update_task_status_sheet.dart';
import 'package:intro_widget/ui/state_manager/delete_task_controller.dart';
import 'package:intro_widget/ui/state_manager/new_task_controller.dart';
import 'package:intro_widget/ui/state_manager/summeryCountController.dart';
import 'package:intro_widget/ui/utils/routing_managment.dart';
import 'package:intro_widget/ui/widgets/screen_background.dart';
import 'package:intro_widget/ui/widgets/summary_card.dart';
import 'package:intro_widget/ui/widgets/task_list_tile.dart';
import 'package:intro_widget/ui/widgets/user_profile_banner.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final SummaryCountController _summaryCountController =
      Get.find<SummaryCountController>();
  final NewTaskController _newTaskController = Get.find<NewTaskController>();
  final DeleteTaskController _deleteTaskController =
      Get.put(DeleteTaskController());

  @override
  void initState() {
    super.initState();
    // after widget binding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _summaryCountController.getCountSummary();
      _newTaskController.getNewTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: [
            const UserProfileBanner(),
            GetBuilder<SummaryCountController>(
                builder: (summaryCountController) {
              if (summaryCountController.getCountSummaryInProgress) {
                return const Center(
                  child: LinearProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _summaryCountController
                            .summaryCountModel.data?.length ??
                        0,
                    itemBuilder: (context, index) {
                      return SummaryCard(
                        title: _summaryCountController
                                .summaryCountModel.data![index].sId ??
                            'New',
                        number: _summaryCountController
                                .summaryCountModel.data![index].sum ??
                            0,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 4,
                      );
                    },
                  ),
                ),
              );
            }),
            GetBuilder<NewTaskController>(builder: (newTaskController) {
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    newTaskController.getNewTasks();
                    _summaryCountController.getCountSummary();
                  },
                  child: newTaskController.getNewTaskInProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.separated(
                          itemCount:
                              newTaskController.taskListModel.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskListTile(
                              data:
                                  newTaskController.taskListModel.data![index],
                              onDeleteTap: () {
                                // _deleteTaskController
                                //     .deleteTask(
                                //     cancelledTaskController
                                //         .taskListModel.data![index].sId!,
                                //     cancelledTaskController.taskListModel)
                                //     .then((value) {
                                //   if (value) {
                                //     Get.snackbar('Success', "Task Deleted");
                                //     _cancelledTaskController.getCanceledTasks();
                                //   } else {
                                //     Get.snackbar('failed', "Task Deleted failed");
                                //   }
                                // });
                              },
                              onEditTap: () {
                                // showEditBottomSheet(_taskListModel.data![index]);
                                showStatusUpdateBottomSheet(newTaskController
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
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          GetxRouting().to(const AddNewTaskScreen());
        },
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
              _newTaskController.getNewTasks();
              _summaryCountController.getCountSummary();
            });
      },
    );
  }
}
