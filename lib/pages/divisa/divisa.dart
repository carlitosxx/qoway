// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qoway/model/usuario.dart';

import '../../db/db.dart';
import '../../model/divisa.dart';

class DivisaPage extends StatefulWidget {
   String idUsuario;
   DivisaPage({Key? key, required this.idUsuario}) : super(key: key);

  @override
  State<DivisaPage> createState() => _DivisaPageState();
}

class _DivisaPageState extends State<DivisaPage> {
  bool esBusqueda = false;
  int selectedIndex=0;
  String descDivisa='Sol';
  String cortoDivisa='PEN';
  String simboloDivisa='S/.';
  // Divisa divisaSeleccionada=Divisa(
  //   descDivisa: descDivisa,
  //   cortoDivisa: cortoDivisa,
  //   simboloDivisa: simboloDivisa,
  //   ladoDivisa: ladoDivisa)
  List<Divisa> divisas=[];
  cargarUsuarios()async{
    List<Divisa> listaDivisas=await Db.divisas();
    setState(() {
      divisas = listaDivisas;
    });
  }
  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
  print(widget.idUsuario);
    return WillPopScope(
      onWillPop: ()async=>false,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: esBusqueda?const TextField(
              ): const Text('Seleccione su divisa'),
              automaticallyImplyLeading: false,
              actions: [IconButton(
                onPressed: (){
                  esBusqueda=!esBusqueda;
                  setState(() {
                    
                  });
                },
                icon:esBusqueda?const Icon(Icons.close): const Icon(Icons.search))
                ],
            ),
            body:ListView.builder(
              itemCount: divisas.length,
              itemBuilder: ((context, i) {
                return Container(
                  color: (selectedIndex==i)?Colors.white24:Colors.transparent,
                  child: ListTile( 
                    title:Text(divisas[i].descDivisa),
                    subtitle:Text(divisas[i].cortoDivisa) ,
                    trailing:Text(divisas[i].simboloDivisa),
                    // dense: true,
                    visualDensity: const VisualDensity(vertical: -3),
                    onTap: (() {
                      descDivisa=divisas[i].descDivisa;
                      cortoDivisa=divisas[i].cortoDivisa;
                      simboloDivisa=divisas[i].simboloDivisa;
                      // print(descDivisa+cortoDivisa+simboloDivisa);
                      selectedIndex=i;
                      setState(() {
                        
                      });

                    }),
                  ),
                );                
              })
              ,
              
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black26,
              // splashColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.arrow_forward,color: Colors.white,size: 25,),
              onPressed: ()async{
                Db.actualizarDivisa(divisas[selectedIndex].descDivisa, divisas[selectedIndex].cortoDivisa, divisas[selectedIndex].simboloDivisa, divisas[selectedIndex].ladoDivisa, int.parse(widget.idUsuario));
                Db.actualizarActividad(int.parse(widget.idUsuario));
                Navigator.of(context).pushReplacementNamed('/principal',arguments: widget.idUsuario);
              }),
          ),
        ),
      ),
    );
  }
}