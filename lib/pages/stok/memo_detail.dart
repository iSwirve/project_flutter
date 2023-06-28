import 'package:basicpos_v2/pages/stok/memo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:basicpos_v2/constants/colors.dart' as colors;

import '../../components/custom_text.dart';

class memo_detail extends StatefulWidget {
  final index;

  const memo_detail({super.key, this.index});
  static const routeName = '/memo_detail';

  @override
  State<memo_detail> createState() => _memo_detailState();
}

class _memo_detailState extends State<memo_detail> {
  int count = 0;
  final CollectionReference _memo = FirebaseFirestore.instance.collection('Memo');

  final CollectionReference _barang = FirebaseFirestore.instance.collection('Barang');

  getdata() async {
    QuerySnapshot qs = await _memo.get();
    final dataMemo = qs.docs.map((doc) => doc.data()).toList();
    return dataMemo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Detail barang",
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
                builder: (context) => memo(),
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<dynamic>(
        initialData: [],
        future: getdata(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.data.isEmpty || snapshot.hasError) {
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
            var judul_memo = snapshot.data[widget.index]["judul_memo"].toString();
            var nama_barang = snapshot.data[widget.index]["id_barang"].toString();
            var catatan = snapshot.data[widget.index]["catatan"].toString();
            var qty = snapshot.data[widget.index]["qty"].toString();

            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('Barang').doc('$nama_barang').snapshots(),
              builder: (context, sp) {
                var data = sp.data?.data();
                var temp = data?["nama_barang"].toString();
                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 20),
                    child: Column(
                      children: [
                        CustomText(
                          text: "Judul Memo : $judul_memo",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Nama Barang : $temp",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Catatan Memo : $catatan",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Kuantiti : $qty",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
