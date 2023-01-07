// import 'package:objectbox/objectbox.dart';
// @Entity()
class Movimiento{
  int? id ;
  int tipoMovimiento;
  double monto;
  int fecha;
  String comentario;
  int? idCuenta;

  Movimiento({
    this.id,
    required this.tipoMovimiento,
    required this.monto,
    required this.fecha,
    required this.comentario,
    required this.idCuenta    
  });
  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'tipoMovimiento':tipoMovimiento,
      'monto':monto,
      'fecha':fecha, 
      'comentario':comentario, 
      'idCuenta':idCuenta     
      };
  }
}