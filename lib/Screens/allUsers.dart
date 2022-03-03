import 'package:flutter/material.dart';
import 'package:projcyberbullying/Screens/form.dart';
import 'package:projcyberbullying/Screens/userOptions.dart';

class AllUsersHomePage extends StatefulWidget{

  @override
  State<AllUsersHomePage> createState() => _AllUsersHomePageState();
}

class _AllUsersHomePageState extends State<AllUsersHomePage> {

  int paginaAtual = 0; // página inicial
  PageController pc;// comentário teste


  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          FormReg(),
          MoreOptions(),
        ],
        onPageChanged: setPaginaAtual,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
          items: const [
              BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Formulário'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: 'Mais')
          ],
          onTap: (pagina) {
          pc.animateToPage(pagina, duration: const Duration(milliseconds: 400), curve: Curves.ease);
    },
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}
