import 'package:basicpos_v2/pages/master/barang.dart';
import 'package:basicpos_v2/pages/master/barang_cru.dart';
import 'package:basicpos_v2/pages/master/brand.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;

class barang_detail extends StatefulWidget {
  final index;
  const barang_detail({super.key, this.index});

  @override
  State<barang_detail> createState() => _barang_detailState();
}

class _barang_detailState extends State<barang_detail> {
  final CollectionReference _barang =
      FirebaseFirestore.instance.collection('Barang');
  int count = 0;
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
                              fontWeight: FontWeight.w600),
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
                          backgroundColor: Color.fromARGB(255, 24, 72, 169),
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
                          var id = widget.index;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => barang(),
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

  getdata() async {
    var id = widget.index;
    QuerySnapshot querySnapshot = await _barang.where("nama_barang",isEqualTo: id).get();
    final datas = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(id);
    return datas;
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
                builder: (context) => barang(),
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        left: true,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FutureBuilder<dynamic>(
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
                var nama_barang = snapshot.data[0]["nama_barang"].toString();
                var brand = snapshot.data[0]["brand"].toString();
                var kategori_barang = snapshot.data[0]["kategori_barang"].toString();
                var kode_barang = snapshot.data[0]["kode_barang"].toString();
                var nomor_seri = snapshot.data[0]["nomor_seri"].toString();
                var harga_beli = snapshot.data[0]["harga_beli"].toString();
                var harga_jual = snapshot.data[0]["harga_jual"].toString();
                var stok_minimum = snapshot.data[0]["stok_minimum"].toString();
                // var statuspkp = "tidak";
                // var brandtext = " - ";
                // if (snapshot.data["taxpayer"] == 1) statuspkp = "ya";
                // try {
                //   brandtext = snapshot.data["brand"]["name"];
                // } catch (e) {
                //   brandtext = " - ";
                // }
                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 20),
                    child: Column(children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 7),
                        child: Text(
                          nama_barang,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 7),
                        child: Text(
                          brand,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 7),
                        child: Text(
                          kategori_barang,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 7),
                        child: Text(
                          kode_barang,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 7),
                        child: Text(
                          nomor_seri,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 7),
                        child: Text(
                          harga_beli,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 7),
                        child: Text(
                          harga_jual,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 7),
                        child: Text(
                          stok_minimum,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              }
            },
          ),
        ),
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
        openWithTap: true, // Open Focused-Menu on Tap rather than Long Press
        menuOffset:
            10.0, // Offset value to show menuItem from the selected item
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
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                    ),
                    child: ImageIcon(
                        size: 36, AssetImage("assets/icons/trash.png")),
                  ),
                ],
              ),
              onPressed: () {
                _showMyDialog();
              }),
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
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                    ),
                    child: ImageIcon(
                        size: 36, AssetImage("assets/icons/edit.png")),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => barang_cru(
                      edit: true,
                      index: widget.index,
                    ),
                  ),
                );
              }),
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
                      color: Color.fromARGB(71, 0, 0, 0),
                      offset: new Offset(5.0, 5.0),
                      blurRadius: 5.0,
                    )
                  ],
                  color: Color.fromARGB(255, 253, 133, 58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            )),
      ),
      backgroundColor: Colors.white,
    );
  }
}
