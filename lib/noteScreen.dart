import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notepad/sqflite.dart';

import 'homeScreen.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  SqlDb sqlDb =SqlDb();
  GlobalKey<FormState>formstate =GlobalKey();
  TextEditingController note =TextEditingController();
  TextEditingController title =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Notes",style: TextStyle(
        color: Colors.yellow[600],fontWeight: FontWeight.bold
        )),
        actions: [
          IconButton(onPressed: ()async{

            var response = await sqlDb.insertData('''
                  INSERT INTO "notes" (note,title) 
                  VALUES ('${note.text}','${title.text}')
                  ''');
            if(response!=null){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()), (route) => false);
            }

          }, icon:Icon(Icons.save,color:Colors.yellow[600]))
        ],
      ),
      body: Container(
        child: ListView(
          children: [
            Form(
              key: formstate,
                child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: title,
                    decoration: InputDecoration(
                      hintText: "Title",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: note,
                    decoration: InputDecoration(
                      hintText: "Note",
                      border: InputBorder.none,

                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
