import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class SqlDb{
  static Database? _db;
  Future<Database?> get db async{
    if(_db == null){
      _db =await intialDb();
      return _db;
    }else{
      return _db;
    }
  }
  intialDb() async{
    String databasePath =await getDatabasesPath();
    String path =join(databasePath,'Mohamed.db');
    Database mydb =await openDatabase(path,onCreate: _onCreate,version:4,onUpgrade: _onUpgrade);
    return mydb;
  }
  _onUpgrade(Database db , int oldVersion , int newVersion){

  }
  _onCreate(Database db ,int version) async{
    Batch batch=db.batch();

    batch.execute('''
    CREATE TABLE  "notes" (
    'ID' INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    note TEXT NOT NULL,
    disc TEXT NOT NULL
    )
    ''');
    await batch.commit();
  }
  readData(String sql) async{
    Database? mydb =await db;
    List<Map> response =await mydb!.rawQuery(sql);
    return response;
  }//select
  insertData(String sql) async{
    Database? mydb =await db;
    int response =await mydb!.rawInsert(sql) ;
    return response;
  }//insert
  updateData(String sql) async{
    Database? mydb =await db;
    int response =await mydb!.rawUpdate(sql);
    return response;
  }//update
  deleteData(String sql) async{
    Database? mydb =await db;
    int response =await mydb!.rawDelete(sql);
    return response;
  }//delete
   myDeleteDatabase() async{
     String databasePath =await getDatabasesPath();
     String path =join(databasePath,'Mohamed.db');
     await deleteDatabase(path);
   }

}
