import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:sqflite/sqflite.dart';
import '../../db/db.dart';
import '../../model/cuenta.dart';
import '../../provider/validaciones.dart';
class CuentaPage extends StatefulWidget {
  final int idCuenta;
  const CuentaPage({Key? key,required this.idCuenta}) : super(key: key);

  @override
  State<CuentaPage> createState() => _CuentaPageState();
}

class _CuentaPageState extends State<CuentaPage> {
  final controllerDescripcion =TextEditingController();
  final controllerDescripcionModificado =TextEditingController();
   FocusNode focusDescripcion = FocusNode();
   String hintDescripcion = 'Descripción de cuenta';
   FocusNode focusDescripcionModificado = FocusNode();
   String hintDescripcionModificado = 'Descripción de cuenta';
   List<Cuenta> cuenta=[];
  @override
  void initState() {
    super.initState();
     focusDescripcion.addListener(() {
      if (focusDescripcion.hasFocus) {
        hintDescripcion = '';
      } else {
        hintDescripcion = 'Descripción de cuenta';
      }      
      setState(() {});
    });
    focusDescripcionModificado.addListener(() {
      if (focusDescripcionModificado.hasFocus) {
        hintDescripcionModificado = '';
      } else {
        hintDescripcionModificado = 'Descripción de cuenta';
      }      
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {  
    final servicioValidacion = Provider.of<Validaciones>(context);  
    return WillPopScope(
       onWillPop: ()async=>false,
      child: Container(
        color:Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Scaffold(  
            extendBody: true,   
            body: Column(              
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('Agregar Cuenta',style: TextStyle(
                        fontSize: 22,              
                        shadows:[
                          Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 1.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),            
                        ], 
                      ),
                    ),
                    ),
                    Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                          child: Container(                      
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(45),
                            ),                      
                            child: IconButton(    
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              icon:  const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      margin:  const EdgeInsets.fromLTRB(50, 10, 50, 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(.1),
                      ),  
                  child: TextField(
                     onChanged: (String value) {                              
                                servicioValidacion.cambioCuentaDescripcion(value);
                              },
                    maxLength: 25,
                    keyboardType: TextInputType.text,                     
                    focusNode: focusDescripcion,
                    controller: controllerDescripcion,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: hintDescripcion,                        
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3)
                        )
                      ),
                  ),
                ),
// LISTA DE CUENTA                
                Expanded(
                  child: FutureBuilder(
                    future: Db.obtenerCuentas(widget.idCuenta),
                    builder: (context,snapshot) {                      
                      if (snapshot.hasData){
                        cuenta = (snapshot.data as List).map((e) {
                          return Cuenta(
                            id: e['id'],
                            descripcion: e['descripcion'],
                            estaIncluido: e['estaIncluido'],
                            idUsuario: e['idUsuario']);}
                        ).toList();                                                
                        return ListView.builder(                        
                          itemCount: cuenta.length,
                          itemBuilder:(context, index) {
                            return GestureDetector(
                              onLongPress:(){
                                //VALIDAR SI ES ULTIMA CUENTA
                                if (cuenta.length ==1){                                  
                                  final snackBar = SnackBar(
                                  content: const Text('Imposible eliminar la ultima cuenta'),            
                                  backgroundColor: Colors.white54,
                                  action: SnackBarAction(
                                    textColor: Colors.black,
                                    label: 'Cerrar', onPressed: (){}),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  return;
                                }            
                                showDialog(              
                                  context: context,
                                  builder: (context) {
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
                                                try {
                                                  Cuenta cuentaEliminar =Cuenta(
                                                  id: cuenta[index].id,
                                                  descripcion: cuenta[index].descripcion,
                                                  estaIncluido: cuenta[index].estaIncluido,
                                                  idUsuario: cuenta[index].idUsuario,
                                                  );                          
                                                  await Db.eliminarCuenta(cuentaEliminar);
                                                  cuenta.removeWhere((element) => element.id == cuentaEliminar.id);   
                                                  if (!mounted) return;                                         
                                                  Navigator.of(context).pop();
                                                  setState(() {
                                                    
                                                  }); 
                                                } catch (e) {
                                                  print(e);
                                                }                        
                                                       
                                              },
                                            child: const Text('ELIMINAR'),
                                          )  
                                      ],
                                      content:Column( 
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Se eliminara la cuenta y todos los ingresos y egresos'),
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Descripcion:',style: TextStyle(fontWeight: FontWeight.bold),)),
                                          const SizedBox(height: 10,),
                                          Text(cuenta[index].descripcion),                      
                                        ],
                                      )
                                    ); 
                                  }
                                );
                              } ,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(cuenta[index].descripcion),
                                    GestureDetector(
                                      onTap: ()async{
//TODO: EDITAR CUENTA
                                        showDialog(              
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Modificar cuenta"),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                                            ),                                            
                                            actions: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children:[
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
                                                  primary: const Color.fromARGB(255, 59, 152, 22)
                                                ),
                                                child: const Text('MODIFICAR'),
                                                onPressed:()async{
                                                  if(controllerDescripcionModificado.text.trim()==''){
                                                    
                                                    return;
                                                  }
                                                  Cuenta cuenaModificada= Cuenta(
                                                    descripcion:controllerDescripcionModificado.text,
                                                    estaIncluido: cuenta[index].estaIncluido,
                                                    idUsuario:cuenta[index].idUsuario,
                                                    id: cuenta[index].id,
                                                    );
                                                   await Db.editarCuenta(cuenaModificada);
                                                   if (!mounted) return;
                                                   controllerDescripcionModificado.text='';
                                                   Navigator.of(context).pop();
                                                },
                                              )                                            
                                              ])
                                            ],
                                            content: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                  margin:  const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.white.withOpacity(.1),
                                                  ),  
                                              child: TextField(                   
                                                maxLength: 25,
                                                keyboardType: TextInputType.text,                     
                                                focusNode: focusDescripcionModificado,
                                                controller: controllerDescripcionModificado,
                                                style: const TextStyle(color: Colors.white, fontSize: 20),
                                                  decoration: InputDecoration(
                                                    counterText: '',
                                                    border: InputBorder.none,
                                                    hintText: hintDescripcionModificado,                        
                                                    hintStyle: TextStyle(
                                                        color: Colors.white.withOpacity(0.3)
                                                    )
                                                  ),
                                              ),
                                            ),
                                          ) ;
                                        }
                                        );       
                                      },
                                      child: const Icon(Icons.edit))
                                  ]
                                  )
                              ),
                            );
                          },                
                        );
                      } 
                      return const CircularProgressIndicator(); 
                    }
                  ),
                )     
              ],
            ),
