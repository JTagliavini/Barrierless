// To parse this JSON data, do
//
//     final empresaModel = empresaModelFromJson(jsonString);

import 'dart:convert';

EmpresaModel empresaModelFromJson(String str) =>
    EmpresaModel.fromJson(json.decode(str));

String empresaModelToJson(EmpresaModel data) => json.encode(data.toJson());

class EmpresaModel {
  String id;
  String nombre;
  String pais;
  String ciudad;
  String industria;
  String mail;
  String telefono;
  String logoUrl;
  bool importador;
  bool exportador;

  EmpresaModel(
      {this.id,
      this.nombre,
      this.pais,
      this.ciudad,
      this.industria,
      this.mail,
      this.telefono,
      this.logoUrl,
      this.importador,
      this.exportador});

  factory EmpresaModel.fromJson(Map<String, dynamic> json) => new EmpresaModel(
      id: json["id"],
      nombre: json["nombre"],
      pais: json["pais"],
      ciudad: json["ciudad"],
      industria: json["industria"],
      mail: json["mail"],
      telefono: json["telefono"],
      logoUrl: json["logoUrl"],
      importador: json["importador"],
      exportador: json["exportador"]);

  Map<String, dynamic> toJson() => {
        //"Id": id,
        "nombre": nombre,
        "pais": pais,
        "ciudad": ciudad,
        "industria": industria,
        "mail": mail,
        "telefono": telefono,
        "logoUrl": logoUrl,
        "importador": importador,
        "exportador": exportador
      };
}
