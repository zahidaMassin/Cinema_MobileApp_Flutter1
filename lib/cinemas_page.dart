import 'dart:convert';

import 'package:cinema_flutter/salle_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CinemasPage extends StatefulWidget {
  dynamic ville;

  CinemasPage(this.ville, {Key? key}) : super(key: key);

  @override
  _CinemasPageState createState() => _CinemasPageState();
}

class _CinemasPageState extends State<CinemasPage> {
  late List<dynamic> listCinema = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cinemas de ${widget.ville['name']}'),
        ),
        body: Center(
          child: listCinema == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: (listCinema == null) ? 0 : listCinema.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.orange,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange, shadowColor: Colors.black),
                        child: Text(listCinema[index]['name']),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>new SallePage(this.listCinema[index]))
                          );
                        },
                      ),
                    );
                  }),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCinema();
  }

  void loadCinema() {
    var url = Uri.parse(widget.ville['_links']['cinemas']['href']);
    http.get(url).then((resp) {
      setState(() {
        listCinema = json.decode(resp.body)['_embedded']['cinemas'];
      });
    }).catchError((err) {
      print(err);
    });
  }
}
