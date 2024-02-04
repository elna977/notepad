import 'package:flutter/material.dart';
import 'package:notepad/editNote.dart';
import 'package:notepad/noteScreen.dart';
import 'package:notepad/sqflite.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {"addNote":(context)=>NoteScreen()},
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SqlDb sqlDb =SqlDb();
  bool loading =true;
  List notes = [];
  Future readData() async{
    List<Map> response =await sqlDb.readData("SELECT * FROM notes");
    notes.addAll(response);
    loading=false;
    if(this.mounted){
      setState(() {
      });
    }
  }
  @override
  void initState() {
    readData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        title: Text("NotePad",textAlign: TextAlign.center,style: TextStyle(
            color: Colors.yellow[600],fontWeight: FontWeight.bold
        ),),
        backgroundColor: Colors.blue[300],
        actions: [
          // IconButton(onPressed: () async{
          // await sqlDb.myDeleteDatabase();
          //
          // }, icon: Icon(Icons.delete_rounded,color:Colors.yellow[600])),
          IconButton(onPressed: (){
            showSearch(
              context: context,
              delegate:   MySearchDelegate(),
            );
          }, icon: Icon(Icons.search,color:Colors.yellow[600])),
        ],
      ),
      backgroundColor: Colors.yellow[600],
      drawer: Drawer(
        backgroundColor: Colors.yellow[600],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NoteScreen()));
      },
        child: Icon(Icons.add),),
      body: loading ==true?
          Center(child: Text("loading......"))
          :
            Container(
              child: ListView(
                children: [
                 ListView.builder(
                        itemCount: notes.length,
                          physics:  NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context,i){
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () async{
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditScreen(
                                    note:notes[i]['note'] ,
                                    title:notes[i]['title'] ,
                                    id:notes[i]['ID'] ,
                                  )));
                                },
                                child: Card(
                                  child: ListTile(
                                    title: Text("${notes[i]['title']}"),
                                    subtitle: Text("${notes[i]['note']}"),
                                    trailing:Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(onPressed: ()async{
                                          int response =await sqlDb.deleteData('''
                                           DELETE FROM "notes" WHERE ID = ${notes[i]['ID']}''');
                                          if(response >0){
                                            notes.removeWhere((element) => element['ID'] ==notes[i]['ID']);
                                            setState(() {
                                            });
                                          }
                                        },icon: Icon(Icons.delete,color: Colors.red,),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                      })

                ],
              ),
            )
    );
  }
}
class MySearchDelegate extends SearchDelegate{
  SqlDb sqlDb =SqlDb();
  Future<List<Map>> readData()async{
    List<Map>response =await sqlDb.readData("SELECT * FROM notes");
    return response;
  }
  @override
  // TODO: implement query
  @override
  Widget buildLeading(BuildContext context) => IconButton(
      onPressed: ()
        =>close(context, null),
      icon: Icon(Icons.arrow_back));
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
        onPressed: (){
          if(query.isEmpty){
            close(context, null);
          }else{
            query ='';
          }
        },
        icon: Icon(Icons.clear))
  ];
  Widget buildResults(BuildContext context) => const Text('results');
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder(builder: (BuildContext context,AsyncSnapshot<List<Map>> snapshot){

          // String input =query.toLowerCase();
          // String result =snapshot.data!.toString().toLowerCase();
          // result.contains(input);
          //   snapshot.data!.wh

          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data!.length,
                physics:  NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context,i){
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      child: ListTile(
                        title: Text("${snapshot.data![i]['note']}"),
                        onTap: (){
                          query =snapshot.data![i]['note'];
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditScreen(
                            note:snapshot.data![i]['note'] ,
                            title:snapshot.data![i]['title'] ,
                            id:snapshot.data![i]['ID'] ,
                          )));
                        },
                        subtitle: Text("${snapshot.data![i]['title']}"),
                        trailing:Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: ()async{
                              int response =await sqlDb.deleteData('''
                                         DELETE FROM "notes" WHERE ID = ${snapshot.data![i]['ID']}''');
                              if(response >0){

                              }
                            },icon: Icon(Icons.delete,color: Colors.red,),),
                            IconButton(onPressed: ()async{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditScreen(
                                note:snapshot.data![i]['note'] ,
                                title:snapshot.data![i]['title'] ,
                                id:snapshot.data![i]['ID'] ,
                              )));
                            },icon: Icon(Icons.edit,color: Colors.blue,),),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return Center(child: CircularProgressIndicator(),);
        }, future: readData(),),
      ],
    );
  }
}
