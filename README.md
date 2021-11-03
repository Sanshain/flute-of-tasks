# Flute of tasks

**Flute of tanks** is a program for planning your time and priorities. This is a kind of notebook with the ability to group tasks with a convenient and responsive UI interface. The program is open source, and does not serve the purpose of making money. IF you want to know more, walk [here (Home page)](https://sanshain.github.io/flute-of-tasks/).

## Getting Started

This project has developed via Flutter framework.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Development features:

### Database struct update:

This app uses floor as orm, which has some imperfections. On each code generation you willl need in manual edition generated orm file:

- `flutter packages pub run build_runner build`
- Then add following lines to constructors with queries having fields named subTasksAmount/doneSubTasksAmount:
    ```dart
    subTasksAmount: row['subTasksAmount'] as int?,
    doneSubTasksAmount: row['doneSubTasksAmount'] as int?
    ```
- Add following line to `getAll()` function in Place constructor:
    ```js
    tasksAmount: row['tasksAmount'] as int
    ```

## Build to release:

- `flutter run --release [-t lib/main_page.dart]`


