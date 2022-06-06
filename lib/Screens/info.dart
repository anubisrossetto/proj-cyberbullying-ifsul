import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projcyberbullying/Components/Editor.dart';
import 'package:projcyberbullying/Data/User_dao.dart';
import 'package:projcyberbullying/Widgets/widget.dart';
import 'package:provider/provider.dart';

class Informacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: Text("Nome app"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'test',
                    style: TextStyle(color: Colors.green, fontSize: 25),
                  ),
                )
              ],
            )));
  }
}
