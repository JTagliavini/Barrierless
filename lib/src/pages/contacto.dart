import 'package:flutter/material.dart';
import 'package:barrierless/src/bloc/mensajes_bloc.dart';
import 'package:barrierless/src/bloc/provider.dart';

import 'package:barrierless/src/models/mensaje_model.dart';
import 'package:barrierless/src/preferencias_usuario/preferencias_usuario.dart';

class ContactoPage extends StatefulWidget {
  @override
  _ContactoPageState createState() => _ContactoPageState();
}

class _ContactoPageState extends State<ContactoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  MensajesBloc mensajesBloc;
  MensajeModel mensaje = new MensajeModel();
  bool _guardando = false;

  final _prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    mensajesBloc = Provider.mensajesBloc(context);

    final MensajeModel mensajeData = ModalRoute.of(context).settings.arguments;
    if (mensajeData != null) {
      mensaje = mensajeData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text('Message')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _crearNombre(),
                _crearMensaje(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return Container(child: Text('Contact support'));
  }

  Widget _crearMensaje() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Message'),
      onSaved: (value) => mensaje.mensaje = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Enter the message';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.deepPurple,
        textColor: Colors.white,
        label: Text('Send'),
        icon: Icon(Icons.save),
        onPressed: (_guardando) ? null : _submit);
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    mensaje.destinatario = "Support";
    print(mensaje.destinatario);
    mensaje.remitente = _prefs.email.toString();
    print(mensaje.remitente);
    mensaje.timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    mensajesBloc.agregarMensaje(mensaje);

    mostrarSnackbar('Message sent');

    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
