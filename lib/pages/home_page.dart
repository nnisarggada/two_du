import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:two_du/custom/todo_card.dart';
import 'package:two_du/pages/add_todo_page.dart';
import 'package:two_du/pages/login_page.dart';
import 'package:two_du/pages/view_todo_page.dart';
import 'package:two_du/service/auth_service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).snapshots();
  final String day = DateFormat.EEEE().format(DateTime.now());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
     appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 90,
        backgroundColor: Colors.black87,
        title: const Text(
          "Today's Schedule",
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${DateFormat.d().format(DateTime.now())} ${DateFormat.MMM().format(DateTime.now())} ${DateFormat.y().format(DateTime.now())}, ${DateFormat.EEEE().format(DateTime.now())}",
                  style: const TextStyle(
                    color: Color(0xff8c52ff),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          color: Colors.black87,
          padding: const EdgeInsets.only(top: 10),
          child: BottomNavigationBar(
            backgroundColor: Colors.black87,
            items: [
              BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () async {
                    try{
                      var todo = FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).where("checked", isEqualTo: true);
                      todo.get().then((querySnapshot)=>{
                        querySnapshot.docs.forEach((element) {
                          FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc(element.id).delete();
                        })
                      });
                    }
                    catch(e){
                      const snackBar = SnackBar(content: Text("Error :/"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: const Icon(
                    Icons.delete,
                    size: 32,
                    color: Colors.red,
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: InkWell(
                  onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddToDoPage()));
                    },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigoAccent,
                          Colors.purple,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: InkWell(
                  onTap: (){
                    authClass.logOut();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => const LoginPage()), (route) => false);
                  },
                  child: const Icon(
                    Icons.exit_to_app,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                label: "",
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Container(
              color: Colors.black87,
              child: Center(
                child: const Text(
                  "Nothing TwoDu :)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            );
          }
          else {
            return Container(
              color: Colors.black87,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  IconData iconData = Icons.question_mark;
                  Color iconColor = Colors.black;
                  Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  switch(data["type"]) {
                    case "Important":
                      iconColor = Colors.redAccent;
                      break;
                    case "Planned":
                      iconColor = Colors.orangeAccent;
                  }
                  switch(data["category"]) {
                    case "Work":
                      iconData = Icons.work;
                      break;
                    case "Personal":
                      iconData = Icons.person;
                      break;
                    case "Other":
                      iconData = Icons.question_mark;
                      break;
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (builder) => ViewToDoPage(
                          data: data,
                          id: snapshot.data!.docs[index].id,
                        )));
                      },
                      child: ToDoCard(
                        title: data["title"],
                        check: data["checked"],
                        iconData: iconData,
                        iconColor: iconColor,
                        id: snapshot.data!.docs[index].id,
                      ),
                    ),
                  );
                })
            );
          }
        },
      ),
    );
  }
}
