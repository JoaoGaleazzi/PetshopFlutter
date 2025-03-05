import 'package:mysql1/mysql1.dart';
import 'dart:async';

Future<void> main() async {
  final settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'pets',
    password: 'pass',
    db: 'petshop'
  );

  MySqlConnection? conn; //Que cheirinho de gambiarra

  try {
    conn = await MySqlConnection.connect(settings);
    print(await conn.query('Select * FROM users'));
  } 

  catch (e) {
    rethrow;
  }

  finally {
    await conn?.close();
    print('feshow');
  }
}