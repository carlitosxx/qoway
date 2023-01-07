import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:qoway/pages/principal/screens/egresos.dart';
import 'package:qoway/pages/principal/screens/ingresos.dart';
import 'package:qoway/pages/principal/widgets/myappbar.dart';
import '../../db/db.dart';
import '../../model/cuenta.dart';
import '../../model/usuario.dart';
import '../../provider/principal_provider.dart';
class Principal extends StatefulWidget {
  String idUsuario;
  Principal({Key? key,required this.idUsuario}) : super(key: key);
  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int screnIndex = 0;  
  List screens = [];
  int tipoTransaccion=1;
  int selectedValue=0;
  List<Map<String, Object?>> listaMovimientos=[];
  Usuario usuario=Usuario(clave: '',correo: 'nuevo');
  cargarMovimientos(id)async{
   listaMovimientos= await Db.obtenerMovimientos(int.parse(id));   
  }
  cargarUsuario(id)async{
    var usuarioEnLista= await Db.obtenerUsuarioPorId(int.parse(id));  
    return usuario=Usuario(
      id: usuarioEnLista[0]['id'] as int,
      correo: usuarioEnLista[0]['correo'].toString(),
      clave:usuarioEnLista[0]['clave'].toString(),
      descDivisa: usuarioEnLista[0]['descDivisa'].toString(),
      cortoDivisa: usuarioEnLista[0]['cortoDivisa'].toString(),
      simboloDivisa: usuarioEnLista[0]['simboloDivisa'].toString(),
      ladoDivisa: usuarioEnLista[0]['ladoDivisa'] as int,
      nombre: usuarioEnLista[0]['nombre'].toString()    
    );
  }
 
  @override
  void initState() {    
    super.initState();
      // idUsuario=int.parse(widget.idUsuario);
     WidgetsBinding.instance.addPostFrameCallback((_){
     cargarMovimientos(widget.idUsuario);
     cargarUsuario(widget.idUsuario);
     });
  }
  @override
  Widget build(BuildContext context) {
    
    screens=[ 
      IngresosScreen(idUsuario: int.parse(widget.idUsuario)),
      EgresosScreen(idUsuario: int.parse(widget.idUsuario)), ];
    final principalProvider = Provider.of<PrincipalProvider>(context);
    const String logo = 'assets/svgs/logotipo.svg'; 
    return WillPopScope(
      onWillPop: ()async=>false,
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: MyAppBar(idUsuario: int.parse(widget.idUsuario)),
// DRAWER          
          drawer: Drawer(
            child: Container(
              color: Theme.of(context).primaryColor,                  
              child: Column(
                children:  [
                  Padding(
                    padding: const EdgeInsets.only(top:10),
                    child: SvgPicture.asset(
                                          logo,
                                          // width: 250,
                                          height: 100,                             
                                        ),
                  ),
                  const Center(
                    child: Text(
                      "Qoway",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30
                      ),
                    ),
                  ),
                    const Center(
                    child: Text(
                      "V. 1.0.0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                  ListTile(
                    leading: const Icon(Icons.credit_score,),
                    title: const Text('CUENTAS'),
                    onTap: () {                       
                      Navigator.of(context).pushNamed("/cuenta",arguments:usuario.id);                    
                    },
                  ),               
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('SALIR'),
                    onTap: () { 
                      Db.actualizarActividad(0);
                      final vacio = Cuenta(idUsuario: 0,estaIncluido: 0,descripcion: 'Seleccione');
                      principalProvider.cuentaSet= vacio;
                      principalProvider.totalCero=0.0;
                      List<Map<String, Object?>> listaVacia=[];
                      principalProvider.ingresos=listaVacia;
                      principalProvider.egresos=listaVacia;
                      Navigator.of(context).pushReplacementNamed("/identificate");                     
                    },
                  ),
                ],
              ),
            ),
          ),   
          body:screens[screnIndex],
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(50),topRight:Radius.circular(50) ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                    height: 70,                    
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                     borderRadius: const BorderRadius.only(topLeft: Radius.circular(50),topRight:Radius.circular(50) )
                    ),            
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              splashColor: Colors.transparent,
                              enableFeedback: false,
                              onPressed: (){
                                 setState(() {
                                  screnIndex = 0;
                                });
                              }, icon: Icon(Icons.attach_money,color: (screnIndex==0)?Colors.white:Colors.white24)
                              
                              ),
                              Text('INGRESOS',style: TextStyle(color: (screnIndex==0)?Colors.white:Colors.white24))
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              splashColor: Colors.transparent,
                              onPressed: (){
                               setState(() {
                                  screnIndex = 1;
                                });
                            }, icon: Icon(Icons.money_off,color:(screnIndex==1)?Colors.white:Colors.white24)
                            ),
                            Text('EGRESOS',style: TextStyle(color: (screnIndex==1)?Colors.white:Colors.white24))
                          ],
                        ),                 
                      ],
                    ),
                  ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
             floatingActionButton: (principalProvider.cuentaGet.id!=null)
             ?
// BOTON  + AGREGAR INGRESOS O EGRESOS            
              InkWell(
                onTap: (){   
                final Map<String,dynamic> idCuentaYUsuario={
                  'idUsuario':widget.idUsuario,
                  'idCuenta':(principalProvider.cuentaGet.id).toString()
                };
                Navigator.of(context).pushNamed("/agregarIoE",arguments:idCuentaYUsuario);
              },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                  filter:  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                   child: Container(
                    width: 55,
                    height: 55,
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.black.withOpacity(0.2)
                    ),
                    child: const Icon(Icons.add),
                    ),
                  ),
                ),
              )           
              :
              Container(),  
        ),
      ),
    );
  }

}
