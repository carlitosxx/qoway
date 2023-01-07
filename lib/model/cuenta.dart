// import 'package:flutter/material.dart';
// import 'package:objectbox/objectbox.dart';
// import 'package:qoway/model/movimiento.dart';

// @Entity()
class Cuenta{
  int?    id;
  String descripcion;  
  int     estaIncluido;
  int     idUsuario;
  // Icon icono;  
  
  Cuenta({
    this.id,
    required this.descripcion,     
    required this.estaIncluido,     
    required this.idUsuario
  });
  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'descripcion':descripcion,
      'estaIncluido':estaIncluido, 
      'idUsuario':idUsuario
      };
  }
  factory Cuenta.fromMap( Map<String,dynamic> e)=>
     Cuenta(
      id:e['id'],
      descripcion:e['descripcion'],
      estaIncluido:e['estaIncluido'],
      idUsuario:e['idUsuario']
    );  
}
