import 'package:flutter/material.dart';

import 'package:barrierless/src/bloc/login_bloc.dart';
export 'package:barrierless/src/bloc/login_bloc.dart';

import 'package:barrierless/src/bloc/empresas_bloc.dart';
export 'package:barrierless/src/bloc/empresas_bloc.dart';

import 'package:barrierless/src/bloc/mensajes_bloc.dart';
export 'package:barrierless/src/bloc/mensajes_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = new LoginBloc();
  final _empresasBloc = new EmpresasBloc();
  final _mensajesBloc = new MensajesBloc();

  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        .loginBloc;
  }

  static EmpresasBloc empresasBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        ._empresasBloc;
  }

  static MensajesBloc mensajesBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        ._mensajesBloc;
  }
}
