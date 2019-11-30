// https://stackoverflow.com/questions/50652071/flutter-commands-not-working

// https://itsallwidgets.com/
// https://flutterawesome.com/

import 'package:flutter/material.dart';

import 'package:barrierless/src/bloc/provider.dart';

import 'package:barrierless/src/pages/home_page.dart';
import 'package:barrierless/src/pages/exportadores_page.dart';
import 'package:barrierless/src/pages/importadores_page.dart';
import 'package:barrierless/src/pages/favoritos_page.dart';
import 'package:barrierless/src/pages/login_page.dart';
import 'package:barrierless/src/pages/registro_page.dart';
import 'package:barrierless/src/pages/perfil_page.dart';
import 'package:barrierless/src/pages/crearEmpresa_page.dart';
import 'package:barrierless/src/pages/empresa_page.dart';
import 'package:barrierless/src/pages/crearMensaje.dart';
import 'package:barrierless/src/pages/mensajesEnviados_page.dart';
import 'package:barrierless/src/pages/mensajesRecibidos.dart';
import 'package:barrierless/src/pages/contacto.dart';
import 'package:barrierless/src/preferencias_usuario/preferencias_usuario.dart';

void main() async {
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: (prefs.token.toString() != '') ? 'exportadores' : 'home',
        routes: {
          'home': (BuildContext context) => HomePage(),
          'login': (BuildContext context) => LoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'exportadores': (BuildContext context) => ExportadoresPage(),
          'importadores': (BuildContext context) => ImportadoresPage(),
          'favoritos': (BuildContext context) => FavoritosPage(),
          'perfil': (BuildContext context) => PerfilPage(),
          'crearEmpresa': (BuildContext context) => CrearEmpresaPage(),
          'empresa': (BuildContext context) => EmpresaPage(),
          'crearMensaje': (BuildContext context) => CrearMensajePage(),
          'mensajesEnviados': (BuildContext context) => MensajesEnviadosPage(),
          'mensajesRecibidos': (BuildContext context) =>
              MensajesRecibidosPage(),
          'contacto': (BuildContext context) => ContactoPage()
        },
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
      ),
    );
  }
}
