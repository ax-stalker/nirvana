import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class displayInfor extends StatefulWidget {
   displayInfor({
    super.key,
    required this.label,
    required this.value,
    required this.docid,
    required this.collectionName
  });
  String label;
  String value;
  String docid;
  String collectionName;
  

  @override
  State<displayInfor> createState() => _displayInforState();
}

class _displayInforState extends State<displayInfor> {
  final TextEditingController _textFieldController = TextEditingController();
     final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return  Column(
    children: [
      SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [

            Text(widget.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            Text(widget.value),
              ],
            ),
            IconButton(onPressed: (){_displayTextInputDialog(context);}, icon:const Icon(Icons.edit))

          ],
        ),
      )),
       
     
      
      
                  
    ],
                      );
  }

Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.label),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: widget.value),
          ),
          actions: [
             TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                print(widget.docid);
                print(widget.label);
                print(widget.value);
                print(_textFieldController.text);
                  // final data = {widget.label: widget.value};
                  //   await _firestore.collection("Users").doc(widget.docid).update(data);


                setState(() {
                widget.value = _textFieldController.text;
                  
                });
                final data = {widget.label: widget.value};
                    await _firestore.collection(widget.collectionName).doc(widget.docid).set(data,SetOptions(merge: true));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}