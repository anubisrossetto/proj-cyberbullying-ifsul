import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projcyberbullying/Components/Editor.dart';
import 'package:projcyberbullying/Data/User_dao.dart';
import 'package:projcyberbullying/Widgets/widget.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatelessWidget {
  UserDao userDao;

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _newPasswordController = TextEditingController();

  final styleText = const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);

  final styleTextTitle =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  bool _valida = false;

  String title = "Editar Informações";
  String textActionButton = "Salvar";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    userDao = Provider.of<UserDao>(context, listen: false);
    _emailController.text = userDao.email();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(45),
              child: Text(
                title,
                style: GoogleFonts.cabin(textStyle: styleTextTitle),
              ),
            ),

            //We are calling the EditorLogin to give our password and email
            EditorLogin(_emailController, 'Email', 'Email',
                const Icon(Icons.email_outlined), _valida, 25, false, false),

            const SizedBox(height: 10),

            EditorLogin(_newPasswordController, 'Senha', 'Nova Senha',
                const Icon(Icons.lock_outline), _valida, 10, true, true),

            const SizedBox(height: 10),

            EditorLogin(_passwordController, 'Senha Atual', 'Senha Atual',
                const Icon(Icons.lock_outline), _valida, 10, true, true),

            const SizedBox(height: 10),

            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _valida = _emailController.text.isEmpty ||
                      _passwordController.text.isEmpty ||
                      _newPasswordController.text.isEmpty;

                  if (!_valida) {
                    //Realiza atualização de dados cadastrais
                    userDao.updatePassword(
                        _passwordController.text, _newPasswordController.text);
                  }
                },
                child: Text(textActionButton,
                    style: GoogleFonts.roboto(textStyle: styleText)),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(29),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
