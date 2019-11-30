import 'dart:io';

import 'package:barrierless/src/providers/mensaje_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:barrierless/src/models/mensaje_model.dart';

class MensajesBloc {
  final _mensajesController = new BehaviorSubject<List<MensajeModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _mensajesProvider = new MensajesProvider();

  Stream<List<MensajeModel>> get mensajesStream => _mensajesController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  void cargarMensajes() async {
    final mensajes = await _mensajesProvider.cargarMensajes();
    _mensajesController.sink.add(mensajes);
  }

  void agregarMensaje(MensajeModel mensaje) async {
    _cargandoController.sink.add(true);
    await _mensajesProvider.crearMensaje(mensaje);
    _cargandoController.sink.add(false);
  }

  void editarMensaje(MensajeModel mensaje) async {
    _cargandoController.sink.add(true);
    await _mensajesProvider.editarMensaje(mensaje);
    _cargandoController.sink.add(false);
  }

  void borrarMensaje(String id) async {
    await _mensajesProvider.borrarMensaje(id);
  }

  dispose() {
    _mensajesController?.close();
    _cargandoController?.close();
  }
}
