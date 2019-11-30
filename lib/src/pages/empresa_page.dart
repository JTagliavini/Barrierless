import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barrierless/src/bloc/empresas_bloc.dart';
import 'package:barrierless/src/bloc/provider.dart';

import 'package:barrierless/src/models/empresa_model.dart';

import 'package:barrierless/src/preferencias_usuario/preferencias_usuario.dart';

class EmpresaPage extends StatefulWidget {
  @override
  _EmpresaPageState createState() => _EmpresaPageState();
}

class _EmpresaPageState extends State<EmpresaPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _prefs = new PreferenciasUsuario();

  EmpresasBloc empresasBloc;
  EmpresaModel empresa = new EmpresaModel();
  File logo;

  @override
  Widget build(BuildContext context) {
    empresasBloc = Provider.empresasBloc(context);

    final EmpresaModel empresaData = ModalRoute.of(context).settings.arguments;
    if (empresaData != null) {
      empresa = empresaData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text('Company')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearTipo(),
                _crearNombre(),
                _crearPais(),
                _crearCiudad(),
                _crearIndustria(),
                _crearMail(),
                _crearTelefono(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return Container(child: Text('Company name: ${empresa.nombre}'));
  }

  _crearPais() {
    return Container(child: Text('Country: ${empresa.pais}'));
  }

  _crearCiudad() {
    return Container(child: Text('City: ${empresa.ciudad}'));
  }

  _crearIndustria() {
    return Container(child: Text('Industry: ${empresa.industria}'));
  }

  _crearMail() {
    return Container(child: Text('Mail: ${empresa.mail}'));
  }

  _crearTelefono() {
    return Container(child: Text('Phone: ${empresa.telefono}'));
  }

  _crearTipo() {
    if (empresa.importador && empresa.exportador)
      return Container(child: Text('Importer and exporter'));
    else if (empresa.importador)
      return Container(child: Text('Importer'));
    else
      return Container(child: Text('Exporter'));
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.blue,
        textColor: Colors.white,
        label: Text('Message'),
        icon: Icon(Icons.mail),
        onPressed: () {
          _prefs.destinatarioNombre = empresa.nombre.toString();
          _prefs.destinatario = empresa.mail.toString();
          Navigator.pushNamed(context, 'crearMensaje');
        });
  }

  //void _submit() async {
  // if (!formKey.currentState.validate()) return;
//
//    formKey.currentState.save();
//
//    mostrarSnackbar('Registro guardado');
//
//    Navigator.pop(context);
//  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (empresa.logoUrl != null) {
      return FadeInImage(
        image: NetworkImage(empresa.logoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: AssetImage(logo?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }
}
