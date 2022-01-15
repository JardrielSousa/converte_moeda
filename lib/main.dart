import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=14f488e9";

void main() async {
  print(await getData());
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeState(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class HomeState extends StatefulWidget {
  const HomeState({Key? key}) : super(key: key);

  @override
  _HomeStateState createState() => _HomeStateState();
}

class _HomeStateState extends State<HomeState> {
  double dolar = 0.0 ;
  double euro = 0.0;
  final realController = TextEditingController();
  final euroController = TextEditingController();
  final dolarController = TextEditingController();

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    if(text == "." || text == ","){
      final snackBar =  SnackBar(
        content: const Text('Retorno Inválido!Digite novamente!'),
        action: SnackBarAction(
          label: 'X',
          onPressed: () {
            // Some code to undo the change.
          },
        ),

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    if(text == "." || text == ","){
      final snackBar =  SnackBar(
        content: const Text('Retorno Inválido!Digite novamente!'),
        action: SnackBarAction(
          label: 'X',
          onPressed: () {
            // Some code to undo the change.
          },
        ),

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar*this.dolar).toStringAsFixed(2);
    euroController.text = (dolar *this.dolar/euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    if(text == "." || text == ","){
        final snackBar =  SnackBar(
          content: const Text('Retorno Inválido!Digite novamente!'),
          action: SnackBarAction(
            label: 'X',
            onPressed: () {
              // Some code to undo the change.
            },
          ),

        );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro) / dolar).toStringAsFixed(2);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$ Converte moeda \$'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder:
              (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Center(
                  child: Text("carregando dados...",
                    style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if(snapshot.hasError){
                  return const Center(
                    child: Text("Erro ao carregar dados...",
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }else{
                    dolar = snapshot.data?["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data?["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children:  <Widget>[
                        Icon(Icons.monetization_on,size: 150.0,color: Colors.amber),
                        buildTextfield("Reais", "R\$",realController,_realChanged),
                        Divider(),
                        buildTextfield("Dólares", "US\$",dolarController,_dolarChanged),
                        Divider(),
                        buildTextfield("Euros", "EUR\€",euroController,_euroChanged),
                      ],
                    ),
                  );
                }
            }
          }
          ),
    );
  }
}
Widget buildTextfield(String label,String prefix,TextEditingController controller, Function f){
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color:Colors.amber),
        border:  OutlineInputBorder(),
        prefixText: prefix
    ),
    style:  TextStyle(
        color: Colors.amber,
        fontSize: 25.0
    ),
    onChanged:(value){
      if(value != null){
        f(value);
      }
    },
    keyboardType: TextInputType.numberWithOptions(decimal:true),
  );
}