// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:qoway/model/divisa.dart';
import 'package:sqflite/sqflite.dart';

import '../model/cuenta.dart';
import '../model/movimiento.dart';
import '../model/usuario.dart';

class Db{
    static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    }    
   static Future _onCreate(Database db, int version)async{
      await db.execute(
      '''     
        CREATE TABLE actividad(
          id INTEGER
        );       
      ''');
      await db.execute(
      '''
        INSERT INTO actividad(id)
        values(0);
      ''');

      await db.execute(
      '''     
        CREATE TABLE usuario(
          id INTEGER PRIMARY KEY ,
          nombre TEXT,
          correo TEXT UNIQUE,
          clave TEXT,
          descDivisa TEXT,
          cortoDivisa TEXT,
          simboloDivisa TEXT,
          ladoDivisa INTEGER);       
      ''');
      await db.execute(
      '''
        CREATE TABLE cuenta(
          id INTEGER PRIMARY KEY,
          descripcion TEXT,
          estaIncluido INTEGER,
          idUsuario INTEGER,
          FOREIGN KEY(idUsuario) REFERENCES usuario(id));          
      ''');
      await db.execute(
      '''
        CREATE TABLE movimiento(
          id INTEGER PRIMARY KEY,
          tipoMovimiento INTEGER,
          monto REAL,
          fecha INTEGER,
          comentario TEXT,
          idCuenta INTEGER,
          FOREIGN KEY(idCuenta) REFERENCES cuenta(id)
          );
      ''');  
      await db.execute(
      '''
        CREATE TABLE divisa(
          id INTEGER PRIMARY KEY,
          descDivisa TEXT,
          cortoDivisa TEXT,
          simboloDivisa TEXT,
          ladoDivisa INTEGER);
      ''');
      await db.execute(
      '''
        INSERT INTO divisa(descDivisa,cortoDivisa,simboloDivisa,ladoDivisa)
        values
        ('Boliviano','BOB','Bs.',1),
        ('Guarani','PYG','₲',0),
        ('Peso argentino','ARS','\$',1),
        ('Peso chileno','CLP','\$',1),
        ('Sol','PEN','S/.',0);
      ''');
  

    }

    static Future<Database>  _openDB() async{
      // var documentsDirectory = await  getApplicationDocumentsDirectory();
      // final path =join(documentsDirectory.path,'qoway.db');
      // print(path);      
        return openDatabase(join(await getDatabasesPath(),'qoway.db'),
          onCreate: _onCreate,
          version: 1, 
          onConfigure: _onConfigure         
        );

    }
    //ELIMINAR BASE DE DATOS
    Future<void> deleteDatabase(String path) =>
    databaseFactory.deleteDatabase(path);
// USUARIO===================================
    // INSERTAR USUARIO
    static Future<int> insertUsuario(Usuario usuario)async{
      try{
      Database database = await _openDB();
      int idUsuario =await database.insert("usuario",usuario.toMap());
      return idUsuario;
      } on DatabaseException catch (e) {        
        if (e.isUniqueConstraintError()){
          print('El usuario ya existe');
          return 0;
        }
        return 0;
      }     
      // return 
    }
    //BORRAR USUARIO    
    static Future<int> delete(Usuario usuario) async{
      Database database = await _openDB();
      return database.delete("usuario",where: "id=?",whereArgs: [usuario.id]);
    }
    //BORRAR TODOS LOS USUARIOS
    static Future<int> deleteAllUsuario() async{
      Database db = await _openDB();
      return db.delete("usuario");
    }
    //ACTUALIZAR TODO EL USUARIO
    static Future<int> update(Usuario usuario) async{
      Database database = await _openDB();
      return database.update("usuario",usuario.toMap(),where: "id=?",whereArgs: [usuario.id]);
    }
    //OBTENER UN USUARIO CON CORREO Y CLAVE
    static Future<List<Map<String, Object?>>> obtenerUsuario(Usuario usuario)async{
      Database database = await _openDB();
      return database.query("usuario",where: 'correo=? and clave=?',whereArgs: [usuario.correo,usuario.clave],limit: 1);
    }
    //OBTENER UN USUARIO CON ID
    static Future<List<Map<String, Object?>>> obtenerUsuarioPorId(int idUsuario)async{
      Database database = await _openDB();
      return database.query("usuario",where: 'id=?',whereArgs: [idUsuario],limit: 1);
    }
    //LISTA DE USUARIOS
    static Future<List<Usuario>> usuarios()async{
      Database database = await _openDB();
      final List<Map<String,dynamic>> usuariosMap= await database.query("usuario");
      return List.generate(usuariosMap.length, (index) => Usuario(
        id:usuariosMap[index]['id'],
        nombre:usuariosMap[index]['nombre'],
        correo: usuariosMap[index]['correo'],
        clave:usuariosMap[index]['clave'],
        descDivisa: usuariosMap[index]['descDivisa'],
        cortoDivisa: usuariosMap[index]['cortoDivisa'],
        simboloDivisa: usuariosMap[index]['simboloDivisa'],
        ladoDivisa: usuariosMap[index]['ladoDivisa']
      ));
    }
