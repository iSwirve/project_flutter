import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:basicpos_v2/pages/main_menu.dart';
import 'package:basicpos_v2/pages/master/brand_cru.dart';
import 'package:basicpos_v2/pages/master/brand_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class brand extends StatefulWidget {
  const brand({super.key});

  @override
  State<brand> createState() => _brandState();
}

class _brandState extends State<brand> {
  var count = 0;
  CollectionReference _collectionRef = FirebaseFirestore.instance.collection('Brand');
  getdata() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
    print(querySnapshot.docs[0].id);

    return allData;
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Master Brand",
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
                    color: Color.fromARGB(255, 208, 213, 221),
                    width: 1,
                  ),
                ),
                shadowColor: Color.fromARGB(255, 102, 112, 133),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Nama brand',
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
                        var name = snapshot.data[index]["name"].toString();
                        // var id = snapshot.data.;
                        print("hi " + name);
                        var ava = name.toString()[0];
                        return GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => brand_detail(index: snapshot.data.docs[0].id),
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
                                backgroundColor:
                                    Color.fromARGB(255, 239, 248, 255),
                              ),
                              Container(
                                height: 56,
                                color: Colors.white,
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 52, 64, 84),
                                  ),
                                ),
                                padding: EdgeInsets.only(top: 18, left: 15),
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
      floatingActionButton: Container(
        width: 48,
        height: 48,
        margin: const EdgeInsets.only(bottom: 40, right: 20),
        child: FloatingActionButton(
          onPressed: () async => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => brand_cru(
                  edit: false,
                ),
              ),
            ),
          },
          child: const Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Color.fromARGB(255, 253, 133, 58),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
