import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/data_models/todo.dart';

class DatabaseHelper {
  // შევქმენით ცვლადი, რომლის დახმარებით შეგვეძლება მონაცემთა ბაზასთან დაკავშირება
  // static keyword მიანიშნებს, რომ ცვლადი ყველა ობიექტისთვის რომელიც ამ კლასიდან შეიქმნება იქნება საერთო
  // ცვლადის სახელის წინ _ (ქვედატირე) მიანიშნებს, რომ ცვლადი არ გამოჩნდება ამ კლასის გარეთ (private variable - "კერძო" ჩვლადი)
  static Database? _database;

  //"getter" ფუნქციის საშვალებით სხვა კლასებს საშვალება მივეცით წაიკითხონ ცვლადის მნიშნვნელობა. თუმცა ცვლადის მნიშვნელობის შეცვლა არ შეეძლებათ.
  Future<Database?> get database async {
    // თუ კი _database ცვლადი შეიცავს რაიმე მნიშვნელობას (არ არის null) "გეთერი" დააბრუნებს ამ ცვლადის მნიშვნელობას
    if (_database != null) {
      return _database;
    }
    // წინააღმდეგ შემთხვევაში "გეთთერი" გამოიძახებს ფუნქცია _initDatabase_ს და _database ცვლადში შეინახავს ფუნქციიდან დაბრუნებულ მნიშვნელობას.
    // ეს კოდის ფრაგმენტ გაეშვება მხოლოდ ერთხელ ყოველი სესიისათვის. ყველა სხვა გამოძახებისას (database ცვლადის დაძახებისას) ცვლადის მნიშვნელობა არ იქნება null
    _database = await _initDatabase();
    return _database;
  }

  // ეს არის ფუნქცია რომელიც პასუხისმგებელია _database ცვლადისათვის მნიშვნელობის მინიჭებისათვის.
  // უფრო კონკრეტულად ფუნქცია დააბრუნებს "კავშირის" ობიექტს რომლის დახმარებით შეგვეძლება მონაცემთა ბაზაში ინფორმაციის შენახვა, წაკითხვა, შეცვლა და წაშლა. ეგრედწოდებული CRUD ოპერაციები(Create, Read, Update, Delete)

  Future<Database?> _initDatabase() async {
    // Path ბიბლიოთეკის დახმარებით, რომელიც პროექტში შემოვიტანეთ სხვადასხვა პლათფორმაზე ვიგებთ მონაცემთა ბაზებთან დაკავშირებული ფაილების ფოლდერის ლოკაციას და ვინახავთ databasePath ცვლადში
    final String databasePath = await getDatabasesPath();
    // ამ ფოლდერის ლოკაციას ვაერთიანებთ ჩვენს მიერ არჩეულ მონაცემთა ბაზის სახელთან
    final String path = join(databasePath, "todo_database.db");

    // openDatabase ფუნქციის დახმარებით ვხსნით მონაცემთა ბაზას სახელად "todo_database.db" თუ კი ასეთი ჯერ არ არსებობს მაშინ გამოიძახება onCreate პარამეტრში გადაცემული ფუნქცია
    return openDatabase(
      // მონაცემთა ბაზის ფაილის სახელი და მისი ლოკაცია კონკრეტულ პლათფორმაზე
      path,
      // მონაცემთა ბაზის ვერსია
      version: 1,
      // ამ ფუნქციის დახმარებით ვქმნით Table_ს სახელად todos და მივუთითებთ რომ ყოველი ელემენტი ამ მონაცემთა ბაზაში შედგენილი იქნება 3 პარამეტრისაგან(id, title, description)
      // id პარამეტრის მნიშვნელობას ყოველი ახალი ელემენტისათვის sqflite ბიბლიოთეკა ავტომატურად დააგენერირებს რანდომ ინტეჯერს
      onCreate: (Database db,int version) async {
        await db.execute(
          'CREATE TABLE todos (id INTEGER PRIMARY KEY,title TEXT, description TEXT)'
        );
      }
    );
  }

  // ფუნქცია რომლის საშვალებით შეგვეძლება შევინახოთ Todo ობიექტი
  Future<void> insertTodo(Todo todo) async {
    //შევქმენით ცვლადი სახელად db და მასში შევინახეთ მონაცემთა კავშირთან "კავშირის" ობიექტი
    final db = await database;
    // Database კლასში არსებული insert ღილაკის დახმარებით ვინახავთ ფუნქციის პარამეტრად გადმოცემულ todo ობიექტს
    await db?.insert(
      // მაგიდის სახელი
      'todos',
      // შესანახი ობიექტი "გადაკეთებული" Map მონაცემის ტიპად
      todo.toMap(),
      // იმ შემთხვევაში თუ მონაცემთა ბაზაში იქნება ელემენტი იგივე id_ით მას უბრალოდ ახლით შევცვლით
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Todo>> getTodos () async {
    final db = await database;

    if(db == null) {
      return [];
    }

    final List<Map<String, dynamic>> maps = await db.query('todos');

    return List.generate(maps.length, (index) => Todo(
      id: maps[index]['id'],
      title: maps[index]['title'],
      description: maps[index]['description'],
    ));
  }

}