// ACTIVIDAD ==============================    
    //OBTENER ACTIVIDAD
    static  Future<List<Map<String, Object?>>> obtenerActividad()async{
      Database database = await _openDB();
      // print()
      return database.query("actividad");
    }
    //ACTUALIZAR ACTIVIDAD
    static Future<int> actualizarActividad(int id)async{
      Database database = await _openDB();
      return database.rawUpdate('''
      UPDATE actividad SET id=? 
      ''',[id]);
    }
// DIVISAS=============================    
    //ACTUALIZAR DIVISAS
    static Future<int> actualizarDivisa(String descDivisa,String cortoDivisa,String simboloDivisa,int ladoDivisa,int id) async{
      Database database = await _openDB();
       return database.rawUpdate('''
      UPDATE usuario SET descDivisa=?,cortoDivisa=?,simboloDivisa=?,ladoDivisa=? WHERE id=?
      ''',[descDivisa,cortoDivisa,simboloDivisa,ladoDivisa,id]);      
    }  
    //OBTENER LISTA DE DIVISAS
    static Future<List<Divisa>> divisas()async{
      Database database = await _openDB();
      final List<Map<String,dynamic>> divisasMap= await database.query("divisa");
      return List.generate(divisasMap.length, (index) => Divisa(
        id:divisasMap[index]['id'],       
        descDivisa: divisasMap[index]['descDivisa'],
        cortoDivisa: divisasMap[index]['cortoDivisa'],
        simboloDivisa: divisasMap[index]['simboloDivisa'],
        ladoDivisa: divisasMap[index]['ladoDivisa']
      ));
    }
// CUENTA ==========================
    // CREAR CUENTA PRINCIPAL
    static registrarCuentaPrincipal(Cuenta cuenta) async{
      Database database = await _openDB();
      return database.insert("cuenta",cuenta.toMap());
    }
    // OBETENER CUENTAS SEGUN ID    
    static Future<List<Map<String, Object?>>> obtenerCuentas(int id)async{
      Database database = await _openDB();      
      return database.query("cuenta",where: "idUsuario=?",whereArgs: [id]) ;
    }
    // AGREGAR CUENTA
    static Future<int> agregarCuenta(Cuenta cuenta)async{
      try {
         Database database = await _openDB();
         int result =  await database.insert("cuenta",cuenta.toMap());    
      return result;
      } on DatabaseException catch (e) {        
        if (e.isUniqueConstraintError()){
          print('la descripcion ya existe');
          return 0;
        }
        return 0;
      }     
    }
    // ELIMINAR CUENTA Y SUS MOVIMIENTOS PRIMERO
    static eliminarCuenta(Cuenta cuenta) async{
      Database database = await _openDB();
      database.delete("movimiento",where:'idCuenta=?',whereArgs:[cuenta.id]);
      return database.delete("cuenta",where: 'id=?',whereArgs: [cuenta.id]);
    }
    // MODIFICAR CUENTA
    static Future<int>editarCuenta(Cuenta cuenta) async{
      Database database=await _openDB();
      return database.rawUpdate(
        'UPDATE cuenta SET descripcion = ? WHERE id = ?',
        [cuenta.descripcion, cuenta.id]);
    }

// MOVIMIENTOS =========================
    //OBTENER MOVIMIENTOS DE TODAS LAS CUENTAS SEGUN ID
    static Future<List<Map<String, Object?>>> obtenerMovimientos(int id)async{
      Database database = await _openDB();      
      return database.rawQuery('''
        SELECT 
        A.id as idMovimiento,
        A.tipoMovimiento,
        A.monto as montoMovimiento,
        A.fecha,
        A.comentario as comentarioMovimiento,
        B.id as idCuenta,
        B.descripcion as descripcionCuenta,
        B.estaIncluido,
        C.simboloDivisa,
        C.ladoDivisa 
        from movimiento A 
        INNER JOIN  cuenta B on B.id=A.idCuenta 
        INNER JOIN usuario C on C.id=B.idUsuario  
        WHERE  C.id=? order by fecha desc
        ''',[id]);
    }
    //OBTENER MOVIMIENTOS DE UNA CUENTA SEGUN ID_CUENTA E ID_USUARIO
    static Future<List<Map<String, Object?>>> obtenerMovimientosDeCuenta(int idCuenta,int idUsario)async{
      Database database = await _openDB();      
      return database.rawQuery('''
        SELECT 
        A.id as idMovimiento,
        A.tipoMovimiento,
        A.monto as montoMovimiento,
        A.fecha,
        A.comentario as comentarioMovimiento,
        B.id as idCuenta,
        B.descripcion as descripcionCuenta,
        B.estaIncluido,
        C.simboloDivisa,
        C.ladoDivisa 
        from movimiento A 
        INNER JOIN  cuenta B on B.id=A.idCuenta 
        INNER JOIN usuario C on C.id=B.idUsuario  
        WHERE  C.id=? AND B.id=? order by fecha desc
        ''',[idUsario,idCuenta]);
    }
    //INSERTAR MOVIMIENTOS
    static insertarMovimiento(Movimiento movimiento)async{
      Database database = await _openDB();
      return database.insert("movimiento",movimiento.toMap());
    }
    //ELIMINAR MOVIMIENTO
    static eliminarMovimiento(Movimiento movimiento)async{
      Database database = await _openDB();
      return database.delete("movimiento",where: 'id=?',whereArgs: [movimiento.id]);
    }
}