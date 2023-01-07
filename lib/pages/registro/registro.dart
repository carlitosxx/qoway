import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../db/db.dart';
import '../../model/cuenta.dart';
import '../../model/usuario.dart';
import '../../provider/validaciones.dart';
class RegistroPage extends StatefulWidget {
  RegistroPage({Key? key}) : super(key: key);

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final correo = TextEditingController();
  final clave = TextEditingController();
  final reclave = TextEditingController();

  FocusNode focusCorreo = FocusNode();
  FocusNode focusClave = FocusNode();
  FocusNode focusReClave = FocusNode();
  String hintCorreo = 'Ingrese su correo';
  String hintClave = 'Ingrese su clave';
  String hintReClave='Confirme su clave';
  List<Usuario> usuarios=[];
  
  cargarUsuarios()async{
    List<Usuario> listaUsuarios=await Db.usuarios();
    setState(() {
      usuarios = listaUsuarios;
    });
  }

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
    focusCorreo.addListener(() {
      if (focusCorreo.hasFocus) {
        hintCorreo = '';
      } else {
        hintCorreo = 'Ingrese su correo';
      }      
      setState(() {});
    });
    focusClave.addListener(() {
      if (focusClave.hasFocus){
        hintClave='';
      }else{
        hintClave = 'Ingrese su clave';
      }
      setState(() {});
    });
    focusReClave.addListener(() {
      if (focusReClave.hasFocus) {
        hintReClave = '';
      } else {
        hintReClave = 'Confirme su clave';
      }      
      setState(() {});
    });
    
  }
  @override
  Widget build(BuildContext context) {
   const String logo = 'assets/svgs/logotipo.svg';   
   final servicioValidacion = Provider.of<Validaciones>(context);  
    return WillPopScope(
      onWillPop: ()async=>false,
      child: Container(
        color:Theme.of(context).primaryColor,
        child: SafeArea(
          child: Scaffold(     
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            //   title: const Text("Registro"),
            //   actions: [
            //     IconButton(onPressed: (){
            //     Db.deleteAllUsuario();
                
            //     // cargarUsuarios();
            //     }, icon: const Icon(Icons.delete,color: Color(0xFFC72129),)),
            //     IconButton(onPressed: ()async{
            //       await cargarUsuarios();        
            //       showDialog(
            //                 context: context,
            //                 builder: (ctx) => AlertDialog(
            //                   title: const Text("Pruebas"),
            //                   content: 
            //                   Container(
            //                     color:Colors.red,
            //                     // height: 500,
            //                     width: double.maxFinite,
            //                     child: ListView.builder(     
            //                       // shrinkWrap: true,                    
            //                       itemCount: usuarios.length,
            //                       itemBuilder: (contxt,i){
            //                         return Row(
            //                           children: [
            //                             Text("${usuarios[i].correo.toString()} "),
            //                             Text("${usuarios[i].descDivisa} "),
            //                           ],
            //                         );                              
            //                       }
            //                     ),
            //                   ),
            //                   actions: <Widget>[
            //                     ElevatedButton(
            //                       onPressed: () {
            //                         Navigator.of(ctx).pop();
            //                       },
            //                       child: const Text("cerrar"),
            //                     ),
            //                   ],
            //                 ),
            //               );
            //     },icon:const Icon(Icons.list,)),
            //   ],
            // ),
//CUERPO================================================================ 
            
            body: CustomScrollView(
          physics:  const ClampingScrollPhysics(),
            // shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      padding:  EdgeInsets.only(top:const Size.fromHeight(kToolbarHeight).height,bottom: 0),                
                      child: Center(
                            child: SvgPicture.asset(
                                        logo,
                                        // width: 250,
                                        height: 150,                             
                                      ),
                          ),
                    ),
                    
                   const Padding(
                      padding:  EdgeInsets.fromLTRB(0,20,0,20),
                      child: Text(
                        'REGISTRATE',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          ), 
                      ),
                    ),
          //CORREO             
                    Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            margin:  const EdgeInsets.fromLTRB(50, 0, 50, 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(.2),
                            ),    
                            child: TextField(
                              onChanged: (String value) {                              
                                servicioValidacion.cambioCorreo(value);
                              },
                              focusNode: focusCorreo,
                              controller: correo,
                              maxLength: 50,
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 20),
                              decoration: InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  hintText: hintCorreo,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.3)
                                  )
                              ),
                            ),
                      ),
                    Visibility(
                        visible: (servicioValidacion.correo.error=='')?false:true,
                        child: Text(
                                  servicioValidacion.correo.error,
                                  style: const TextStyle(color: Colors.white38),
                                ),
                      ),
          //CLAVE              
                    Container(
                        padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        margin: const EdgeInsets.fromLTRB(50, 7, 50, 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(.2),
                        ),    
                        child: TextField(
                          onChanged: (String value) {                              
                            servicioValidacion.cambioClave(value);
                          },
                          focusNode: focusClave,
                          controller: clave,
                          maxLength: 13,
                          keyboardType: TextInputType.visiblePassword,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                          decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              hintText: hintClave,
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3)
                              )
                          ),
                        ),
                      ),
                    Visibility(
                        visible: (servicioValidacion.clave.error=='')?false:true,
                        child: Text(
                                  servicioValidacion.clave.error,
                                  style: const TextStyle(color: Colors.white38),
                                ),
                      ),
          //RECLAVE              
                    Container(
                        padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        margin: const EdgeInsets.fromLTRB(50, 7, 50, 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(.2),
                        ),    
                        child: TextField(
                          onChanged: (String value) {                              
                            servicioValidacion.cambioReClave(value);
                          },
                          focusNode: focusReClave,
                          controller: reclave,
                          maxLength: 13,
                          keyboardType: TextInputType.visiblePassword,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                          decoration: InputDecoration(                        
                              counterText: '',
                              border: InputBorder.none,
                              hintText: hintReClave,
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.3)
                              )
                          ),
                        ),
                      ),
                    Visibility(
                        visible: (servicioValidacion.reClave.error=='')?false:true,
                        child: Text(
                                  servicioValidacion.reClave.error,
                                  style: const TextStyle(color: Colors.white38),
                                ),
                      ),
            // BOTON SIGUIENTE
                    Container(
                        padding: const EdgeInsets.fromLTRB(50, 7, 50, 0),
                              width: double.infinity,                              
                              child: ElevatedButton(
                                style: TextButton.styleFrom(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 15),
                                    elevation: 0,
                                    shadowColor:
                                        Colors.green.withOpacity(0.1),
                                    backgroundColor: Colors.black26,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))
                                ),
                                onPressed: (servicioValidacion.esValidoCorreo && servicioValidacion.esValidoClave && servicioValidacion.esValidoReClave)?() async{
                                  if (correo.text.trim()=='' || clave.text.trim()=='' || reclave.text.trim()==''){
                                     final snackBar = SnackBar(
                                    content: const Text('los campos estan vacios'),            
                                    backgroundColor: Colors.white54,
                                    action: SnackBarAction(
                                      textColor: Colors.black,
                                      label: 'Cerrar', onPressed: (){}),
                                    );
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    return;
                                  }
                                  Usuario usuario=Usuario(correo:correo.text,clave:clave.text);           
                                  int idUsuario=await Db.insertUsuario(usuario);
                                  if(idUsuario==0){
                                    final snackBar = SnackBar(
                                    content: const Text('El correo ya existe'),            
                                    backgroundColor: Colors.white54,
                                    action: SnackBarAction(
                                      textColor: Colors.black,
                                      label: 'Cerrar', onPressed: (){}),
                                    );
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    return;
                                  }
                                  Cuenta cuenta = Cuenta(descripcion: 'Principal',estaIncluido: 1,idUsuario: idUsuario);
                                  final idCuenta=await Db.agregarCuenta(cuenta); 
                                  if(idCuenta==0){
                                    print('la cuenta ya existe');
                                    return;
                                  }  
                                  if (!mounted) return;                               
                                  servicioValidacion.cambioCorreo('');
                                   Navigator.of(context)
                                        .pushReplacementNamed('/divisa',arguments: idUsuario.toString());  
                                }:null,
                                child:  const Text(
                                  'Siguiente',
                                  style: TextStyle(fontSize: 20),
                                )                                
                              ),
                    ),                
                    Row( 
                      mainAxisAlignment: MainAxisAlignment.center,               
                      children: [
                        const Text("¿Ya tienes una cuenta?."),
                        TextButton(onPressed: (){
                          Navigator.of(context)
                            .pushReplacementNamed('/identificate');
                        }, child: const Text('Identificate'))  
                      ],
                    ),
                    
                  ],
                ),
              ),
              // const SliverToBoxAdapter(
              //   child: 
              // )
            ],
            
            ),
            
          ),
        ),
      ),
    );
  }
}

