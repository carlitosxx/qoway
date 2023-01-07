// import 'package:objectbox/objectbox.dart';

// @Entity()
class Divisa{
  int? id;
  String descDivisa;
  String cortoDivisa;
  String simboloDivisa;
  int ladoDivisa;  
  Divisa({
     this.id,
      required this.descDivisa,      
      required this.cortoDivisa,
      required this.simboloDivisa,
      required this.ladoDivisa,      
  });
}