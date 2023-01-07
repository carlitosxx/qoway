import 'package:flutter/material.dart';
import 'package:qoway/pages/principal/principal.dart';

import '../../db/db.dart';
import '../identificate/identificate.dart';
class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      // Center(child: Text('hola'))
      FutureBuilder(
        future: Db.obtenerActividad(),
        builder: (context,snapshot) {
          if(snapshot.connectionState==ConnectionState.done){            
              List actividad = snapshot.data as List;
              // print(actividad);
              if (actividad[0]['id']==0){                
                return IdentificatePage();
              }else{               
                return Principal(idUsuario:actividad[0]['id'].toString());
              }
           
          }else if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child:  CircularProgressIndicator());
          }
           return const Text('error');
         
        }
      ),
    );
  }
}