import 'package:basicpos_v2/pages/transaksi/pembelian/pembelian.dart';
import 'package:basicpos_v2/pages/transaksi/pembelian/pembelian_cru.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:basicpos_v2/constants/colors.dart' as colors;
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import '../../../components/custom_text.dart';
import '../../../constants/urls.dart';

class pembelian_detail extends StatefulWidget {
    final index;
  const pembelian_detail({super.key, this.index});

  @override
  State<pembelian_detail> createState() => _pembelian_detailState();
}

class _pembelian_detailState extends State<pembelian_detail> {
    int count = 0;
  final CollectionReference _pembelian =
      FirebaseFirestore.instance.collection('Pembelian');

  final CollectionReference _barang =
      FirebaseFirestore.instance.collection('Barang');

  final CollectionReference _supplier =
      FirebaseFirestore.instance.collection('Supplier');
  Map<dynamic, dynamic> barang = new Map();
  Map<dynamic, dynamic> supplier = new Map();

  getdata() async {
    QuerySnapshot querySnapshot = await _pembelian.get();

    final datas = querySnapshot.docs.map((doc) => doc.data()).toList();
    return datas;
  }
  getId(int index) async {
    QuerySnapshot querySnapshot = await _pembelian.get();
    return querySnapshot.docs[index].id;
  }

  
    Future<void> _delete(String productId) async {
    await _pembelian.doc(productId).delete();
  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            icon: Container(
              width: 120,
              height: 120,
              child: Image.asset("assets/images/TrashAlert.png"),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                    'Hapus Data',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Apakah anda yakin ingin menghapus data ini?',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 108,
                      height: 36,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 239, 248, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Tidak',
                          style: TextStyle(
                            color: Color.fromARGB(255, 24, 72, 169),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Container(
                      width: 108,
                      height: 36,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: colors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Ya',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () async {
                          var id = await getId(widget.index);
                          _delete(id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => pembelian(),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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
                builder: (context) => pembelian(),
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
            var status = "";
            var kode_barang =
                snapshot.data[widget.index]["id_barang"].toString();
            var kode_supplier =
                snapshot.data[widget.index]["id_supplier"].toString();
            var tanggal =
                snapshot.data[widget.index]["tanggal"].toString();
            var tanggal_tempo =
                snapshot.data[widget.index]["tanggal_tempo"].toString();
            var tanggal_terima =
                snapshot.data[widget.index]["tanggal_terima"].toString();
            var status_temp =
                snapshot.data[widget.index]["status_ppn"].toString();
            if(status_temp == "0"){
              status = "Tidak Aktif";
            }else{
              status = "Aktif";
            }

            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Supplier')
                  .doc('$kode_supplier')
                  .snapshots(),
              builder: (context, snap) {
                var data = snap.data?.data();
                var nama_supplier = data?["nama_supplier"];
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Barang')
                  .doc('$kode_barang')
                  .snapshots(),
              builder: (context, snapy) {
                var datas = snapy.data?.data();
                var nama_barang = datas?["nama_barang"];
                print("$nama_barang");
                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 20),
                    child: Column(
                      children: [
                        CustomText(
                          text: "Kode Barang : $kode_barang",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Nama Barang : $nama_barang",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Supplier : $nama_supplier",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "status PPN : $status",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Tanggal beli : $tanggal",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Tanggal Jatuh Tempo  : $tanggal_tempo",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Tanggal Terima: $tanggal_terima",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
              },
            );
          }
        },
      ),
      floatingActionButton: FocusedMenuHolder(
        menuWidth: 135,
        blurSize: 5.0,
        menuItemExtent: 50,
        menuBoxDecoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        duration: Duration(milliseconds: 100),
        animateMenuItems: true,
        blurBackgroundColor: Color.fromARGB(127, 29, 41, 57),
        openWithTap: true,
        // Open Focused-Menu on Tap rather than Long Press
        menuOffset: 10.0,
        // Offset value to show menuItem from the selected item
        bottomOffsetHeight: 80.0,
        menuItems: <FocusedMenuItem>[
          FocusedMenuItem(
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 10, top: 4, bottom: 4, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Text(
                    "Hapus",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                  ),
                  child: ImageIcon(
                    size: 36,
                    AssetImage("assets/icons/trash.png"),
                  ),
                ),
              ],
            ),
            onPressed: () {
              _showMyDialog();
            },
          ),
          FocusedMenuItem(
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 10, top: 4, bottom: 4, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Text(
                    " Ubah ",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                  ),
                  child: ImageIcon(
                    size: 36,
                    AssetImage("assets/icons/edit.png"),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => pembelian_cru(
                    edit: true,
                    index: widget.index,
                  ),
                ),
              );
            },
          ),
        ],
        onPressed: () {},
        child: Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.only(bottom: 40, right: 20),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: ShapeDecoration(
                shadows: [
                  BoxShadow(
                    color: colors.textPrimary,
                    offset: new Offset(5.0, 5.0),
                    blurRadius: 5.0,
                  )
                ],
                color: colors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}