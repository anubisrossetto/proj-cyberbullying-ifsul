import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projcyberbullying/Components/Editor.dart';
import 'package:projcyberbullying/Data/User_dao.dart';
import 'package:projcyberbullying/Widgets/widget.dart';
import 'package:provider/provider.dart';

class Informacao extends StatelessWidget {
  String texto1 = "Spearmint é uma ferramenta para armazenamento de provas de " +
      "cyberbullying por meio de tecnologias distribuídas, garantindo, " +
      "assim, a impermutabilidade desses dados e seu fácil armazenamento de forma " +
      "transparente, soluciondo a burocracia que seria o seu registro convencional.";

  String texto2 =
      "Para realizar as capturas, foi criada uma extensão complementar à aplicação, " +
          " ela gera um documento PDF " +
          "contendo uma captura de tela de qualquer página da web, assim como um conjunto de dados " +
          "sobre a captura, coletados em via a validá-la.";

  String texto3 = "As provas são armazenadas em um sistema chamado IPFS, Interplanetary File System, " +
      "que, armazenando dados de forma distribuída, garante que sejam imutáveis e " +
      "sempre acessíveis, enquanto a indexação de tais dados com os usuários " +
      "é feita por meio da tecnologia Blockchain, tornando esses registros permanentes " +
      "em um sistema confiável.";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: Image.asset("assets/image/horizontalCropped.png", width: 316, height: 80,),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                RichText(
                    text: TextSpan(children: <TextSpan>[
                  generateText("Sobre o Spearmint", texto1),
                  generateText("Como Utilizá-lo", texto2),
                  generateText("Como Funciona", texto3),
                ]))
              ],
            )));
  }

  TextSpan generateText(String title, String texto) {
    return TextSpan(
        text: title,
        style: TextStyle(
            color: Colors.green, fontSize: 25, fontWeight: FontWeight.bold),
        children: <TextSpan>[
          TextSpan(
              text: "\n" + texto + "\n\n",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal))
        ]);
  }
}