// BOTON GUARDAR                        
            bottomNavigationBar: GestureDetector(
              onTap: (servicioValidacion.esValidoCuentaDescripcion)?()async{                 
                try {
                  if ( controllerDescripcion.text.trim()=='') {
                    final snackBar = SnackBar(
                    content: const Text('Ingrese una descripcion valida'),            
                    backgroundColor: Colors.white54,
                    action: SnackBarAction(
                      textColor: Colors.black,
                      label: 'Cerrar', onPressed: (){}),
                    );
                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                     return;
                  }                 
                  Cuenta cuentaNueva = Cuenta(
                    descripcion: (controllerDescripcion.text).trim(),
                    estaIncluido: 1,
                    idUsuario: widget.idCuenta,
                  );
                  cuenta=[...cuenta,cuentaNueva];
                  int resultado=await Db.agregarCuenta(cuentaNueva);
                  if (resultado==0){
                    final snackBar = SnackBar(
                    content: const Text('Ya existe la cuenta'),            
                    backgroundColor: Colors.white54,
                    action: SnackBarAction(
                      textColor: Colors.black,
                      label: 'Cerrar', onPressed: (){}),
                    );
                    if (!mounted) return;
                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }else{
                    controllerDescripcion.clear();
                    servicioValidacion.cambioCuentaDescripcion('');
                  }
                } catch (e) {
                  print(e);
                }
                 
              }:null,
              child: Container(          
              margin: const EdgeInsets.only(bottom: 5),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(25)
              ),
              child: Center(
                child: Text('Guardar ',style:
                  TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color:(servicioValidacion.esValidoCuentaDescripcion)
                      ?null
                      :Theme.of(context).backgroundColor))),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}