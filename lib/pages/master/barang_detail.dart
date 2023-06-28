import 'package:basicpos_v2/pages/master/barang.dart';
import 'package:basicpos_v2/pages/master/barang_cru.dart';
import 'package:basicpos_v2/pages/master/brand.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:basicpos_v2/constants/colors.dart' as colors;
import 'package:basicpos_v2/components/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';

class barang_detail extends StatefulWidget {
  final index;

  const barang_detail({super.key, this.index});

  @override
  State<barang_detail> createState() => _barang_detailState();
}

class _barang_detailState extends State<barang_detail> {
  int count = 0;
  final _db = FirebaseFirestore.instance;

  Future<void> _delete(String productId) async {
    await _barang.doc(productId).delete();
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

  var brandIDku;
  Future<void> getdata2(String brandID) async {
    var collection = FirebaseFirestore.instance.collection('Brand');
    var docSnapshot = await collection.doc(brandID).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var value = data?['name']; // <-- The value you want to retrieve.
      brandIDku = value;
    }
  }

  final CollectionReference _brand = FirebaseFirestore.instance.collection('Brand');
  final CollectionReference _barang = FirebaseFirestore.instance.collection('Barang');
  final CollectionReference _kategori = FirebaseFirestore.instance.collection('Kategori');
  Map<dynamic, dynamic> brands = new Map();
  Map<dynamic, dynamic> kategoris = new Map();

  getdata() async {
    QuerySnapshot querySnapshot = await _barang.get();
    final datas = querySnapshot.docs.map((doc) => doc.data()).toList();
    QuerySnapshot qs = await _brand.get();
    final dataBrand = qs.docs.map((doc) => doc.data()).toList();

    QuerySnapshot qs2 = await _kategori.get();
    final dataKat = qs2.docs.map((doc) => doc.data()).toList();
    var ctr = 0;
    qs.docs.forEach((element) {
      brands[element.reference.id] = element["name"];
      ctr++;
    });
    qs2.docs.forEach((element) {
      kategoris[element.reference.id] = element["name"];
      ctr++;
    });

    return [datas, dataBrand, dataKat];
  }

  getId(int index) async {
    QuerySnapshot querySnapshot = await _barang.get();
    return querySnapshot.docs[index].id;
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
      body: FutureBuilder<dynamic>(
        initialData: [],
        future: getdata(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.data.isEmpty || snapshot.hasError) {
            return Container(
              height: MediaQuery.of(context).size.height - 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            var nama_barang = snapshot.data[0][widget.index]["nama_barang"].toString();
            var brand = brands[snapshot.data[0][widget.index]["brand"].toString()];
            var kategori_barang = kategoris[snapshot.data[0][widget.index]["kategori_barang"].toString()];
            var kode_supplier = snapshot.data[0][widget.index]["kode_supplier"].toString();
            var harga_beli = snapshot.data[0][widget.index]["harga_beli"].toString();
            var harga_jual = snapshot.data[0][widget.index]["harga_jual"].toString();
            var stok_minimum = snapshot.data[0][widget.index]["stok_minimum"].toString();
            var keterangan = snapshot.data[0][widget.index]["keterangan"].toString();

            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('Supplier').doc('$kode_supplier').snapshots(),
              builder: (context, snap) {
                var data = snap.data?.data();
                var nama_supplier = data?["nama_supplier"];
                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 20),
                    child: Column(
                      children: [
                        CustomText(
                          text: "Kategori Barang : $kategori_barang",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Supplier : $nama_supplier",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Brand : $brand",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Harga beli : $harga_beli",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Harga jual : $harga_jual",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Stok minimum : $stok_minimum",
                          textStyle: TextStyle(fontSize: 12),
                          sizedBox: SizedBox(height: 5),
                        ),
                        CustomText(
                          text: "Keterangan : $keterangan",
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
      floatingActionButton: FocusedMenuHolder(
        menuWidth: 135,
        blurSize: 5.0,
        menuItemExtent: 50,
        menuBoxDecoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        duration: Duration(milliseconds: 100),
        animateMenuItems: true,
        blurBackgroundColor: Color.fromARGB(127, 29, 41, 57),
        openWithTap: true,
        menuOffset: 10.0,
        bottomOffsetHeight: 80.0,
        menuItems: <FocusedMenuItem>[
          FocusedMenuItem(
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, top: 4, bottom: 4, right: 10),
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
                  padding: EdgeInsets.only(left: 10, top: 4, bottom: 4, right: 10),
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
                  builder: (context) => barang_cru(
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
