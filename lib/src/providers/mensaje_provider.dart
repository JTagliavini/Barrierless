import 'dart:convert';

import 'package:barrierless/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

import 'package:barrierless/src/models/mensaje_model.dart';

class MensajesProvider {
  final String _url = 'https://barrierless-80e1d.firebaseio.com/';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearMensaje(MensajeModel mensaje) async {
    final url = '$_url/mensajes.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: mensajeModelToJson(mensaje));

    final decodedData = json.decode(resp.body);

    return true;
  }

  Future<bool> editarMensaje(MensajeModel mensaje) async {
    final url = '$_url/mensajes/${mensaje.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: mensajeModelToJson(mensaje));

    final decodedData = json.decode(resp.body);

    return true;
  }

  Future<List<MensajeModel>> cargarMensajes() async {
    final url = '$_url/mensajes.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<MensajeModel> mensajes = new List();

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, mensaje) {
      final mensajeTemp = MensajeModel.fromJson(mensaje);
      mensajeTemp.id = id;

      mensajes.add(mensajeTemp);
    });

    return mensajes;
  }

  Future<int> borrarMensaje(String id) async {
    final url = '$_url/mensajes/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);

    return 1;
  }
}
