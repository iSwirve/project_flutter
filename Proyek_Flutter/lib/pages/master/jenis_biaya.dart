import 'package:basicpos_v2/pages/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:basicpos_v2/constants/urls.dart' as url;

class jenis_biaya extends StatefulWidget {
  const jenis_biaya({super.key});

  @override
  State<jenis_biaya> createState() => _jenis_biayaState();
}

class _jenis_biayaState extends State<jenis_biaya> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Master Jenis Biaya",
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
                      hintText: 'Nama Jenis Biaya',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 20),
        child: FloatingActionButton(
          onPressed: () async => {},
          child: const Icon(Icons.add),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Color.fromARGB(255, 253, 133, 58),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
