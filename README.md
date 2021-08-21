# some_app

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Database struct update:

- `flutter packages pub run build_runner build`
- Then add following lines to constructors with queries having fields named subTasksAmount/doneSubTasksAmount:
    ```
            subTasksAmount: row['subTasksAmount'] as int?,
            doneSubTasksAmount: row['doneSubTasksAmount'] as int?
    ```
- Add following line to `getAll()` function in Place constructor:
    ```
            tasksAmount: row['tasksAmount'] as int
    ```
- 

## Build to release:

- `flutter run --release [-t lib/main_page.dart]`
