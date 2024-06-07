import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
const request = "https://api.hgbrasil.com/finance";

void main() {
  runApp(const MaterialApp(
    home: conversor(),
    debugShowCheckedModeBanner: false,
  ));
}

class conversor extends StatefulWidget {
  const conversor({super.key});

  @override
  State<conversor> createState() => _conversorState();
}

class _conversorState extends State<conversor> {

var realController = TextEditingController();
var dolarController = TextEditingController();
var euroController = TextEditingController();
var libraController =  TextEditingController();

late double dolar;
late double euro;
late double real;
late double libra;

void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

banana(){
    IconButton(
      icon: Image.asset('img/chicao.jpg'),
       iconSize: 50,
        onPressed: () {return kiwi();},);
}

kiwi(){
              IconButton(
                icon: Image.asset('img/chico2.webp'),
                iconSize: 50,
                onPressed: () {return banana();},
                );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255,255,242,1),
      appBar: AppBar(
        title: Text("\$ Conversor Chico Moedas \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        ),
        body: 
        
        FutureBuilder(
          future: getData(),
          builder: (context,snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
              return Center(
                child: Text("Carregando...", textAlign: TextAlign.center),
              );
              default:
              if(snapshot.hasError){
                return Center(
                child: Text("Erro a carregar os dados...", textAlign: TextAlign.center),
                );
              }
              else{
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                real = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["BRL"]["buy"];
                libra = snapshot.data!["results"]["currencies"]["LBR"]["buy"];
                return SingleChildScrollView(
          child: Column(
            children: [
              IconButton(
                icon: Image.asset("img/chico2.webp"),
                iconSize: 1,
                onPressed: () {return banana();},
                ),

              SizedBox(height: 20),

              TextField(
                decoration: InputDecoration(
                  labelText: "Reais",
                  labelStyle: TextStyle(
                    color: Colors.amber,
                  ),
                  border: OutlineInputBorder(),
                  prefixText: "R\$"
                ),
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 25
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: realController,
                onChanged: (_realChanged){},
              ),

              SizedBox(height: 20),

              TextField(
                decoration: InputDecoration(
                  labelText: "Dólares",
                  labelStyle: TextStyle(
                    color: Colors.amber,
                  ),
                  border: OutlineInputBorder(),
                  prefixText: "\$"
                ),
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 25
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: dolarController,
                onChanged: (_dolarChanged){},
              ),

              SizedBox(height: 20),

              TextField(
                decoration: InputDecoration(
                  labelText: "Euro",
                  labelStyle: TextStyle(
                    color: Colors.amber,
                  ),
                  border: OutlineInputBorder(),
                  prefixText: "€"
                ),
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 25
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: euroController,
                onChanged: (_euroChanged){},
              ),

              SizedBox(height: 20),

              TextField(
                decoration: InputDecoration(
                  labelText: "Libras",
                  labelStyle: TextStyle(
                    color: Colors.amber,
                  ),
                  border: OutlineInputBorder(),
                  prefixText: "£"
                ),
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 25
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: libraController,
                onChanged: (value){},
                ),
              ]
             )
            );
              }
            }
          }
        )
          );
        } 

        Future<Map> getData() async {
          var url = Uri.parse(request);
          http.Response response = await http.get(url);
          return json.decode(response.body);
        }
      }
    