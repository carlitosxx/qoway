import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:qoway/model/telefonos.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:qoway/pages/divisa/divisa.dart';
import 'package:qoway/provider/principal_provider.dart';
// import 'firebase_options.dart';

// import 'helper/object_box.dart';
// import 'model/mensajes.dart';
// import 'model/user.dart';

// import 'package:sqflite/sqflite.dart';

// import 'pages/registro/registro.dart';
import 'provider/validaciones.dart';
import 'routes/route_generator.dart';

// late ObjectBox objectBox;

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  // options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await EasyLocalization.ensureInitialized();
  // objectBox=await ObjectBox.init();     
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(      
      providers: [
         ChangeNotifierProvider(create:(_) => Validaciones()),
         ChangeNotifierProvider(create:(_) => PrincipalProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
       ],
       supportedLocales: const [
          Locale('en','US'),
          Locale('es','ES')
       ],
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        onGenerateRoute: RouteGenerator.generateRoute,
        title: 'Flutter Demo',
        theme: ThemeData(    
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          /* dark theme settings */
        ),
        // home: RegistroPage()
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late Stream<List<User>> streamUsers;  
//   @override
//   void initState() {
//     super.initState();
//     streamUsers=objectBox.getUsers();
   
//   }
  
//   @override
//   Widget build(BuildContext context) {    
//     return Scaffold(
//       appBar: AppBar(        
//         title: Text(widget.title),
//       ),
//       body: StreamBuilder <List<User>>(
//         stream: streamUsers,
//         builder: (context, snapshot) {          
//           if (!snapshot.hasData || snapshot.data!.isEmpty){            
//             return const Center(
//               child:Text('No hay data')
//             );
//           }
//           else{
//             final users=snapshot.data!;
//             return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (ctx,i){
//                 final user=users[i];
//                 return Column(
//                   children: [
//                     ListTile(                      
//                       onTap: (){
//                         objectBox.eliminarUsuario(user.id);                                              
//                       },
                      
//                       onLongPress: () {                       
//                         print( user.telefonos[0].mensajes[1].mensaje);
                        
//                       },
//                       title: Text(user.name),
//                       subtitle: Text(user.email),
//                       leading: Text(user.id.toString()),
//                     ),
                    
//                   ],
//                 );
//               },
//             );
//           }
//         }
        
//         ),
//       floatingActionButton: Row(
//         children: [
//           FloatingActionButton(
//             child:const Icon(Icons.home),
//             onPressed: (){
//               objectBox.limpiarMensajes();
//               // objectBox.encontrarids();
//             // objectBox.limpiarTelefonos();
//             // objectBox.deleteTelefono(11);
//           }),
//           FloatingActionButton(
//             onPressed: (){
//               final user=User(
//                 name: Faker().person.firstName(),
//                 email: Faker().internet.email(),            
//               );
              
//               final telefono1 = Telefonos(              
//                 telefonos: Faker().phoneNumber.us()

//                 );
//               final telefono2 = Telefonos(
//                 telefonos: Faker().phoneNumber.us()
//                 );
//               final mensaje1 = Mensajes(mensaje:'hola1');
//               final mensaje2 = Mensajes(mensaje:'hola2'); 
               
//               List<Telefonos> listaTelefonos=[];
//               List<Mensajes> listaMensajes=[];
//               listaMensajes.add(mensaje1);
//               listaMensajes.add(mensaje2);

//               listaTelefonos.add(telefono1);
//               listaTelefonos.add(telefono2);

//               telefono1.mensajes.addAll(listaMensajes);
//               user.telefonos.addAll(listaTelefonos);
//               // user.
//               // user.telefonos.
              
//               objectBox.insertUser(user);        
//             },
//             tooltip: 'Agregar un ingreso o egreso',
//             child: const Icon(Icons.add,color: Color.fromRGBO(15, 42, 66, 1)),
//           ),
//         ],
//       ),
      
//     );
//   }
// }
