import 'package:flutter/material.dart';
import 'package:qoway/model/usuario.dart';

import '../model/cuenta.dart';
import '../model/movimiento.dart';

class PrincipalProvider with ChangeNotifier{
  Cuenta _cuenta= Cuenta(idUsuario: 0,estaIncluido: 0,descripcion: 'Seleccione');
  Usuario _usuario=Usuario(correo: '',clave: '');
  int _radioSeleccionado=0;
  List<Map<String, Object?>> _movimientosPorCuenta=[];
  List<Map<String, Object?>> _ingresos=[];
  List<Map<String, Object?>> _egresos=[];
  
  double _total =0.0;
 //GETTERS
  Usuario get usuario => _usuario;
  Cuenta get cuentaGet => _cuenta;
  int get radioSeleccionado => _radioSeleccionado;
  List<Map<String, Object?>> get movimientosPorCuenta => _movimientosPorCuenta;
  List<Map<String, Object?>> get ingresos => _ingresos;
  List<Map<String, Object?>> get egresos => _egresos;
  get total => _total;
//SETTERS 
  set radioSeleccionado(seleccionado){
    _radioSeleccionado=seleccionado;
    notifyListeners();
  }
  set totalCero(double cero){
    _total=cero;
    notifyListeners();
  }
  set total(movimientos){ 
    print(movimientos);   
     _total=movimientos.fold(0.0, (anterior, actual) => anterior + ((actual['tipoMovimiento']==0)?(-1*actual['montoMovimiento']):actual['montoMovimiento']));
     print(_total);
     notifyListeners(); 
  }
  set usuario(Usuario usuario){
    _usuario=usuario;
    notifyListeners();
  }
  set movimientosPorCuenta(movimientos){
    _total=movimientos.fold(0.0, (anterior, actual) => anterior + ((actual['tipoMovimiento']==0)?(-1*actual['montoMovimiento']):actual['montoMovimiento']));
    _movimientosPorCuenta=movimientos;    
    notifyListeners();
  } 
  set ingresos(movimientos){
     _ingresos=movimientos;    
    notifyListeners();
  }

  set egresos(movimientos){
     _egresos=movimientos;    
    notifyListeners();
  }
  
  set cuentaSet(Cuenta cuenta){    
    _cuenta=cuenta;
    notifyListeners();
  }


  
}