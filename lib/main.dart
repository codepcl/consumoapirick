import 'dart:convert';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ));

// Configure StatefulWidget
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('https://rickandmortyapi.com/api/character/1,2,3,4,5,6,7,8,9,10,11,12,13,14'));

    if (response.statusCode == 200) {
      print("Respuesta OK");
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      print("Error en la solicitud HTTP: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      title: "Bienvenido a Flutter",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Rick y Morty"),
        ),
        body: Center(
          child: data.isEmpty ? CircularProgressIndicator()
          : ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index]['name']),
                subtitle: Text(data[index]['status']),
                leading: CircleAvatar(
                  child: Image.network(data[index]['image']),
                ),
              );
            },
          )
        ),
      ),
    );
  }
}


