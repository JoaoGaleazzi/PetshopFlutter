import 'dart:convert';
import 'package:mysql1/mysql1.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:crypto/crypto.dart';

// Configuração do banco de dados MySQL
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


String hashPassword(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

Future<Response> _loginHandler(Request request) async {
  final conn = await getConnection();

  try {
    final payload = jsonDecode(await request.readAsString());
    final email = payload('email');
    final password = hashPassword(payload('password'));

    final results =
    await conn.query("SELECT password from users where email = ?", [email]);
    if (results.isNotEmpty && results.first[0] == password) {
      return Response.ok(
          jsonEncode({'success': true, 'message': 'Login bem sucedido'}),
          headers: {'Content-type': 'application/json'});
    }
    return Response.forbidden(
        jsonEncode({'success': false, 'message': 'Usuário não cadastrado'}),
        headers: {'Content-type': 'application/json'});
  }catch (erro) {
    return Response.internalServerError(
      body : jsonEncode({'sucess': false, 'error': erro.toString()}));
  } finally {
      await conn.close();
  }
}

Future<Response> _registerHandler(Request request) async {
  final conn = await getConnection();
  try {
    final payload = jsonDecode(await request.readAsString());
    final email = payload('email');
    final password = hashPassword(payload('password'));

    final checkUser =
      await conn.query("SELECT password from users where email = ?", [email]);
      if (checkUser.isNotEmpty && checkUser.first[0] == password) {
        return Response.forbidden(
            jsonEncode({'success': false, 'message': 'Usuário já cadastrado'}),
            headers: {'Content-type': 'application/json'});
      }
      await conn.query("INSERT into users (email,password) values (?,?)", [email,password]);
      return Response.ok(
        jsonEncode({'sucess': true, 'message': 'Inclusão efetuada com sucesso'}),
        headers: {'Content-type': 'application/json'});
  }catch (erro) {
    return Response.internalServerError(
        body : jsonEncode({'sucess': false, 'error': erro.toString()}));
  } finally {
    await conn.close();
  }
}

void main() async {
  final router = Router()
    ..post('/login', _loginHandler)
    ..post('/register', _registerHandler);

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);
  final server = await shelf_io.serve(handler, '0.0.0.0', 3000);
  print('Servidor rodando em http://${server.address.host}:${server.port}');
}