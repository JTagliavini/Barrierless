import 'dart:io';

import 'package:barrierless/src/providers/empresa_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:barrierless/src/models/empresa_model.dart';

class EmpresasBloc {
  final _empresasController = new BehaviorSubject<List<EmpresaModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _empresasProvider = new EmpresasProvider();

  Stream<List<EmpresaModel>> get empresasStream => _empresasController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  void cargarEmpresas() async {
    final empresas = await _empresasProvider.cargarEmpresas();
    _empresasController.sink.add(empresas);
  }

  void agregarEmpresa(EmpresaModel empresa) async {
    _cargandoController.sink.add(true);
    await _empresasProvider.crearEmpresa(empresa);
    _cargandoController.sink.add(false);
  }

  void editarEmpresa(EmpresaModel empresa) async {
    _cargandoController.sink.add(true);
    await _empresasProvider.editarEmpresa(empresa);
    _cargandoController.sink.add(false);
  }

  void borrarEmpresa(String id) async {
    await _empresasProvider.borrarEmpresa(id);
  }

  Future<String> subirLogo(File foto) async {
    _cargandoController.sink.add(true);
    final fotoUrl = await _empresasProvider.subirLogo(foto);
    _cargandoController.sink.add(false);

    return fotoUrl;
  }

  dispose() {
    _empresasController?.close();
    _cargandoController?.close();
  }
}
