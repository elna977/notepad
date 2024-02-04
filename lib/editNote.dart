import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notepad/homeScreen.dart';
import 'package:notepad/sqflite.dart';

class EditScreen extends StatefulWidget {
  final note;
  final title;
  final id;
  const EditScreen({Key?key,this.note,this.title,this.id}):super(key: key);

  @override
  State<EditScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<EditScreen> {
  SqlDb sqlDb =SqlDb();
  GlobalKey<FormState>formstate =GlobalKey();
  TextEditingController note =TextEditingController();
  TextEditingController title =TextEditingController();

  @override
  void initState() {
    note.text =widget.note;
    title.text =widget.title;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Notes",style: TextStyle(
            color: Colors.yellow[600],fontWeight: FontWeight.bold
        )),
        actions: [
          IconButton(onPressed: ()async{

            var response = await sqlDb.updateData('''
                  UPDATE notes SET 
                  note ="${note.text}"
                  ,title="${title.text}"
                  WHERE ID = ${widget.id}
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
