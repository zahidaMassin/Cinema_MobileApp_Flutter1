import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SallePage extends StatefulWidget {
  dynamic cinema;

  SallePage(this.cinema, {Key? key}) : super(key: key);

  @override
  _SallePageState createState() => _SallePageState();
}

class _SallePageState extends State<SallePage> {
  late List<dynamic> listSalle = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Salle du Cinema ${widget.cinema['name']}'),
        ),
        body: Center(
          child: listSalle == null
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: (listSalle == null) ? 0 : listSalle.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.orange,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orangeAccent,
                                  shadowColor: Colors.black),
                              child: Text(listSalle[index]['name']),
                              onPressed: () {
                                loadProjections(listSalle[index]);
                              },
                            ),
                          ),
                          if (listSalle[index]['projections'] != null)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.network(
                                    "http://192.168.42.193:8080/" +
                                        "imageFilm/${listSalle[index]['currentProjection']['film']['id']}",
                                    width: 150,
                                  ),
                                  Column(
                                    children: [
                                      ...(listSalle[index]['projections']
                                              as List<dynamic>)
                                          .map((projection) {
                                        return ElevatedButton(
                                          child: Text(
                                              "${projection['seance']['heureDebut']} (${projection['film']['duree']}, Prix=${projection['prix']})"),
                                          onPressed: () {
                                            loadTickets(
                                                projection, listSalle[index]);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              textStyle:
                                                  TextStyle(fontSize: 13),
                                              primary: (listSalle[index]['currentProjection']['id']==projection['id'])?Colors.orange:Colors.grey,
                                              shadowColor: Colors.black),
                                        );
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          if (listSalle[index]['currentProjection'] != null &&
                              listSalle[index]['currentProjection']
                                      ['listTickets'] !=
                                  null && listSalle[index]['currentProjection']['listTickets'].length > 0)
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...(listSalle[index]['currentProjection']
                                          ['listTickets'] as List<dynamic>)
                                      .map((ticket) {
                                    if(ticket['reserve']==false){
                                    return Container(
                                      width: 50,
                                      padding: EdgeInsets.all(2),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                              textStyle:
                                              TextStyle(fontSize: 10),
                                              primary: Colors.grey,
                                              shadowColor: Colors.black),
                                        child: Text("${ticket['place']['numero']}"),
                                      ),
                                    );}
                                      else{ return Container();}
                                  }),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSalle();
  }

  void loadSalle() {
    var url = Uri.parse(widget.cinema['_links']['salles']['href']);
    http.get(url).then((resp) {
      setState(() {
        listSalle = json.decode(resp.body)['_embedded']['salles'];
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadProjections(salle) {
    var url = Uri.parse(salle['_links']['projections']['href']
        .toString()
        .replaceAll("{?projection}", "?projection=p1"));
    //print(url);
    http.get(url).then((resp) {
      setState(() {
        salle['projections'] =
            json.decode(resp.body)['_embedded']['projections'];
        salle['currentProjection'] = salle['projections'][0];
      });
    }).catchError((err) {
      print(err);
    });
  }

  void loadTickets(projection, salle) {
    var url = Uri.parse(projection['_links']['tickets']['href']
        .toString()
        .replaceAll("{?projection}", "?projection=ticketProj"));
    //print(url);
    http.get(url).then((resp) {
      setState(() {
        projection['listTickets'] =
            json.decode(resp.body)['_embedded']['tickets'];
        salle['currentProjection'] = projection;
      });
    }).catchError((err) {
      print(err);
    });
  }
}
