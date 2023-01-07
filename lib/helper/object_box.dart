// import '../model/mensajes.dart';
// import '../model/telefonos.dart';
// import '../model/user.dart';
// import '../objectbox.g.dart';

// class ObjectBox{
//   late final Store _store;
//   late final Admin admin;

//   //Cajas o tablas
//   late final Box<User> _userBox;
//   late final Box<Telefonos> _telefonoBox;
//   late final Box<Mensajes> _mensajeBox;
//   // iniciamos la caja o tabla de la base de datos _store
//   ObjectBox._init(this._store){
//     _userBox=Box<User>(_store);
//     _telefonoBox=Box<Telefonos>(_store);
//     _mensajeBox=Box<Mensajes>(_store);

//     if (Admin.isAvailable()) {      
//     admin = Admin(_store);   
//     }
//   }
//   // retorna la apertura de la base de datos
//   static Future<ObjectBox> init() async{
//     final store = await openStore();
//     return ObjectBox._init(store);
//   }
//   // Obtiene un usuario de la caja o tabla _userBox
//   User? getUser(int id)=> _userBox.get(id);
//   // obtiene un stream de todos los usuarios de la tabla _userBox
//   Stream<List<User>> getUsers()=> _userBox
//     .query()
//     .watch(triggerImmediately: true)
//     .map((query)=>query.find());

//   int insertUser(User user)=> _userBox.put(user); 
//   bool deleteTelefono(int id)=> _telefonoBox.remove(id);
//   limpiarMensajes()=> _mensajeBox.removeAll();
//   bool eliminarUsuario(int id) {
//     Query<Telefonos> query=_telefonoBox.query(Telefonos_.user.equals(id)).build();
//     List<Telefonos> listaIds=query.find();    
//     List<int> nuevaListaIds=listaIds.map((item)=> item.id).toList();    
//     _telefonoBox.removeMany(nuevaListaIds);
//     return _userBox.remove(id);    
//   }
  

// }