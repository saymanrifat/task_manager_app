import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intro_widget/data/models/task_list_model.dart';
import 'package:intro_widget/ui/state_manager/update_task_controller.dart';

class UpdateTaskSheet extends StatefulWidget {
  final TaskData task;
  final VoidCallback onUpdate;

  const UpdateTaskSheet(
      {super.key, required this.task, required this.onUpdate});

  @override
  State<UpdateTaskSheet> createState() => _UpdateTaskSheetState();
}

class _UpdateTaskSheetState extends State<UpdateTaskSheet> {
  late TextEditingController _titleTEController;
  late TextEditingController _descriptionTEController;

  @override
  void initState() {
    _titleTEController = TextEditingController(text: widget.task.title);
    _descriptionTEController =
        TextEditingController(text: widget.task.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Update task',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
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
              GetBuilder<UpdateTaskController>(builder: (updateTaskController) {
                return SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: updateTaskController.updateTaskInProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                        onPressed: () {
                          updateTaskController
                              .updateTask(_titleTEController.text.trim(),
                                  _descriptionTEController.text.trim())
                              .then((value) {
                            if (value) {
                              _titleTEController.clear();
                              _descriptionTEController.clear();
                              widget.onUpdate();
                              Get.snackbar(
                                  "Success", 'Task updated successfully');
                            } else {
                              Get.snackbar(
                                  "Failed", 'Task updated unsuccessfully');
                            }
                          });
                        },
                        child: const Text('Update')),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
