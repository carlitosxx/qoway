import 'package:flutter/material.dart';
import 'package:qoway/pages/cuenta/cuenta.dart';
import 'package:qoway/pages/divisa/divisa.dart';
import 'package:qoway/pages/identificate/identificate.dart';
import 'package:qoway/pages/principal/principal.dart';
import '../pages/agregar_transaccion/agregar_transaccion.dart';
import '../pages/registro/registro.dart';

import '../pages/splash/splash.dart';

class RouteGenerator {
static Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments; 
  final args2 = settings.arguments;    
  switch (settings.name){
    case '/splash':
      return MaterialPageRoute(builder: (_)=> const SplashPage());   
    case '/registro':
      return MaterialPageRoute(builder: (_) => RegistroPage());
    case '/identificate':
      return MaterialPageRoute(builder: (_) => IdentificatePage());  
    case '/divisa':
      if (args is String) {
            return MaterialPageRoute(
                builder: (_) => DivisaPage(
                      idUsuario: args,
                    ));
          }
      return _errorRoute();      
    case '/principal':
     if (args is String) {
            return MaterialPageRoute(
                builder: (_) => Principal(
                      idUsuario: args,
                    ));
          }
      return _errorRoute();  
     case '/agregarIoE':    
        if(args is Map<String, dynamic> ){
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>  AgregarTransaccionPage(
              idCuentaYUsuario: args),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(                
                position: animation.drive(tween),
                child: child,
              );
            },
          );     
        }
        return _errorRoute();
      case '/cuenta':    
        if(args is int ){
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>  CuentaPage(
              idCuenta: args),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(                
                position: animation.drive(tween),
                child: child,
              );
            },
          );     
        }
        return _errorRoute();   
    default:
        return _errorRoute(); 
  }        
}

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Ups, ocurrio un error'),
        ),
      );
    });
  }
}