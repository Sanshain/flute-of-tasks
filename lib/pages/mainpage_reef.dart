import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:sanshain_tasks/models/tasks.dart';
import 'package:sanshain_tasks/utils/speech.dart';
import 'package:sanshain_tasks/widgets/popups.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../controller.dart';
import '../main_page.dart';
import 'fragments/task_item.dart';
import 'input_page.dart';


mixin TasksListView implements IExpandedTaskList{

    // поля:
    int? rootTaskId; // при создании новой таски содержит ид родительской
    void Function(Task)? useSubTasksUpdate; // обновляет саб_таски
    int selectedTab = 0; // индекс активной вкладки
    int selectedIndex = -1; // индекс выделенного элемента
    bool inDetail = false; // выполнен вход в детализацию таски
    int? rootTaskIndex; // индекс корневой задачи
    String? newTaskNameTitle; // имя новой задачи
    BuildContext? rootContext; // ссылка на корневой контекст
    List<BuildContext?>? subContextWrapper = <BuildContext?>[null]; // ссылка на подконстекст (список тут в качестве ref, может содержать только один контекст)

    bool quickNew = false; // @legacy
    bool searchBar = false; // @todo?
    late FocusNode searchFocusNode; // @todo_?

    final Controller controller = Get.put<Controller>(Controller()); // ссылка на стэйт-менеджер

    List<Task> tasks = []; // реактвнй список актуальных задач
    late List<Task> archive = []; // реактвнй список выполненных задач

    // методы:

    Future<void> createTask(String newTaskNameTitle);


    Widget tasksListView({required MainPage widget, required void Function(VoidCallback cb) updateState})
    {
        var _order = controller.settings['order'];

        return Obx(() => Stack(
            children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Expanded(
                                child: ListView.separated(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: tasks.length,
                                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                                    itemBuilder: (BuildContext context, int index) =>
                                        listTileGenerate(context, index, widget: widget, stateUpdate: updateState)
                                )
                            ),
                        ],
                    ),
                ),
                // _createQuickTask(),
            ]
        ));
    }


    Column buildArchiveTab(widget, subContextWrapper, BuildContext? rootContext, bool inDetail, void Function(VoidCallback cb) stateUpdate)
    {
        var stateUp = stateUpdate;

        return Column(
            children: [
                Expanded(child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: archive.length,
                    separatorBuilder: (BuildContext context, int index)
                    => const Divider(),
                    itemBuilder: (BuildContext context, int index)
                    {
                        return createListViewPoint(context, index,
                            toLeft: const SwipeBackground(Colors.orangeAccent, Icon(Icons.unarchive_outlined)),
                            toRight: const SwipeBackground(Colors.redAccent, Icon(Icons.delete_forever)),
                            subContextWrapper: subContextWrapper,
                            tasks: archive,
                            onDismissed: (direction)
                            async {
                                if (direction == DismissDirection.endToStart) {
                                    archive[index].isDone = false;
                                    await widget.tasks.updateItem(archive[index]);
                                    stateUp(()
                                    {
                                        tasks.add(archive[index]);
                                        archive.removeAt(index);
                                    });
                                }
                                else if (direction == DismissDirection.startToEnd) {
                                    await widget.tasks.deleteItem(archive[index]);
                                    stateUp(() => archive.removeAt(index));
                                }
                            },
                            onTap: ()
                            {
                                stateUp(() => inDetail = true);
                                return (Task? task) async {
                                    if (task is Task) {
                                        await widget.tasks.updateItem(task);
                                    }
                                    stateUp(() => inDetail = false);
                                };
                            },
                            rootContext: rootContext!
                        );
                    }
                )),
            ],
        );
    }


    Future<void> createTaskPage(BuildContext context, {Task? parent}) async
    {
        var titleSuffix = parent == null ? '' : ' (for ${parent.title})';

        String? newTaskNameTitle = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => InputPage(initValue: '', title: 'New Task' + titleSuffix))
        );
        // var newTaskNameTitle = await inputDialog(context, title: 'Enter new task title');

        if (newTaskNameTitle?.isNotEmpty ?? false) {
            await createTask(newTaskNameTitle!);
        }

        rootTaskId = null;
        useSubTasksUpdate = null;
    }


    @override Widget listTileGenerate(BuildContext context, int index,
        {
            required MainPage widget,
            required void Function(VoidCallback cb) stateUpdate,
            BuildContext? parentContext,
            List<BuildContext?>? childContextWrapper,
            List<Task>? parentTasks,
            Task? parentTask,
            int deep = 0
        })
    {
        // поля:
        parentContext = parentContext ?? rootContext;
        childContextWrapper = childContextWrapper ?? subContextWrapper;

        // локальный переменные:
        var tasks = parentTasks ?? this.tasks;
        var setState = stateUpdate;

        return ListViewItem(
            context,
            index,
            page: widget,
            subContextWrapper: childContextWrapper,
            parentTask: parentTask,
            tasks: tasks,
            parent: this,
            deep: deep,
            toRight: const SwipeBackground(Colors.orangeAccent, Icon(Icons.unarchive_outlined)),
            toLeft: const SwipeBackground(Colors.redAccent, Icon(Icons.delete_forever)),
            confirmDismiss: (DismissDirection direction) async
            {
                if (direction == DismissDirection.endToStart) {
//                  var poll = await showConfirmationDialog(context, 'Вы уверены, что желаете удалить task-у?');
//                  return poll ?? false;

                    showConfirmationDialog(context, 'Вы уверены, что желаете удалить task-у?').then((poll) async
                    {
                        if (poll ?? false) {
                            await widget.tasks.deleteItem(tasks[index]);
                            setState(() => tasks.removeAt(index));

//                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content widget: Text("The task was removed")));
                        }
                    });
                }
                return true;
            },
            onDismissed: (direction)
            async
            {
                if (direction == DismissDirection.startToEnd) { // Right Swipe

                    tasks[index].isDone = true;
                    tasks[index].deadline = DateTime.now();
                    await widget.tasks.updateItem(tasks[index]);

                    setState(()
                    {
                        tasks[index].parentName = controller.tasks
                            .where((t) => tasks[index].parent == t.id)
                            .firstOrNull
                            ?.title;
                        archive.add(tasks[index]);
                        tasks.removeAt(index);
                    });
                }
                else if (direction == DismissDirection.endToStart) {
                    // move to confirmDismiss
                }
            },
            onTap: ()
            {
                setState(() => inDetail = true);
                return (Task? task) async
                {
                    if (task is Task) {
                        await widget.tasks.updateItem(task);
                    }
                    setState(() => inDetail = false);
                };
            },
            subTaskCreateAction: ({void Function(Task)? onApply}) async
            {
//                setState(() => quickNew = true);
//                useSubTasksUpdate = onApply;

                rootTaskId = tasks[index].id;
                rootTaskIndex = index;

                await createTaskPage(context, parent: tasks[index]);
            },
            expandAction: () {},
            rootContext: parentContext!
        );
    }


    Visibility buildFloatingView(BuildContext context, {required int? selectedTab, required bool? inDetail, required bool? quickNew})
    {
        return Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: selectedTab == 0 && inDetail == false && quickNew == false,
            child: Container(
                padding: const EdgeInsets.only(bottom: 50.0, right: 15.0),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                        onLongPress: ()
                        async {
                            bool available = await speech.initialize(onStatus: speechStatusListener, onError: speechErrorListener);
                            if (available) {
                                speech.listen(onResult: (SpeechRecognitionResult result)
                                async {
                                    if (result.finalResult && result.recognizedWords.isNotEmpty) {
                                        await createTask(result.recognizedWords.capitalizeFirst!);
//                                      popup(context, result.recognizedWords);
                                    }
                                });
                            }
                            else {
                                var r = await showConfirmationDialog(context, 'content');
                                if (r == true) {
                                    await createTaskPage(context);
                                }
                            }
//                          speech.stop();
                        },
                        child: FloatingActionButton(

                            onPressed: () async
                            {
                                await createTaskPage(context);
//                                setState(() {
//                                    quickNew = true;
//                                });
//
//                              Navigator.push(
//                                  context,
//                                  PageRouteBuilder(
//                                    pageBuilder: (context, animation, secondaryAnimation) => TaskEdit(subContextWrapper, title: ''),
//                                    transitionsBuilder: instantTransition,
//                                  )
//                                  // MaterialPageRoute(builder: (context) => TaskEdit(subContextWrapper, title: ''))
//                              );
//
//                              popup(context, 'some content', title: 'title');
//                              input(context, 'some content', title: 'title');
                            },
                            child: const Icon(Icons.add),
//                          icon: const Icon(Icons.phone_android),
//                          label: const Text("Authenticate using Phone"),
                        ),
                    ),
                ),
            ),
        );
    }


}

