// To parse this JSON data, do
//
//     final mensajeModel = mensajeModelFromJson(jsonString);

import 'dart:convert';

MensajeModel mensajeModelFromJson(String str) =>
    MensajeModel.fromJson(json.decode(str));

String mensajeModelToJson(MensajeModel data) => json.encode(data.toJson());

class MensajeModel {
  String id;
  String remitente;
  String destinatario;
  String mensaje;
  String timestamp;

  MensajeModel(
      {this.id,
      this.remitente,
      this.destinatario,
      this.mensaje,
      this.timestamp});

  factory MensajeModel.fromJson(Map<String, dynamic> json) => new MensajeModel(
      id: json["id"],
      remitente: json["remitente"],
      destinatario: json["destinatario"],
      mensaje: json["mensaje"],
      timestamp: json["timestamp"]);

  Map<String, dynamic> toJson() => {
        //"Id": id,
        "remitente": remitente,
        "destinatario": destinatario,
        "mensaje": mensaje,
        "timestamp": timestamp
      };
}
