import 'package:flutter/material.dart';
import 'package:projcyberbullying/Components/item.dart';

class ListaReg extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registros"),
        centerTitle: true,

      ),

      body: Item(),
    );
  }
}

