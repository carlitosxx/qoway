import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qoway/helper/fecha_corta.dart';
import 'package:qoway/model/movimiento.dart';

import '../../../db/db.dart';
import '../../../provider/principal_provider.dart';
class IngresosScreen extends StatefulWidget {
  int idUsuario;
  IngresosScreen({Key? key,required this.idUsuario}) : super(key: key);
  @override
  State<IngresosScreen> createState() => _IngresosScreenState();
}

class _IngresosScreenState extends State<IngresosScreen> { 
  @override
  Widget build(BuildContext context) {
    final principalProvider = Provider.of<PrincipalProvider>(context);    
    return ListView.builder(
      itemCount: principalProvider.ingresos.length,
      itemBuilder:(context, i) {        
        int fechaInt =principalProvider.ingresos[i]['fecha'] as int;
        final fecha =DateTime.fromMillisecondsSinceEpoch(fechaInt, isUtc: false).toString();
        return GestureDetector(
          onLongPress:(){ 
            print(principalProvider.usuario.id);
            showDialog(              
              context: context,
               builder: ((context) {
                return AlertDialog(                  
                  title: const Text("¿Desea eliminarlo?"),
                  shape: const RoundedRectangleBorder(
                               borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  actions: [
                    ElevatedButton(                      
                      style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).backgroundColor
                          ),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        child: const Text('CANCELAR'),
                       ) ,
                     ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red.withOpacity(0.5),
                          ),
                          onPressed: ()async{                           
                            Movimiento movimiento =Movimiento(
                              id: principalProvider.ingresos[i]['idMovimiento'] as int,
                              comentario: principalProvider.ingresos[i]['comentarioMovimiento'] as String,
                              fecha: principalProvider.ingresos[i]['fecha'] as int,
                              idCuenta: principalProvider.ingresos[i]['idCuenta'] as int,
                              monto: principalProvider.ingresos[i]['montoMovimiento'] as double,
                              tipoMovimiento: principalProvider.ingresos[i]['tipoMovimiento'] as int,
                            );                          
                            Db.eliminarMovimiento(movimiento);
                            List<Map<String,Object?>> movimientosCuenta=await Db.obtenerMovimientosDeCuenta(
                            principalProvider.cuentaGet.id!,
                            principalProvider.usuario.id!);
                            principalProvider.movimientosPorCuenta=movimientosCuenta;
                            // principalProvider.total= movimientosCuenta;
                            principalProvider.ingresos=(movimientosCuenta.where((item){
                                                      return item['idCuenta']==principalProvider.cuentaGet.id && item['tipoMovimiento']==1;
                                                    })).toList();   
                // ),
                // principalProvider.usuario.id!); 
                            Navigator.of(context).pop();        
                          },
                        child: const Text('ELIMINAR'),
                       )  
                  ],
                  content:Column( 
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Descripcion:',style: TextStyle(fontWeight: FontWeight.bold),)),
                      const SizedBox(height: 10,),
                      Text(principalProvider.ingresos[i]['comentarioMovimiento'].toString()),
                      const SizedBox(height: 10,),  
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Monto:',style: TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(height: 10,),  
                      Text(principalProvider.ingresos[i]['montoMovimiento'].toString()),  
                    ],
                  )
                ); 
               })
            );
          } ,
          child: Container(
            padding: const EdgeInsets.only(right:10.0,left:10,top:10,bottom: 10),
            margin: const EdgeInsets.only(right:10.0,left:10,top:10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex:70,
                  child: Row(
                    children: [
                      Flexible(
                        flex:10,
                        child: Column(
                          children: [
                            Text(fechaCorta(int.parse(fecha.substring(5,7))),style: const TextStyle(fontSize: 11),),
                            Container(
                              padding: const EdgeInsets.fromLTRB(3, 2, 3, 2),                           
                              decoration: BoxDecoration(
                                 color: Colors.white.withOpacity(0.6),
                                 borderRadius: BorderRadius.circular(3)
                              ),
                              child: Text(fecha.substring(8,10),
                              style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontSize: 11),),
                            ),
                          ],
                        )
                      ),
                      const SizedBox(width: 7,),
                      Flexible(
                        flex:90,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [                         
                            Text("${principalProvider.ingresos[i]['comentarioMovimiento']}",
                            style: const TextStyle(color:Colors.grey),overflow: TextOverflow.fade)
                          ],
                        )),
                    ],
                  ),
                ),
                Flexible(
                  flex:30,
                  child: RichText(
                    text:TextSpan(
                      text:(principalProvider.ingresos[i]['tipoMovimiento']==1)?"":"-",
                      children: [
                        TextSpan(text:"${principalProvider.ingresos[i]['simboloDivisa']}"),
                        TextSpan(text: "${principalProvider.ingresos[i]['montoMovimiento']}")
                      ]
                    )
                  ),
                ),
                // Text(),
              ],
            ),
          ),
        );
      },     
    );
  }
}