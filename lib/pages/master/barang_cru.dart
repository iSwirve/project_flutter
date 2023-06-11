import 'package:basicpos_v2/components/custom_dropdown.dart';
import 'package:basicpos_v2/pages/master/barang.dart';
import 'package:basicpos_v2/pages/master/pelanggan.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_text_field.dart';
import '../../constants/dimens.dart' as dimens;
import '../../components/custom_button.dart';
import 'package:flutter/material.dart';

class barang_cru extends StatefulWidget {
  final edit;
  int? index;

  barang_cru({super.key, this.edit, this.index});

  static const routeName = '/barang';

  @override
  State<barang_cru> createState() => _barang_cruState();
}

class _barang_cruState extends State<barang_cru> {
  TextEditingController nama = TextEditingController();
  TextEditingController kode = TextEditingController();
  SingleValueDropDownController? brand;
  SingleValueDropDownController? kategori_barang;
  TextEditingController nomor_seri = TextEditingController();
  TextEditingController tipe_mobil = TextEditingController();
  TextEditingController kode_supplier = TextEditingController();
  TextEditingController stok_minimum = TextEditingController();
  TextEditingController satuan = TextEditingController();
  TextEditingController isi_per_karton = TextEditingController();
  TextEditingController satuan_karton = TextEditingController();
  TextEditingController harga_beli = TextEditingController();
  TextEditingController harga_jual = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  Map<dynamic, dynamic> BrandData = {};
  Map<dynamic, dynamic> KategoriData = {};
  var listBrand = [];
  var title = "Tambah";

  // getdata() async {
  // try {
  //   BrandData.clear();
  //   KategoriData.clear();

  //   dynbrand["data"].forEach((element) {
  //     BrandData[element["id"]] = '${element["name"]}';
  //   });
  //   dynkategori["data"].forEach((element) {
  //     KategoriData[element["id"]] = '${element["name"]}';
  //   });

  //   if (title == "Edit") {
  //     var id = widget.index;
  //     var response = await ApiHelper.get(url.barang + '/$id');
  //     return response["data"];
  //   }
  // } catch (e) {
  //   return [];
  // }
  // }

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Brand');
  CollectionReference _collectionRef2 =
  FirebaseFirestore.instance.collection('Kategori');

  getdata() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    QuerySnapshot querySnapshot2 = await _collectionRef2.get();

    // Get data from docs and convert map to List
    // print(querySnapshot.docs[0].toString());
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    // print(allData);
    // print(querySnapshot.docs[0].id);
    var ctr = 0;
    print(querySnapshot.docs[0]["name"]);

    querySnapshot.docs.forEach((element) {

      BrandData[element.id] = querySnapshot.docs[ctr]["name"].toString();
      ctr++;
    });
ctr = 0;
    querySnapshot2.docs.forEach((element) {

      KategoriData[element.id] = querySnapshot2.docs[ctr]["name"].toString();
      ctr++;
    });
    // Map<String, dynamic>.from(querySnapshot.value as Map);
    // print(allData[0].runtimeType);


