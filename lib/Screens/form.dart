import 'package:flutter/material.dart';
import 'package:projcyberbullying/Components/Editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:projcyberbullying/Data/User_dao.dart';
import 'package:date_format/date_format.dart';

import 'package:provider/provider.dart';

class FormReg extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FormRegState();
  }
}

class FormRegState extends State<FormReg> {
  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorResumo = TextEditingController();
  final TextEditingController _controladorArquivo = TextEditingController();
  CollectionReference registros =
      FirebaseFirestore.instance.collection('registros');
  FilePickerResult result;
  bool _isLoading = false;
  String optionSelected;

  final style = const TextStyle(fontSize: 20, fontWeight: FontWeight.w200);
  bool _valida = false;

  ConvertFileToCast(data) {
    List<int> list = data.cast();
    return list;
  }

  _selecionaArquivo() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      print("name: " + file.name);
      _controladorArquivo.text = file.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

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
            Editor(_controladorTitulo, "Título", "Título", 1, _valida, 150, true),
            Editor(
                _controladorResumo,
                "Faça uma breve descrição da sua proposta",
                "Explique da melhor forma que conseguir sobre o que se trata a proposta",
                5,
                _valida,
                600, true),
            Editor(_controladorArquivo, "Arquivo", "Arquivo selecionado", 1, _valida, 150, false),
            ElevatedButton(
              onPressed: () {
                _selecionaArquivo();
              },
              child: const Text('Selecionar arquivo'),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _controladorTitulo.text.isEmpty
                          ? _valida = true
                          : _valida = false;
                      _controladorResumo.text.isEmpty
                          ? _valida = true
                          : _valida = false;
                    });
                    if (!_valida) {
                      _criar(context);
                    }
                  },
                  child: const Text("CONFIRMAR")),
            ),
            _isLoading ? LinearProgressIndicator() : Container(),
          ],
        ),
      ),
    );
  }

  void _criar(BuildContext context) async {
    var dataHora = DateTime.now().millisecondsSinceEpoch;
    final userDao = Provider.of<UserDao>(context, listen: false);
    //Adicionando um novo documento a nossa coleção

    if (result != null) {
      setState(() {
        _isLoading = true;
      });
      // aqui começa a barra progresso
      PlatformFile file = result.files.first;
      var request = http.MultipartRequest(
          "POST", Uri.parse('https://api.nft.storage/upload'));
      request.headers['accept'] = 'application/json';
      request.headers['Content-Type'] = 'image/*';
      request.headers['Authorization'] =
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweDk3Q0FBYTc3MTNDM2JmNjVkQzAzOUFhOTc2ODU1QjFlODMxZjM0ODUiLCJpc3MiOiJuZnQtc3RvcmFnZSIsImlhdCI6MTYzMTc0MTI0MzM1MiwibmFtZSI6InRlc3RlIn0.NNmiC5HnjmHhOzZvSSNlssKwn-Rscd9CWarrvXbGYo0';
      request.fields["text_field"] = "teste";

      var pic = http.MultipartFile.fromBytes('file', file.bytes,
          filename: file.name, contentType: MediaType('*', '*'));

      request.files.add(pic);
      var response = await request.send();
     var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      var dados = jsonDecode(responseString); // dynamic
      var valores = dados['value'];
      var cid = valores['cid'];
      registros.add({
        'titulo': _controladorTitulo.text,
        'Resumo': _controladorResumo.text,
        'dataHora': dataHora,
        'cid': cid,
        'userId': userDao.userId(),
        'nomeArq' : file.name
      }).then((value) {
        // finaliza a barra
        const SnackBar snackBar =
            SnackBar(content: Text("Seu registro foi realizado com sucesso! "));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError((error) => debugPrint("Ocorreu um erro: $error"));
    } else {
      final snackBar = SnackBar(
        content: const Text("Problema ao registrar documento"),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            // Some code to undo the change.
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        duration: Duration(days: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print(DateTime.now().millisecondsSinceEpoch);
      int input = 1648747120432;
      final DateTime date1 = DateTime.fromMillisecondsSinceEpoch(input);
      print(date1);
      String result1 = formatDate(date1, [dd, '/', mm, '/', yyyy]);
      print(result1);
    }
    setState(() {
      _isLoading = false;

    });

    //Limpando os campos após a criação da proposta
    _controladorTitulo.text = '';
    _controladorResumo.text = '';
    //SnackBar
  }
}
