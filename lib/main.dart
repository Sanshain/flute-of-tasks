import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Some Awesome App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'The Tasks'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => MainPageState();
}

// ignore: use_key_in_widget_constructors
class UsersList extends StatefulWidget {
  const UsersList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  MainPageState createState() => MainPageState();
}


class MainPageState extends State<MainPage> {
  int _counter = 0;
  int selectedIndex = -1;
  final List<String> users = [
    "Tom", "Alice", "Sam", "Bob", "Kate",
    "Tom", "Alice", "Sam", "Bob", "Kate",
    "Tom", "Alice", "Sam", "Bob", "Kate"
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget _createListView(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: index == selectedIndex ? Colors.black12: Colors.white60,
        child: Text(users[index], style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: ListView.builder(
            itemCount: users.length,
            itemBuilder: _createListView,
          ))
        ],
      ),
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            const Text(
//              'You have pushed the button this many times 5:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.headline4,
//            ),
//          ],
//        ),
//      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.accessibility),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
