
import 'package:flutter/material.dart';
class ValidationItem {
  final String value;
  final String error;
  ValidationItem(this.value, this.error);
}

class Validaciones with ChangeNotifier{
  //Variables de validacion
    //INDENTIFICACION Y REGISTRO
  ValidationItem _correo = ValidationItem('','');
  ValidationItem _clave = ValidationItem('','');
  ValidationItem _reClave = ValidationItem('','');
  bool _cuentaValida=false;
  ValidationItem _cuentaDescripcion = ValidationItem('','');
  //Getters
  ValidationItem get correo => _correo;
  ValidationItem get clave => _clave;  
  ValidationItem get reClave => _reClave;
  ValidationItem get cuentaDescripcion => _cuentaDescripcion;
  bool get cuentaValida => _cuentaValida;
  //Setters
  set cuentaValida (bool value){
    _cuentaValida=value;
    notifyListeners();
  }

  bool get esValidoCorreo{
    return (_correo.value != '' && RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_correo.value) ) ?  true : false; 
  }
  bool get esValidoClave{
    return (_clave.value !='' && _clave.value.length >6 && _clave.value.length< 14)?true:false;
  }
  bool get esValidoReClave{
    return (_reClave.value==_clave.value)?true:false;
  }
  bool get esValidoCuentaDescripcion{
      return (_cuentaDescripcion.value.length >=3 && _cuentaDescripcion.value.length<= 25);
  }

  cambioCorreo(String value) { 
    final validador=RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    try {
    if(value!=""){                   
      if (value.length > 9 &&
          value.length < 50 &&
          validador== true) {
          _correo = ValidationItem(value, '');
      } else {
        _correo = ValidationItem('', 'Ingrese un correo valido');
      }
    } 
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
  cambioClave(String value){
    try {
      if (value !='' && value.length >6 && value.length< 14 && value.contains(' ') == false){
        _clave=ValidationItem(value, '');
      }else {
        _clave = ValidationItem('', 'mas de 6 y menos de 14 caracteres');
      }
    } catch (e) {
      print('e');
    }
    notifyListeners();
  }
  cambioReClave(String value){
    try {
      if (value==_clave.value){
        _reClave=ValidationItem(value, '');
      }else {
        _reClave = ValidationItem('', 'Las claves deben ser igual');
      }
    } catch (e) {
      print('e');
    }
    notifyListeners();
  }
  cambioCuentaDescripcion(String value){
    try {
      if (value.length >=3 && value.length<= 25 ){
        _cuentaDescripcion=ValidationItem(value, '');
      }else {
        _cuentaDescripcion = ValidationItem('', 'Debe ser de 3 a 25 caracteres');
      }
    } catch (e) {
      print('e');
    }
    notifyListeners();
  }

}