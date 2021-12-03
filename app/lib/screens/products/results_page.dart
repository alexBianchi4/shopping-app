// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers, dead_code, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> urls = [];
String categoryGlobal = "";
bool wasSearched = false;

class ResultsWidget extends StatefulWidget {
  ResultsWidget(String category, bool search) {
    categoryGlobal = category;
    wasSearched = search;
  }

  @override
  _ResultsWidgetState createState() => _ResultsWidgetState();
}

class _ResultsWidgetState extends State<ResultsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/EBay_logo.svg/1920px-EBay_logo.svg.png',
              width: 100,
            )
          ],
        ),
        bottom: PreferredSize(
            child: Container(
                padding: EdgeInsets.only(bottom: 7),
                height: 40,
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                          onPressed: () {}, icon: Icon(Icons.search)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40))),
                )),
            preferredSize: Size.fromHeight(30)),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.sort))
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
          child: StreamBuilder(
              stream: wasSearched
                  ? FirebaseFirestore.instance
                      .collection("listing")
                      .where("search_cases", arrayContains: categoryGlobal)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("listing")
                      .where("tag", isEqualTo: categoryGlobal)
                      .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return ListView.separated(
                    itemCount: snapshot.data.docs.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 25);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      var docData = snapshot.data.docs[index].data();
                      var docId = snapshot.data.docs[index].id;
                      return GestureDetector(
                          onTap: () {},
                          child: Container(
                              height: 120,
                              child: Row(
                                children: [
                                  Container(
                                      width: 130,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            // Radius.circular(20)),
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            // topRight: Radius.circular(20),
                                            // bottomRight: Radius.circular(20)
                                          ),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  NetworkImage(docData["url"])))
                                      // color: theme_colour
                                      ,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Text(
                                            //   docData['"title'],
                                            //   style: TextStyle(
                                            //     fontSize: 15,
                                            //     color: Colors.white,
                                            //   ),
                                            // )
                                          ])),
                                  Expanded(
                                      child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.blue[200],
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(docData['title']),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Text(docData['price'].toString())
                                      ],
                                    ),
                                  )),
                                ],
                              )));
                    });
              })),
      backgroundColor: Colors.blue[50],
    );
  }
}
