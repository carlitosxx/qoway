import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../db/db.dart';
import '../../model/usuario.dart';
import '../../provider/validaciones.dart';

class IdentificatePage extends StatefulWidget {
  const IdentificatePage({Key? key}) : super(key: key);

  @override
  State<IdentificatePage> createState() => _IdentificatePageState();
}

class _IdentificatePageState extends State<IdentificatePage> {
  final correo = TextEditingController();
  final clave = TextEditingController();
  bool esCuentaValida =false;
  FocusNode focusCorreo = FocusNode();
  FocusNode focusClave = FocusNode();
   String hintCorreo = 'Ingrese su correo';
  String hintClave = 'Ingrese su clave';
@override
void initState() {
  super.initState();
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
}

  @override
  Widget build(BuildContext context) {
    final servicioValidacion = Provider.of<Validaciones>(context); 
    const String logo = 'assets/svgs/logotipo.svg';  
    return WillPopScope(
      onWillPop: ()async=>false,
      child: Container(
        color:Theme.of(context).primaryColor,
        child: SafeArea(
          child: Scaffold(        
            body: CustomScrollView(
              physics:  const ClampingScrollPhysics(),
              slivers: [SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top:const Size.fromHeight(kToolbarHeight).height,bottom: 0),                
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
                        'IDENTIFICATE',
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
//CLAVE                    
                    Container(
                      padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      margin: const EdgeInsets.fromLTRB(50, 7, 50, 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(.2),
                      ),    
                      child: TextField(                          
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
                            visible: servicioValidacion.cuentaValida,
                            child: const Text("Correo o clave incorrecta"
                                      // servicioValidacion.clave.error
                                      ,style: TextStyle(color: Colors.white38),
                                    ),
                    ),
//BOTON IDENTIFICAR                    
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
                                                BorderRadius.circular(10))),
                                    onPressed: ()async{
                                     Usuario usuario=Usuario(correo:correo.text,clave:clave.text);           
                                     List<Map<String, Object?>> resultado=  await Db.obtenerUsuario(usuario); 
                                     if (resultado.isEmpty){
                                      servicioValidacion.cuentaValida=true;  
                                     }else{
                                      servicioValidacion.cuentaValida=false; 
                                      await Db.actualizarActividad(resultado[0]['id'] as int) ;
                                      if (!mounted) return;                                  
                                       await Navigator.of(context)
                                        .pushReplacementNamed('/principal',arguments:resultado[0]['id'].toString());  
                                                                             
                                     }                                        
                                    },
                                    child:  const Text(
                                      'Identificar',
                                      style: TextStyle(fontSize: 20),
                                    )                                
                                  ),
                    ),
                    Row( 
                          mainAxisAlignment: MainAxisAlignment.center,               
                          children: [
                            const Text("¿No tienes una cuenta?."),
                            TextButton(onPressed: (){
                              Navigator.of(context)
                                .pushReplacementNamed('/registro');
                            }, child: const Text('Registrate'))  
                          ],
                        ),      
        
                  ],
                ),
              ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}