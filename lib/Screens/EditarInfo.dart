import 'package:flutter/material.dart';
import 'package:projcyberbullying/Components/Editor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projcyberbullying/Models/Registro.dart';
import 'package:projcyberbullying/Screens/lista.dart';
import 'package:conditional_questions/conditional_questions.dart';
import 'package:projcyberbullying/Data/User_dao.dart';
import 'package:provider/provider.dart';

class EditarFormInfo extends StatefulWidget {
  final String titulo;
  final String resumo;
  final String dataHora;

  final QueryDocumentSnapshot updateDados;

  const EditarFormInfo(
      this.titulo, this.resumo, this.dataHora, this.updateDados);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditarFormInfoState();
  }
}

class EditarFormInfoState extends State<EditarFormInfo> {
  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorResumo = TextEditingController();

  bool _valida = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    //Replacing the spaces with the information from the card -> Retornando os valores para os campos de texto
    _controladorTitulo.text = widget.titulo;
    _controladorResumo.text = widget.resumo;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Atualizar"),
        elevation: 0,
        actions: [
          SizedBox(
            width: 80,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 32),
              tooltip: 'Remover registro',
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Excluir registro'),
                        content:
                            const Text('Você deseja excluir este registro?'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              //Deleting the data from the firebase
                              debugPrint('Exclusão realizada');
                              widget.updateDados.reference.delete();

                              //Going back to the main page
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ListaReg();
                              }));

                              //SnackBar
                              const SnackBar snackBar = SnackBar(
                                  content: Text(
                                      "O registro foi excluído com sucesso! "));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            child: const Text('Sim'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              debugPrint('Operação não realizada');
                            },
                            child: const Text('Não'),
                          ),
                        ],
                      );
                    });
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Editor(_controladorTitulo, "Título", "Título", 1, _valida, 150, true),
            Editor(
                _controladorResumo,
                "Faça uma breve descrição",
                "Explique da melhor forma que conseguir sobre o que se trata o registro",
                5,
                _valida,
                600, true),


          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
              _alterar(context);
            }
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.save)),    );
  }

  void _alterar(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);

    final registro = new Registro("", _controladorTitulo.text,
        _controladorResumo.text, widget.dataHora, "", userDao.userId(), "");

    widget.updateDados.reference
        .update({
          'titulo': _controladorTitulo.text,
          'resumo': _controladorResumo.text,
        })
        .then((value) =>
            debugPrint("Seu registro foi atualizado no banco de dados"))
        .catchError(
            (error) => debugPrint("Ocorreu um erro gravar dados: $error"));

    Navigator.pop(context, registro);

    //SnackBar
    const SnackBar snackBar =
        SnackBar(content: Text("O registro foi alterado com sucesso! "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
