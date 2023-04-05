import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todoInputController = TextEditingController();
  final List<String> todos = [];

  List<Widget> getTodoWidgets() {
    List<Widget> temp = [];

    for (int i = 0; i < todos.length; i++) {
      temp.add(Text(todos[i]));
    }

    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
      ),
      body: Column(
        children: [
          Row(
            children: [

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    todos.add(todoInputController.text);
                    todoInputController.clear();
                  });
                },
                child: Text("Add"),
              )
            ],
          ),
          Container(
            height: 200,
            child: ListView(
              children: getTodoWidgets(),
            ),
          ),
        ],
      ),
    );
  }
}
