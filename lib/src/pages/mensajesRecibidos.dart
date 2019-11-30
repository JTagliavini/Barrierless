import 'package:flutter/material.dart';
import 'package:barrierless/src/bloc/provider.dart';
import 'package:barrierless/src/models/mensaje_model.dart';
import 'package:barrierless/src/preferencias_usuario/preferencias_usuario.dart';

class MensajesRecibidosPage extends StatefulWidget {
  @override
  _MensajesRecibidosPageState createState() => _MensajesRecibidosPageState();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
}

class _MensajesRecibidosPageState extends State<MensajesRecibidosPage> {
  final _prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    final mensajesBloc = Provider.mensajesBloc(context);
    mensajesBloc.cargarMensajes();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushNamed(context, 'perfil');
                })
          ],
          title: Text('Messages'),
        ),
        body: _crearListado(mensajesBloc),
        bottomNavigationBar: _bottomNavigationBar(context),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
            child: Text('Barrierless'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('My company'),
            onTap: () {
              Navigator.pushNamed(context, 'perfil');
            },
          ),
          ListTile(
            title: Text('Messages'),
            onTap: () {
              Navigator.pushNamed(context, 'mensajesRecibidos');
            },
          ),
          ListTile(
            title: Text('Contact'),
            onTap: () {
              Navigator.pushNamed(context, 'contacto');
            },
          )
        ])));
  }

  int _selectedIndex = 0;

  Widget _bottomNavigationBar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
          primaryColor: Colors.blue,
          textTheme: Theme.of(context)
              .textTheme
              .copyWith(caption: TextStyle(color: Colors.blue))),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            title: Text('Received'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            title: Text('Sent'),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) Navigator.pushReplacementNamed(context, 'mensajesEnviados');

    _selectedIndex = index;
    setState(() {});
  }

  Widget _crearListado(MensajesBloc mensajesBloc) {
    return StreamBuilder(
      stream: mensajesBloc.mensajesStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<MensajeModel>> snapshot) {
        if (snapshot.hasData) {
          final mensajes = snapshot.data;
          return ListView.builder(
            itemCount: mensajes.length,
            itemBuilder: (context, i) =>
                (mensajes[i].destinatario == _prefs.email.toString())
                    ? _crearItem(context, mensajesBloc, mensajes[i])
                    : null,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(
      BuildContext context, MensajesBloc mensajesBloc, MensajeModel mensaje) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        child: Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(mensaje.destinatario),
                subtitle: Text(mensaje.mensaje),
              ),
            ],
          ),
        ));
  }
}
