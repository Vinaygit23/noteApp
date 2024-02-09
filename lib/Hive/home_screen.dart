import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'boxes.dart';
import 'notesmodel/notes_model.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firstController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'NoTe ApP',style: TextStyle(
          fontSize: 35,color: Colors.white,fontWeight: FontWeight.bold
        ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body:
      Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Box<NotesModel>>(
              valueListenable: Boxes.getData().listenable(),
              builder: (context,box,_) {
                var data = box.values.toList().cast<NotesModel>();
                return ListView.builder(
                    itemCount: box.length ,
                    itemBuilder: (context,index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children:[
                              Container(
                               width: MediaQuery.sizeOf(context).width*0.55,
                                child: Text(
                                  data[index].title,
                                  softWrap: true,
                                  textAlign: TextAlign.justify,style: TextStyle(
                                  fontSize: 18
                                ),
                                ),
                              ),
            
            
                              Spacer(),
                              IconButton(onPressed: (){
                                _editDialog(data[index],data[index].title.toString(),);
            
                              }, icon: Icon(Icons.edit)),
                              SizedBox(width: 10,),
                              IconButton(onPressed: (){
                                deleteItem(data[index]);
                              }, icon: Icon(Icons.delete,color: Colors.red,)),
                            ]
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 28.0),
            child: Text("Add New note >>",style: TextStyle(
                fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold
            ),),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },child: Icon(Icons.note_alt_outlined),
      ),
    );
  }

  Future<void> _showMyDialog()async{
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                maxLines: 3,
                controller: firstController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  hintText: 'First'
                ),
              ),

            ],
          ),
        ),
        title: Text("Add New Notes"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel")),
          TextButton(onPressed: (){
            final data = NotesModel(title: firstController.text,);
            final box = Boxes.getData();
            box.add(data);
            data.save();
            print(data);
            firstController.clear();
            print(box.get('0').toString()+'----------------------');
            Navigator.pop(context);
          }, child: Text("Add")),
        ],
      );
    });
  }

  Future<void> _editDialog(NotesModel notesModel, String title)async{

    firstController.text = title;
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    hintText: 'First'
                ),
              ),

            ],
          ),
        ),
        title: Text("Edit dialog"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel")),
          TextButton(onPressed: ()async{
            notesModel.title = firstController.text.toString();
            notesModel.save();
            firstController.clear();
            Navigator.pop(context);
          }, child: Text("Edit")),
        ],
      );
    });
  }

  void deleteItem(NotesModel notesModel)async {
    await notesModel.delete();
  }
}
