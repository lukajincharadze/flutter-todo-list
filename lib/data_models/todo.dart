class Todo {
  int? id;
  String title;
  String description;

  Todo({
    this.id,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  Todo.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['title'];
}
