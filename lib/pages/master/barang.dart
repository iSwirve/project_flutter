import 'package:basicpos_v2/components/custom_text_field.dart';
import 'package:basicpos_v2/pages/main_menu.dart';
import 'package:basicpos_v2/pages/master/barang_cru.dart';
import 'package:basicpos_v2/pages/master/barang_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/dimens.dart' as dimens;
import '../../constants/colors.dart' as colors;

class barang extends StatefulWidget {
  const barang({super.key});

  @override
  State<barang> createState() => _barangState();
}

class _barangState extends State<barang> {
  var count = 0;
  final CollectionReference _barang =
      FirebaseFirestore.instance.collection('Barang');

  getdata() async {
    QuerySnapshot querySnapshot = await _barang.get();
    final data = querySnapshot.docs.map((doc) => doc.data()).toList();
    return data;
  }

  getId(int index) async {
    QuerySnapshot querySnapshot = await _barang.get();
    return querySnapshot.docs[index].id;
  }

  // getdata() async {
  //   QuerySnapshot querySnapshot = await _collectionRef.get();
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   print(allData);
  //   print(querySnapshot.docs[0].id);

  //   return allData;
  // }

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
          "Master Barang",
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
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: dimens.pagePadding,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "Nama Barang",
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  SizedBox(width: 6),
                  Container(
                    width: 49,
                    height: 49,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: colors.secondaryLightest,
                      ),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          backgroundColor: Colors.transparent,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.98,
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 4,
                                    margin: EdgeInsets.only(top: 20),
                                    child: TextButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 122, 126, 128),
                                      ),
                                      child: const Text(''),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20, left: 20),
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Filter",
                                          style: TextStyle(
                                            color: colors.textPrimary,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 31),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Image.asset(
                        "assets/icons/filter.png",
                        color: colors.secondary,
                      ),
                    ),
                  ),
                ],
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
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var name =
                              snapshot.data[index]["nama_barang"].toString();
                          var ava =
                              name.toString().substring(0, 1).toUpperCase();
                          return GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      barang_detail(index: index),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Text(
                                    ava,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
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
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 20),
        child: FloatingActionButton(
          onPressed: (() async => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => barang_cru(
                      edit: false,
                    ),
                  ),
                ),
              }),
          child: const Icon(Icons.add),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Color.fromARGB(255, 253, 133, 58),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
