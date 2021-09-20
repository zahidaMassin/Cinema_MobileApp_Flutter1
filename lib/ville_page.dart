import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cinemas_page.dart';

class VillePage extends StatefulWidget {
  const VillePage({Key? key}) : super(key: key);

  @override
  _VillePageState createState() => _VillePageState();
}

class _VillePageState extends State<VillePage> {
  late List<dynamic> listVilles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Villes'),
        ),
        body: Center(
          child: this.listVilles == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount:
                      (this.listVilles == null) ? 0 : this.listVilles.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.orange,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange, shadowColor: Colors.black),
                        child: Text(this.listVilles[index]['name']),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> new CinemasPage(listVilles[index])));
                        },
                      ),
                    );
                  }),
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadVilles();
  }

  void loadVilles() {
    var url = Uri.parse("http://192.168.42.193:8080/villes");
    http.get(url).then((resp) {
      setState(() {
        listVilles = json.decode(resp.body)['_embedded']['villes'];
      });
    }).catchError((err) {
      print(err);
    });
  }
}
