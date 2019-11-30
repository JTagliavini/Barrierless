import 'package:flutter/material.dart';
import 'package:barrierless/src/bloc/provider.dart';
import 'package:barrierless/src/models/empresa_model.dart';

class ExportadoresPage extends StatefulWidget {
  @override
  _ExportadoresPageState createState() => _ExportadoresPageState();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
}

class _ExportadoresPageState extends State<ExportadoresPage> {
  @override
  Widget build(BuildContext context) {
    final empresasBloc = Provider.empresasBloc(context);
    empresasBloc.cargarEmpresas();

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
          title: Text('Exporters'),
        ),
        body: _crearListado(empresasBloc),
        floatingActionButton: _crearBoton(context),
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
            icon: Icon(Icons.call_made),
            title: Text('Exporters'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_received),
            title: Text('Importers'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Favorites'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) Navigator.pushReplacementNamed(context, 'importadores');
    if (index == 2) Navigator.pushReplacementNamed(context, 'favoritos');

    _selectedIndex = index;
    setState(() {});
  }

  Widget _crearListado(EmpresasBloc empresasBloc) {
    return StreamBuilder(
      stream: empresasBloc.empresasStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<EmpresaModel>> snapshot) {
        if (snapshot.hasData) {
          final empresas = snapshot.data;
          return ListView.builder(
            itemCount: empresas.length,
            itemBuilder: (context, i) =>
                _crearItem(context, empresasBloc, empresas[i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(
      BuildContext context, EmpresasBloc empresasBloc, EmpresaModel empresa) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) => empresasBloc.borrarEmpresa(empresa.id),
        child: Card(
          child: Column(
            children: <Widget>[
              (empresa.logoUrl == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      image: NetworkImage(empresa.logoUrl),
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover),
              ListTile(
                title: Text('${empresa.nombre} - ${empresa.pais}'),
                subtitle: Text(empresa.industria),
                onTap: () =>
                    Navigator.pushNamed(context, 'empresa', arguments: empresa),
              ),
            ],
          ),
        ));
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.search),
      backgroundColor: Colors.blue,
      onPressed: () => Navigator.pushNamed(context, 'empresa'),
    );
  }
}
