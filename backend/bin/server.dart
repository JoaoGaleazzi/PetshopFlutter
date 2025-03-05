import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

final settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'pets',
    password: 'pass',
    db: 'petshop1'
);

Future<MySqlConnection> getConnection() async {
  return await MySqlConnection.connect(settings);
}

void main() async {
  final router = Router();
    //..post('/login', _loginHandler)
    //..post('/register', _registerHandler)

      final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);
      final server  = await shelf_io.serve(handler,'0.0.0.0',3000);
      print('Servidor rodando em http://${server.address.host}:${server.port}');
}
