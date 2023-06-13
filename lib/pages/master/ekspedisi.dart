import 'package:basicpos_v2/pages/main_menu.dart';
import 'package:basicpos_v2/pages/master/ekspedisi_cru.dart';
import 'package:basicpos_v2/pages/master/ekspedisi_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;

class ekspedisi extends StatefulWidget {
  const ekspedisi({super.key});

  @override
  State<ekspedisi> createState() => _ekspedisiState();
}

class _ekspedisiState extends State<ekspedisi> {
    final CollectionReference _ekspedisi =
      FirebaseFirestore.instance.collection('Ekspedisi');
  int count = 0;
  getdata() async {
    QuerySnapshot querySnapshot = await _ekspedisi.get();
    final data = querySnapshot.docs.map((doc) => doc.data()).toList();
    return data;
  }
  getId(int index) async {
    QuerySnapshot querySnapshot = await _ekspedisi.get();
    return querySnapshot.docs[index].id;
  }
  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Master Ekspedisi",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainMenuPage(),
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 44,
                child: Material(
                  elevation: 0.1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 208, 213, 221), width: 1),
                  ),
                  shadowColor: Color.fromARGB(255, 102, 112, 133),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                      hintText: 'Nama Ekpedisi',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder<dynamic>(
                initialData: [],
                future: getdata(), // Run check for a single queryRow
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data.isEmpty ||
                      snapshot.hasError) {
                    if (count > 0) {
                      count = 0;
                      return Container();
                    } else {
                      return Container(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 27),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var name = snapshot.data[index]["nama"].toString();
                          var ava = name.toString().substring(0, 1);
                          return GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ekspedisi_detail(index: index),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Text(
                                    ava,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  radius: 20,
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    239,
                                    248,
                                    255,
                                  ),
                                ),
                                Container(
                                  height: 56,
                                  color: Colors.white,
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 52, 64, 84)),
                                  ),
                                  padding: EdgeInsets.only(
                                    top: 18,
                                    left: 15,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 20),
        child: FloatingActionButton(
          onPressed: () async => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ekspedisi_cru(
                  edit: false,
                ),
              ),
            ),
          },
          child: const Icon(Icons.add),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Color.fromARGB(255, 253, 133, 58),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
