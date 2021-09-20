import 'package:cinema_flutter/menu_item.dart';
import 'package:cinema_flutter/setting_page.dart';
import 'package:cinema_flutter/ville_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.orange),
      ),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinema'),
      ),
      body: const Center(
        child: Text("Home cinema ..."),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage("./images/batman-icon.png"),
                  radius: 40,
                ),
              ),
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.white, Colors.orange])),
            ),
            MenuItem('Home', Icon(Icons.home), (context) {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VillePage()));
            }),
            const Divider(
              color: Colors.orange,
            ),
            MenuItem('Setting', Icon(Icons.settings), (context) {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
            }),
            const Divider(
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
