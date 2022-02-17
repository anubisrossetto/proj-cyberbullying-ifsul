import 'package:flutter/material.dart';
import 'package:projcyberbullying/Components/Editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormReg extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FormRegState();
  }
}

class FormRegState extends State<FormReg>{

  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorResumo = TextEditingController();


  String optionSelected;

  final style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);
  bool _valida = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    CollectionReference registros = FirebaseFirestore.instance.collection('registros');

    return Scaffold(
      appBar: AppBar(
          title: const Text('Formulário de Envio'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Editor(_controladorTitulo, "Título", "Título", 1, _valida, 150),
            Editor(_controladorResumo, "Faça uma breve descrição da sua proposta",
                "Explique da melhor forma que conseguir sobre o que se trata a proposta", 5, _valida, 600),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: (){
                    setState((){
                      _controladorTitulo.text.isEmpty ? _valida = true : _valida = false;
                      _controladorResumo.text.isEmpty ? _valida = true : _valida = false;
                    });
                    if(!_valida){
                       var dataHora = DateTime.now().millisecondsSinceEpoch;
                      //Adicionando um novo documento a nossa coleção
                      registros.add({
                        'titulo': _controladorTitulo.text,
                        'Resumo': _controladorResumo.text,
                        'dataHora': dataHora,
                        'cid': "",
                      })
                          .then((value) => debugPrint("Dados enviados"))
                          .catchError((error) => debugPrint("Ocorreu um erro: $error"));

                      _criar(context);
                    }

                  },
                  child: const Text("CONFIRMAR")
              ),
            ),
          ],
        ),
      ),
    );

  }

  void _criar(BuildContext context) {
    //Limpando os campos após a criação da proposta
      _controladorTitulo.text = '';
      _controladorResumo.text = '';
    //SnackBar
    const SnackBar snackBar = SnackBar(content: Text("Seu registro foi realizado com sucesso! "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}