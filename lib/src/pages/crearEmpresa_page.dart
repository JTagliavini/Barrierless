import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barrierless/src/bloc/empresas_bloc.dart';
import 'package:barrierless/src/bloc/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:barrierless/src/models/empresa_model.dart';

bool isSwitched1 = false;
bool isSwitched2 = false;

class CrearEmpresaPage extends StatefulWidget {
  @override
  _CrearEmpresaPageState createState() => _CrearEmpresaPageState();
}

class _CrearEmpresaPageState extends State<CrearEmpresaPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  EmpresasBloc empresasBloc;
  EmpresaModel empresa = new EmpresaModel();
  bool _guardando = false;
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
      appBar: AppBar(
        title: Text('Company'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarLogo,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarLogo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarLogo(),
                _crearNombre(),
                _crearPais(),
                _crearCiudad(),
                _crearIndustria(),
                _crearImportar(),
                _crearExportar(),
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
    return TextFormField(
      //initialValue: empresa.nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Name'),
      onSaved: (value) => empresa.nombre = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Enter the name of the company';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPais() {
    return TextFormField(
      //initialValue: empresa.pais,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Country'),
      onSaved: (value) => empresa.pais = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Enter the country of the company';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearCiudad() {
    return TextFormField(
      //initialValue: empresa.ciudad,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'City'),
      onSaved: (value) => empresa.ciudad = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Enter the city of the company';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearIndustria() {
    return TextFormField(
      //initialValue: empresa.industria,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Industry'),
      onSaved: (value) => empresa.industria = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Enter the company industry';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearMail() {
    return TextFormField(
      //initialValue: empresa.mail,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: 'Mail'),
      onSaved: (value) => empresa.mail = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Enter the company email';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearTelefono() {
    return TextFormField(
      //initialValue: empresa.telefono,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(labelText: 'Phone'),
      onSaved: (value) => empresa.telefono = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Enter the company phone';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearImportar() {
    return SwitchListTile(
      value: isSwitched1,
      title: Text('Importer'),
      activeColor: Colors.blue,
      onChanged: (value) => setState(() {
        isSwitched1 = value;
        empresa.importador = value;
      }),
    );
  }

  Widget _crearExportar() {
    empresa.exportador = false;
    return SwitchListTile(
      value: isSwitched2,
      title: Text('Exporter'),
      activeColor: Colors.blue,
      onChanged: (value) => setState(() {
        isSwitched2 = value;
        empresa.exportador = value;
      }),
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.blue,
        textColor: Colors.white,
        label: Text('Save'),
        icon: Icon(Icons.save),
        onPressed: (_guardando) ? null : _submit);
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (logo != null) {
      empresa.logoUrl = await empresasBloc.subirLogo(logo);
    }

    if (empresa.id == null) {
      empresasBloc.agregarEmpresa(empresa);
    } else {
      empresasBloc.editarEmpresa(empresa);
    }

    mostrarSnackbar('Saved record');

    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarLogo() {
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

  _seleccionarLogo() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarLogo() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    logo = await ImagePicker.pickImage(source: origen);

    if (logo != null) {
      empresa.logoUrl = null;
    }

    setState(() {});
  }
}
