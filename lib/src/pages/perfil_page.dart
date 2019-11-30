import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:barrierless/src/providers/usuario_provider.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: Text('Profile')),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[_titulos(), _perfil(context)],
            ),
          )
        ],
      ),
    );
  }

  Widget _titulos() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Barrierless',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Widget _perfil(BuildContext context) {
    final _usuarioProvider = new UsuarioProvider();

    return Column(
      children: <Widget>[
        Container(
            child: Center(
          child: Text("Hi, thank you for using our application."),
        )),
        SizedBox(height: 150.0),
        FlatButton(
          child: Text("Log out"),
          onPressed: () {
            _usuarioProvider.logout();

            Navigator.pushReplacementNamed(context, 'login');
          },
          color: Colors.blue,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
