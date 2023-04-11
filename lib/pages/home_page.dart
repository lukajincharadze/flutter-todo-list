import 'package:flutter/material.dart';
import 'package:todo/data_models/todo.dart';
import 'package:todo/database/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: "Item to buy"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: "description"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await DatabaseHelper().insertTodo(
                    Todo(
                      title: titleController.text,
                      description: descriptionController.text,
                    ),
                  );
                  setState(() {});
                  titleController.clear();
                  descriptionController.clear();
                },
                child: const Text("Add to list"),
              ),
              SizedBox(
                height: 400,
                child: FutureBuilder<List<Todo>>(
                  future: DatabaseHelper().getTodos(),
                  builder: (context, snapshot) {
                    final todos = snapshot.data ?? [];
                    return ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 5,
                                    offset: const Offset(5, 5),
                                    spreadRadius: 2,
                                  )
                                ]),
                            child: ListTile(
                              title: Text(todo.title),
                              subtitle: Text(todo.description),
                              trailing: IconButton(
                                onPressed: () async {
                                  await DatabaseHelper().deleteTodo(todo.id!);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}