    return allData;
  }

  @override
  void initState() {
    super.initState();
    if (widget.edit == true) {
      title = "Edit";
    }
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Master Barang - $title",
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
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: dimens.pagePadding,
        ),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<dynamic>(
                initialData: {},
                future: getdata(),
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data.isEmpty ||
                      snapshot.hasError) {
                    if (snapshot.data == {}) {
                      return Container();
                    } else {
                      if (title == "Edit") {
                        return Container(
                          height: MediaQuery.of(context).size.height - 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    }
                  } else {
                    if (title == "Edit") {
                      nama.text = snapshot.data["name"] ?? '-';
                      kode.text = snapshot.data["code"] ?? '-';
                      kode_supplier.text =
                          snapshot.data["supplier_code"] ?? '-';
                      stok_minimum.text =
                          (snapshot.data["min_stock"] ?? 0).toString();
                      satuan.text = snapshot.data["unit"] ?? "-";
                      isi_per_karton.text =
                          (snapshot.data["box_qty"] ?? 0).toString();
                      print(isi_per_karton.toString());
                      satuan_karton.text = snapshot.data["box_unit"] ?? "-";
                      harga_beli.text =
                          (snapshot.data["purchase_price"] ?? 0).toString();
                      harga_jual.text =
                          (snapshot.data["sales_price"] ?? 0).toString();
                      keterangan.text = snapshot.data["notes"] ?? "-";
                    }
                  }
                  return SingleChildScrollView(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            text_controller: nama,
                            hintText: "Nama",
                            title: "Nama",
                          ),
                          CustomTextField(
                            text_controller: kode,
                            hintText: "Kode",
                            title: "Kode",
                          ),
                          CustomDropdown(
                            title: "Brand",
                            list: BrandData,
                            controller: brand = SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Brand",
                                value: "Brand",
                              ),
                            ),
                          ),
                          CustomDropdown(
                            title: "Kategori Barang",
                            list: KategoriData,
                            controller: kategori_barang =
                                SingleValueDropDownController(
                              data: DropDownValueModel(
                                name: "Kategori Barang",
                                value: "Kategori Barang",
                              ),
                            ),
                          ),
                          CustomTextField(
                            text_controller: nomor_seri,
                            hintText: "Nomor Seri",
                            title: "Nomor Seri",
                          ),
                          CustomTextField(
                            text_controller: tipe_mobil,
                            hintText: "Tipe Mobil",
                            title: "Tipe Mobil",
                          ),
                          CustomTextField(
                            text_controller: kode_supplier,
                            hintText: "Kode Supplier",
                            title: "Kode Supplier",
                          ),
                          CustomTextField(
                            text_controller: stok_minimum,
                            hintText: "Stok Minimum",
                            title: "Stok Minimum",
                          ),
                          CustomTextField(
                            text_controller: satuan,
                            hintText: "Satuan",
                            title: "Satuan",
                          ),
                          CustomTextField(
                            text_controller: harga_beli,
                            hintText: "Harga Beli",
                            title: "Harga Beli",
                          ),
                          CustomTextField(
                            text_controller: harga_jual,
                            hintText: "Harga Jual",
                            title: "Harga Jual",
                          ),
                          CustomTextField(
                            custom_maxline_size: 3,
                            text_controller: keterangan,
                            hintText: "Keterangan",
                            title: "Keterangan",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            CustomButton(
              text: title,
              onPressed: () async {
                int boxqty = 0,
                    purchase_price = 0,
                    sales_price = 0,
                    min_stok = 0;
                try {
                  boxqty = int.parse(isi_per_karton.text.toString());
                  purchase_price = int.parse(harga_beli.text.toString());
                  sales_price = int.parse(harga_jual.text.toString());
                  min_stok = int.parse(stok_minimum.text.toString());
                } catch (e) {
                  print(e.toString());
                }
                Map<dynamic, dynamic>? body;
                body = {
                  'brand_id': int.tryParse(
                    brand!.dropDownValue!.value.toString(),
                  ),
                  'product_category_id': int.tryParse(
                    kategori_barang!.dropDownValue!.value.toString(),
                  ),
                  'code': kode.text.toString(),
                  'name': nama.text.toString(),
                  'unit': satuan.text.toString(),
                  'box_qty': boxqty,
                  'box_unit': satuan_karton.text.toString(),
                  'purchase_price': purchase_price,
                  'sales_price': sales_price,
                  'supplier_code': kode_supplier.text.toString(),
                  'notes': keterangan.text.toString(),
                  'min_stock': min_stok,
                };

                if (title == "Tambah") {
                  Fluttertoast.showToast(msg: "Sukses Insert");
                } else {
                  Fluttertoast.showToast(msg: "Sukses update");
                }
              },
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
