import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_app/database/database.dart';
import '../models/note_model.dart';
import 'home_screen.dart';

class AddNoteScreen extends StatefulWidget {

  final Note? note;
  final Function? updateNoteList;

  AddNoteScreen({this.note, this.updateNoteList});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {

  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _priority = 'Low';
  String btnText = "Add Note";
  String titleText = "AddNote";

  TextEditingController _dateController = TextEditingController();

  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  DateTime _date = DateTime.now();

  final List<String> _priorities = ['Low', 'Medium', 'High'];


  @override
  void initState(){
    super.initState();

    if(widget.note !=null){
      _title = widget.note!.title!;
      _date = widget.note!.date!;
      _priority = widget.note!.priority!;

      setState(() {
        btnText = "Update Note";
        titleText = "Update Note";
      });

    }
    else{
      setState(() {
        btnText = "Add Note";
        titleText = "Add Note";
      });
    }

    _dateController.text = _dateFormatter.format(_date);

  }

  @override
  void dispose(){
    _dateController.dispose();
    super.dispose();
  }

  _handleDatePicker() async{
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100)
    );
    if (date != null && date != date){
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }


  _delete(){
    DatabaseHelper.instance.deleteNote(widget.note!.id!);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()
        ),
    );
    widget.updateNoteList!();
  }

  _submit(){
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      print('$_title, $_date,$_priority');

      Note note = Note(title: _title, date: _date, priority:_priority);

      if(widget.note == null){
        note.status = 0;
        DatabaseHelper.instance.insertNote(note);

        Navigator.pushReplacement(
          context, 
        MaterialPageRoute(builder: (_) => HomeScreen()));
      }
      else{
        note.id = widget.note!.id;
        note.status = widget.note!.status;
        DatabaseHelper.instance.updateNote(note);
        
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => HomeScreen()));
      }
      widget.updateNoteList!();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal:40.0, vertical: 80.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => HomeScreen(),)),
                  child: Icon(Icons.arrow_back,
                  size: 30.0,
                    color: Colors.red,),
                ),
                SizedBox(height: 20.0,),
                Text(
                  titleText,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height:10.0),
                Form(
                  key: _formKey,
                    child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                          ),
                          validator: (input) =>
                          input!.trim().isEmpty ? 'Please enter a note title' : null,
                          onSaved: (input) => _title = input!,
                          initialValue: _title,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          readOnly: true,
                            controller: _dateController,
                            style: TextStyle(fontSize: 18.0),
                            onTap: _handleDatePicker,
                            decoration: InputDecoration(
                                labelText: 'Date',
                                labelStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )
                            )
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                            icon: Icon(Icons.arrow_drop_down_circle),
                            iconSize:22.0,
                            iconEnabledColor: Colors.red,
                            items: _priorities.map((String priority){
                              return DropdownMenuItem(
                                value: priority,
                                  child: Text(
                                    priority,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18.0
                                    ),
                                  ),
                              );
                            }).toList(),
                          style: TextStyle(
                            fontSize: 18.0
                          ),
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            labelStyle: TextStyle(
                              fontSize: 18.0
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                          ),
                          validator: (input) => _priority == null ? 'Please select a priority level' : null,
                          onChanged: (value){
                              setState(() {
                                _priority = value.toString();
                              });
                          },
                          value: _priority,
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                          height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ElevatedButton(
                          child: Text(
                            btnText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            )
                          ),
                          onPressed: _submit,
                        ),
                      ),
                      widget.note != null ? Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30.0)
                        ),
                        child: ElevatedButton(
                          child: Text(
                            'Delete Note',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0
                            ),
                          ),
                            onPressed:_delete,
                        ),
                      ): SizedBox.shrink(),
                    ],
                )
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
