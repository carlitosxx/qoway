class Usuario{
  int? id;
  String? nombre;
  String correo;
  String clave;
  String? descDivisa;
  String? cortoDivisa;
  String? simboloDivisa;
  int? ladoDivisa;
  // CONSTRUCTOR
  Usuario({
      this.id,
      this.nombre,
      required this.correo,
      required this.clave,
      this.descDivisa,
      this.cortoDivisa,
      this.simboloDivisa,
      this.ladoDivisa,      
      // required this.cuentas
  });

  // METODOS
  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'nombre':nombre,
      'correo':correo, 
      'clave':clave, 
      'descDivisa':descDivisa, 
      'cortoDivisa':cortoDivisa,
      'simboloDivisa':simboloDivisa,
      'ladoDivisa':ladoDivisa,};
  }


}