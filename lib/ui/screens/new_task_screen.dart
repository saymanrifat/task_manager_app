import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_widget/data/models/network_response.dart';
import 'package:intro_widget/data/models/task_list_model.dart';
import 'package:intro_widget/data/services/network_caller.dart';
import 'package:intro_widget/data/utils/urls.dart';
import 'package:intro_widget/ui/screens/add_new_task_screen.dart';
import 'package:intro_widget/ui/screens/update_task_bottom_sheet.dart';
import 'package:intro_widget/ui/screens/update_task_status_sheet.dart';
import 'package:intro_widget/ui/state_manager/delete_task_controller.dart';
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
  TaskListModel _taskListModel = TaskListModel();

  bool _getNewTaskInProgress = false;

  final SummaryCountController _summaryCountController =
      Get.find<SummaryCountController>();
  final DeleteTaskController _deleteTaskController =
      Get.put(DeleteTaskController());

  @override
  void initState() {
    super.initState();
    // after widget binding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _summaryCountController.getCountSummary();
      getNewTasks();
    });
  }

  Future<void> getNewTasks() async {
    _getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.newTasks);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Summary data get failed')));
      }
    }
    _getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
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
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getNewTasks();
                  _summaryCountController.getCountSummary();
                },
                child: _getNewTaskInProgress
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemCount: _taskListModel.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskListTile(
                            data: _taskListModel.data![index],
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
                              showStatusUpdateBottomSheet(
                                  _taskListModel.data![index]);
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const AddNewTaskScreen()));

          GetxRouting().to(const AddNewTaskScreen());
        },
      ),
    );
  }

  void showEditBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskSheet(
          task: task,
          onUpdate: () {
            getNewTasks();
          },
        );
      },
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
              getNewTasks();
            });
      },
    );
  }
}
