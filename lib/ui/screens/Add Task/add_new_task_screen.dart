import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_widget/ui/state_manager/addNewTaskController/add_new_task_controller.dart';
import 'package:intro_widget/ui/widgets/user_profile_banner.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserProfileBanner(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Add new task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _titleTEController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GetBuilder<AddNewTaskController>(
                      builder: (addNewTaskController) {
                    return SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible:
                            addNewTaskController.addNewTaskInProgress == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                            onPressed: () {
                              addNewTaskController
                                  .addNewTask(_titleTEController.text.trim(),
                                      _descriptionTEController.text.trim())
                                  .then((value) {
                                if (value) {
                                  _titleTEController.clear();
                                  _descriptionTEController.clear();
                                  Get.snackbar(
                                      "Success", 'Task added successfully');
                                } else {
                                  Get.snackbar('failed', 'Task add failed!');
                                }
                              });
                            },
                            child: const Icon(Icons.arrow_forward_ios)),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
