// import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qoway/model/movimiento.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;


import '../../db/db.dart';
import '../../provider/principal_provider.dart';
class AgregarTransaccionPage extends StatefulWidget {
  final Map<String,dynamic> idCuentaYUsuario;
  
  const AgregarTransaccionPage({Key? key,required this.idCuentaYUsuario,}) : super(key: key);

  @override
  State<AgregarTransaccionPage> createState() => _AgregarTransaccionPageState();
}

class _AgregarTransaccionPageState extends State<AgregarTransaccionPage> {
  int tipoTransaccion=1;
  // CONTROLLERS FOCUS y HINT 
  final controllerMonto       = TextEditingController();
  final controllerDescripcion = TextEditingController();
  FocusNode focusMonto        = FocusNode(); 
  FocusNode focusDescripcion  = FocusNode(); 
  String hintMonto            = 'Monto';
  String hintDescripcion      = 'Ingrese una descripcion...';
  // CALENDARIO  
  DateTime _selectedDay= DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day); 
  DateTime _focusedDay        = DateTime.now();
  CalendarFormat _calendarFormat= CalendarFormat.month;

  @override
  void initState() { 
    super.initState();  
    focusMonto.addListener(() {
        if (focusMonto.hasFocus) {
          hintMonto = '';
        } else {
          hintMonto = 'Monto';
        }      
        setState(() {});
      });
    focusDescripcion.addListener(() {
        if (focusDescripcion.hasFocus) {
          hintDescripcion = '';
        } else {
          hintDescripcion = 'Ingrese una descripcion...';
        }      
        setState(() {});
      });  
  }

  @override
  Widget build(BuildContext context) {
    final principalProvider = Provider.of<PrincipalProvider>(context); 
    return Scaffold(
      body: CustomScrollView(
        slivers: [
           SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                centerTitle: false,
                automaticallyImplyLeading: false,
                actions: [
              // BOTON CERRAR    
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
                title: const Text('Agregar Transaccion',style: TextStyle(              
                  shadows:[
                    Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 1.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),            
                  ], 
                ),
                ),
                pinned: true,              
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left:30,right: 30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: (){
                              tipoTransaccion=1;
                              setState((){});
                            },
                            child: Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                              color: (tipoTransaccion==0)?Theme.of(context).scaffoldBackgroundColor:Colors.black26,
                              borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(child: Text('INGRESO',style: TextStyle(color: (tipoTransaccion==0)?Colors.grey:Colors.white),)),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                               tipoTransaccion=0;
                              setState((){});
                            },
                            child: Container(                      
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                              color: (tipoTransaccion==0)?Colors.black26:Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(child: Text('EGRESO',style: TextStyle(color: (tipoTransaccion==0)?Colors.white:Colors.grey),)),
                            ),
                          )
                        ],
                      ),
  // DESCRIPCION
                       Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            margin:  const EdgeInsets.fromLTRB(10, 10, 10, 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(.1),
                            ),  
                        child: TextField(
                          maxLength: 100,
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
  // MONTO
                      Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            margin:  const EdgeInsets.fromLTRB(80, 10, 80, 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(.1),
                            ),    
                            child: TextField(                              
                              // onChanged: (String value) {                              
                              //   // print(value);
                              // },       
                              inputFormatters: 
                                [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                FilteringTextInputFormatter.deny(RegExp(r'\.\.')),
                                // FilteringTextInputFormatter.deny(RegExp(r'([.]+)?$')),
                                DecimalTextInputFormatter(decimalRange: 2)
                                ],
                              focusNode: focusMonto,
                              controller: controllerMonto,
                              maxLength: 10,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true) ,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 20),
                              decoration: InputDecoration(                                  
                                  counterText: '',
                                  border: InputBorder.none,
                                  hintText: hintMonto,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.3)
                                  )
                              ),
                            ),
                      ),
  // CALENDARIO
                      TableCalendar(
                        locale:  'es_ES',
                        focusedDay: _focusedDay,
                        firstDay: DateTime(2000),
                        lastDay: DateTime(2100),
                        calendarFormat: _calendarFormat,
                        startingDayOfWeek: StartingDayOfWeek.monday,                        
                        // QUITAR EL BOTON WEEK Y CENTRAR EL MES Y AÑO
                        headerStyle: const HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false
                        ),
                        currentDay: DateTime.now(),
                        calendarStyle: const CalendarStyle(
                          selectedDecoration:  BoxDecoration(
                            color:Colors.black38,                            
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: Colors.white10,                            
                            shape: BoxShape.circle,                          
                          )
                        ),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {                          
                            _selectedDay = selectedDay;
                            _selectedDay = DateTime(selectedDay.year,selectedDay.month,selectedDay.day);
                            _focusedDay = focusedDay; 
                          });
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },                        
                      )
                    ],
                  ),
                ),
              )  
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: ()async {       
          if (controllerDescripcion.text.trim()=='' || controllerMonto.text.trim()==''){
            final snackBar = SnackBar(
              content: const Text('Ingrese una descripcion y un monto'),            
              backgroundColor: Colors.white54,
              action: SnackBarAction(
                textColor: Colors.black,
                label: 'Cerrar', onPressed: (){}),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }else 
          {
            try {              
              double monto= double.parse(controllerMonto.text);                       
              Movimiento movimiento= Movimiento(
                tipoMovimiento: tipoTransaccion,
                monto: monto,
                fecha: _selectedDay.millisecondsSinceEpoch,
                comentario: controllerDescripcion.text,
                idCuenta: int.parse(widget.idCuentaYUsuario['idCuenta'])
              );
// INSERTAR MOVIMIENTO              
              await Db.insertarMovimiento(movimiento); 
// OBTENER TODAS LOS MOVIMIENTOS              
              // List<Map<String, Object?>> listamovimientos=await Db.obtenerMovimientos(int.parse(widget.idCuentaYUsuario['idUsuario']));
              List<Map<String,Object?>> movimientosCuenta=await Db.obtenerMovimientosDeCuenta(
                int.parse(widget.idCuentaYUsuario['idCuenta']),
                int.parse(widget.idCuentaYUsuario['idUsuario']));
                
              principalProvider.movimientosPorCuenta=movimientosCuenta;
              principalProvider.total= movimientosCuenta;
              principalProvider.ingresos=(movimientosCuenta.where((item){
                                                    return item['idCuenta']==int.parse(widget.idCuentaYUsuario['idCuenta']) && item['tipoMovimiento']==1;
                                                  })).toList();  
                principalProvider.egresos=(movimientosCuenta.where((item){
                                                    return item['idCuenta']==int.parse(widget.idCuentaYUsuario['idCuenta']) && item['tipoMovimiento']==0;
                                                  })).toList(); 
              Navigator.of(context).pop();
            } catch (e) {    
              print(e);          
              final snackBar2 = SnackBar(
                content: const Text('Monto invalido'),            
                backgroundColor: Colors.white54,
                action: SnackBarAction(
                  textColor: Colors.black,
                  label: 'Cerrar', onPressed: (){}),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar2);
            }    
          }
        },
        child: Container(          
          margin: const EdgeInsets.only(bottom: 5),
          height: 50,         
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(25)
          ),
          child: const Center(child: Text('Guardar ',style:TextStyle(fontSize: 23,fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}




class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}