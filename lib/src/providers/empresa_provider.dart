import 'dart:convert';
import 'dart:io';

import 'package:barrierless/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:mime_type/mime_type.dart';

import 'package:barrierless/src/models/empresa_model.dart';

class EmpresasProvider {
  final String _url = 'https://barrierless-80e1d.firebaseio.com/';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearEmpresa(EmpresaModel empresa) async {
    final url = '$_url/empresas.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: empresaModelToJson(empresa));

    final decodedData = json.decode(resp.body);

    return true;
  }

  Future<bool> editarEmpresa(EmpresaModel empresa) async {
    final url = '$_url/empresas/${empresa.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: empresaModelToJson(empresa));

    final decodedData = json.decode(resp.body);

    return true;
  }

  Future<List<EmpresaModel>> cargarEmpresas() async {
    final url = '$_url/empresas.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<EmpresaModel> empresas = new List();

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, empresa) {
      final empresaTemp = EmpresaModel.fromJson(empresa);
      empresaTemp.id = id;

      empresas.add(empresaTemp);
    });

    return empresas;
  }

  Future<int> borrarEmpresa(String id) async {
    final url = '$_url/empresas/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);

    return 1;
  }

  Future<String> subirLogo(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dqyl2yqs5/image/upload?upload_preset=hgodtri7');
    final mimeType = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }

    final respData = json.decode(resp.body);

    return respData['secure_url'];
  }
}
