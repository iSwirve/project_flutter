import 'package:basicpos_v2/pages/stok/memo.dart';
import 'package:basicpos_v2/pages/transaksi/laporan%20penjualan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basicpos_v2/pages/master/barang.dart';
import 'package:basicpos_v2/pages/master/brand.dart';
import 'package:basicpos_v2/pages/master/ekspedisi.dart';
import 'package:basicpos_v2/pages/master/kategori_barang.dart';
import 'package:basicpos_v2/pages/master/pelanggan.dart';
import 'package:basicpos_v2/pages/master/supplier.dart';
import 'package:basicpos_v2/pages/stok/stok.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart' as colors;

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});
  static const routeName = '/main-menu';

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class MenuList {
  String title;
  String image;

  MenuList(this.title, this.image);

  String getTitle() {
    return title;
  }

  String getImage() {
    return image;
  }
}

class _MainMenuPageState extends State<MainMenuPage> {
  List<MenuList> item = [];
  List<MenuList> search = [];

  void filterSearchResults(String query) {
    List<MenuList> dummySearchList = [];
    dummySearchList.addAll(item);
    if (query.isNotEmpty) {
      List<MenuList> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.getTitle().toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        search.clear();
        search.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        search.clear();
        search.addAll(item);
      });
    }
  }

  void adddata() {
    item.add(MenuList("Master", ""));
    item.add(MenuList("Master Supplier", "assets/icons/person.png"));
    item.add(MenuList("Master Pelanggan", "assets/icons/person.png"));
    item.add(MenuList("Master Brand", "assets/icons/box.png"));
    item.add(MenuList("Master Barang", "assets/icons/box.png"));
    item.add(MenuList("Master Kategori Barang", "assets/icons/box.png"));
    item.add(MenuList("Stok", ""));
    item.add(MenuList("Stok", "assets/icons/box.png"));
    item.add(MenuList("Memo", "assets/icons/book.png"));
    item.add(MenuList("Pembelian", ""));
    item.add(MenuList("Pembelian", "assets/icons/box.png"));
    item.add(MenuList("Retur Beli", "assets/icons/box.png"));
    item.add(MenuList("Penjualan", ""));
    item.add(MenuList("Penjualan", "assets/icons/box.png"));
    item.add(MenuList("Retur Jual", "assets/icons/box.png"));
    item.add(MenuList("Laporan", ""));
    item.add(MenuList("History Pelanggan", "assets/icons/file.png"));
    item.add(MenuList("Pendapatan", "assets/icons/file.png"));
    item.add(MenuList("Penjualan Barang", "assets/icons/file.png"));
    item.add(MenuList("Penjualan Barang Supplier", "assets/icons/file.png"));
    item.add(MenuList("Manage", ""));
    item.add(MenuList("Logout", "assets/icons/log-out.png"));
    search.addAll(item);
  }

  @override
  void initState() {
    adddata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/images/logo.png",
                width: 140,
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primaryLightest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: colors.boxShadow,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PT. Bangun Untung Lestari",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Donny",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Admin Gudang",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Container(
                  margin: EdgeInsets.only(top: 25, bottom: 2),
                  child: TextField(
                    onChanged: (value) {
                      filterSearchResults(value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(5.0),
                      hintText: 'Cari Menu',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: search.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (search[index].getImage() != "") {
                      return Container(
                        margin: EdgeInsets.only(top: 2),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent),
                          onPressed: () async {
                            if (search[index].getTitle() == "Master Supplier") {
                              if (mounted)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => supplier(),
                                  ),
                                );
                            } else if (search[index].getTitle() ==
                                "Master Pelanggan") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => pelanggan(),
                                  ));
                            } else if (search[index].getTitle() ==
                                "Master Barang") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => barang(),
                                ),
                              );
                            } else if (search[index].getTitle() ==
                                "Master Ekspedisi") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ekspedisi(),
                                ),
                              );
                            } else if (search[index].getTitle() ==
                                "Master Brand") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => brand(),
                                ),
                              );
                            } else if (search[index].getTitle() ==
                                "Master Kategori Barang") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => kategori_barang(),
                                ),
                              );
                            }  else if (search[index].getTitle() == "Stok") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => stok(),
                                ),
                              );
                            } else if (search[index].getTitle() == "Memo") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => memo(),
                                ),
                              );
                            } else if (search[index].getTitle() ==
                                "Penjualan") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => penjualan(),
                                ),
                              );
                            } else if (search[index].getTitle() == "Logout") {
                              FirebaseAuth.instance.signOut();
                            }
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                child: Image.asset(search[index].getImage()),
                                radius: 15,
                                backgroundColor:
                                    Color.fromARGB(255, 239, 248, 255),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 30,
                                child: Center(
                                  child: Text(
                                    search[index].getTitle(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        color: Colors.transparent,
                        child: Text(
                          item[index].getTitle(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}
