import 'package:postgres/postgres.dart';

class DatabaseService {
  late PostgreSQLConnection connection;

  Future<void> connect() async {
    connection = PostgreSQLConnection(
      "192.168.1.8", // Laptop IP
      5432,
      "graduation",
      username: "elia",
      password: "graduation2027",
    );
    await connection.open();
    print("Connected to PostgreSQL!");
  }
}
