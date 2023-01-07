import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../db/db.dart';
import '../../../model/cuenta.dart';
import '../../../model/usuario.dart';
import '../../../provider/principal_provider.dart';
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  int idUsuario;

  MyAppBar({Key? key,required this.idUsuario}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
  
  @override  
  Size get preferredSize => const Size.fromHeight(kToolbarHeight)*1.5;
}

class _MyAppBarState extends State<MyAppBar> {
  //Variables
  Usuario usuario=Usuario(clave: '',correo: 'nuevo');
  List<Map<String, Object?>> listaMovimientos=[];
  List<Cuenta> listaCuenta=[];
  int selectedValue=1;

  cargarUsuario(id)async{
  var usuarioEnLista= await Db.obtenerUsuarioPorId(widget.idUsuario);  
  return usuario=Usuario(
    id:usuarioEnLista[0]['id'] as int,
    correo: usuarioEnLista[0]['correo'].toString(),
    clave:usuarioEnLista[0]['clave'].toString(),
    descDivisa: usuarioEnLista[0]['descDivisa'].toString(),
    cortoDivisa: usuarioEnLista[0]['cortoDivisa'].toString(),
    simboloDivisa: usuarioEnLista[0]['simboloDivisa'].toString(),
    ladoDivisa: usuarioEnLista[0]['ladoDivisa'] as int,
    nombre: usuarioEnLista[0]['nombre'].toString()    
  );
  }

  cargarMovimientos(id)async{
   listaMovimientos= await Db.obtenerMovimientos(id);   
  }
 
  @override
  Widget build(BuildContext context) {    
    final principalProvider = Provider.of<PrincipalProvider>(context);
    return ClipRRect(
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight:Radius.circular(50) ),
      child: BackdropFilter(
        filter:  ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Container(
          width: double.infinity,          
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            // color:Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight:Radius.circular(50) )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
// APPBAR PRIMERA FILA              
              Expanded(
                flex: 1,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                              onTap: (){
                                 Scaffold.of(context).openDrawer();
                              },
                              child: const SizedBox(                              
                                width: 50,
                                child:  Icon(Icons.menu),
                              ),
                            ),
                      InkWell(                        
                        onTap: ()async {
                          principalProvider.usuario=usuario ;
                          await showDialog(                      
                            context: context,
                            builder: (context) { 
                              return AlertDialog(
                                title: const Text("Selecciona una cuenta"),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                                  ),
                                actions:[
                                  ElevatedButton(
                                    onPressed: () async{
                                      //listaMovimientos ES CARGADO
                                      await cargarMovimientos(widget.idUsuario);
                                      //LA CUENTA SELECCIONADA SE METE AL PROVIDER CUENTASET
                                      principalProvider.cuentaSet=listaCuenta[principalProvider.radioSeleccionado];                                  
                                      //FILTRA LOS MOVIMIENTOS QUE TENGA EL ID DE LA CUENTA ESTO PARA CALCULAR EL TOTAL      
                                      principalProvider.movimientosPorCuenta=(listaMovimientos.where((item){
                                          return item['idCuenta']==listaCuenta[principalProvider.radioSeleccionado].id;
                                        })).toList();
                                      //CARGAR INGRESOS
                                      principalProvider.ingresos=(listaMovimientos.where((item){
                                          return item['idCuenta']==listaCuenta[principalProvider.radioSeleccionado].id && item['tipoMovimiento']==1;
                                        })).toList();
                                      // print(principalProvider.ingresos) ; 
                                      //CARGAR EGRESOS
                                       principalProvider.egresos=(listaMovimientos.where((item){
                                          return item['idCuenta']==listaCuenta[principalProvider.radioSeleccionado].id && item['tipoMovimiento']==0;
                                        })).toList();

                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Seleccionar"),
                                  ),
                                ],
                                content:FutureBuilder(
                                      future:Db.obtenerCuentas(widget.idUsuario),
                                      builder: (context,snapshot) {
                                        if(snapshot.connectionState==ConnectionState.done){                                         
                                            final data=snapshot.data as List;
                                            listaCuenta= data.map((val)=> 
                                            Cuenta(
                                              descripcion: val['descripcion'],
                                              estaIncluido: val['estaIncluido'],
                                              idUsuario: val['idUsuario'],
                                              id: val['id'])
                                          ).toList();  
                                            return SizedBox(                               
                                                    width: double.maxFinite,
                                                    child: StatefulBuilder(
                                                      builder: (context,setState) {
                                                        return ListView.builder(     
                                                          shrinkWrap: true,                    
                                                          itemCount: listaCuenta.length,
                                                          itemBuilder: (contxt,i){
                                                            return 
                                                            RadioListTile<int>(
                                                              title: Text(listaCuenta[i].descripcion),
                                                              subtitle: Text(listaCuenta[i].estaIncluido==1
                                                              ?'Esta incluido en el Total'
                                                              :'no esta incluido en el Total'),
                                                              value: i,
                                                              groupValue: principalProvider.radioSeleccionado, 
                                                              onChanged: (seleccionado){
                                                                principalProvider.radioSeleccionado=seleccionado;
                                                                // print("seleccionado $seleccionado");
                                                                // // print("selectValue $selectedValue");
                                                                // print("principalProvider.radioSeleccionado ${principalProvider.radioSeleccionado}");
                                                               
                                                                setState(() {                                                          
                                                                });
                                                              }
                                                            );
                                                          }
                                                        );
                                                      }
                                                    ),
                                                  );
                                        }
                                        return const CircularProgressIndicator();
                                      }
                                    )
                                

                              );
                            }
                          );
                        },
                        child: Row(
                          children: [
                            Text("   ${principalProvider.cuentaGet.descripcion}"),
                            const Icon(Icons.arrow_drop_down)
                          ],
                        )
                      ),
                      const SizedBox(                              
                              width: 50,                              // child:  Icon(Icons.menu),
                      ),
                    ],
                  )
                )),
// APPBAR SEGUNDA FILA              
              Expanded(
                flex:1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(                        
                      future: cargarUsuario(widget.idUsuario),
                      builder:((context, snapshot) {
                        if(snapshot.hasData){
                          final data=snapshot.data as Usuario;
                          usuario=data;             
                          return Text(data.simboloDivisa!);
                        }
                        return const Text('_');
                      }),
                    ),
                                         
                    Text(principalProvider.total.toStringAsFixed(2).toString(),style:const TextStyle(fontSize: 35),overflow:TextOverflow.clip ,)
                  ],
                ))
            ],
          ), 
        ),
      ),
    );
  }
}

