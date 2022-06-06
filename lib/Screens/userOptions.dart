import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projcyberbullying/Data/User_dao.dart';
import 'package:projcyberbullying/Screens/My_Profile.dart';
import 'package:projcyberbullying/Screens/lista.dart';
import 'package:projcyberbullying/Screens/info.dart';
import 'package:provider/provider.dart';

class MoreOptions extends StatelessWidget {
  final styleTextTitle =
      const TextStyle(fontSize: 23, fontWeight: FontWeight.bold);

  UserDao userDao;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    userDao = Provider.of<UserDao>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text("Nome app"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Mais Serviços',
                style: GoogleFonts.quicksand(textStyle: styleTextTitle),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Options(Icons.person_pin_rounded, 'Meu Perfil',
                      'Visualize seus dados cadastrados', () {
                    debugPrint('Meus dados');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MyProfile();
                    }));
                  }, Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 10),
                  Options(Icons.feedback_outlined, 'Mais Informações',
                      'Consulte mais informações de como funciona o registro',
                      () {
                    debugPrint("Página retorno");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Informacao();
                    }));
                  }, Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 10),
                  Options(Icons.list, 'Meus Registros',
                      'Visualize seus registros de provas', () {
                    debugPrint("Página Lista");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ListaReg();
                    }));
                  }, Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 10),
                  Options(Icons.logout, 'Sair',
                      'Desconectar sua conta desse aparelho', () {
                    debugPrint("Usuário saiu");
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Sair'),
                            content: const Text(
                                'Tem certeza que deseja desconectar sua conta desse aparelho?'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  debugPrint('O usuário saiu do app');
                                  Navigator.of(context).pop();
                                  userDao.logout();
                                },
                                child: const Text('SIM'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('CANCELAR'),
                              ),
                            ],
                          );
                        });
                  }, Colors.redAccent)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Options extends StatelessWidget {
  final IconData icone;
  final String title;
  final String subtitle;
  final Function onTap;
  final Color color;

  const Options(this.icone, this.title, this.subtitle, this.onTap, this.color);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
        leading: Icon(icone, size: 50, color: color),
        title: Text(title,
            style: GoogleFonts.quicksand(
                textStyle: const TextStyle(fontWeight: FontWeight.bold))),
        subtitle: Text(subtitle,
            style: GoogleFonts.quicksand(
                textStyle: const TextStyle(fontWeight: FontWeight.bold))),
        onTap: onTap);
  }
}
