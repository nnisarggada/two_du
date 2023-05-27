import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({Key? key}) : super(key: key);

  @override
  AddToDoPageState createState() => AddToDoPageState();
}

class AddToDoPageState extends State<AddToDoPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String type = "Important";
  String category = "Work";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff252041),
              Color(0xff1d1e26),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Padding(
              padding: const EdgeInsets.all(10),
              child:  IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(CupertinoIcons.arrow_left, color: Colors.white,size: 30,)),
              ),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "New TwoDu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    label("Title"),
                    const SizedBox(height: 10),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xff2a2e3d),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        controller: titleController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Task Title",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        contentPadding: EdgeInsets.all(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    label("Type"),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        typeChipLabel("Important", Colors.redAccent),
                        const SizedBox(width: 20),
                        typeChipLabel("Planned", Colors.orangeAccent),
                      ],
                    ),
                    const SizedBox(height: 20),
                    label("Description"),
                    const SizedBox(height: 10),
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xff2a2e3d),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextFormField(
                        controller: descriptionController,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Task Description",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        contentPadding: EdgeInsets.all(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    label("Category"),
                    const SizedBox(height: 10),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        categoryChipLabel("Work", Colors.indigoAccent),
                        const SizedBox(width: 20),
                        categoryChipLabel("Personal", Colors.blue),
                        const SizedBox(width: 20),
                        categoryChipLabel("Other", Colors.lightBlueAccent),
                      ],
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        if (titleController.text != "") {
                          try {
                            FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).add({
                              "title": titleController.text,
                              "type": type,
                              "description": descriptionController.text,
                              "category": category,
                              "checked": false,
                            });
                            Navigator.pop(context);
                          }
                          catch (e) {
                            const snackBar = SnackBar(content: Text("Something went wrong :/"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }
                        else {
                          const snackBar = SnackBar(content: Text("TwoDo title cannot be blank"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff8a32f1),
                              Color(0xffad32f9),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Add TwoDu",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget typeChipLabel(String text, Color color) {
    return InkWell(
      onTap: (){
          setState(() {
            type = text;
          });
        },
      child: Chip(
        backgroundColor: type == text ? color : Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
    );
  }

  Widget categoryChipLabel(String text, Color color) {
    return InkWell(
      onTap: (){
        setState(() {
          category = text;
        });
      },
      child: Chip(
        backgroundColor: category == text ? color : Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
    );
  }

  Widget label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}
