import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projcyberbullying/Screens/EditarInfo.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:projcyberbullying/Data/User_dao.dart';
import 'package:intl/intl.dart';

class Item extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final UserDao userDao = Provider.of<UserDao>(context, listen: false);
    Query registros = FirebaseFirestore.instance.collection('registros')
                      .where('userId', isEqualTo: userDao.userId());
                      
    return StreamBuilder<QuerySnapshot>(
      stream: registros.snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Algo não deu certo !'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitFadingCircle(color: Colors.green, size: 120),
          );
        }

        final data = snapshot.requireData;

        return AnimationLimiter(
          child: ListView.builder(
              itemCount: data.size,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                //Pegando as informações dos documentos do firebase da coleção registros
                final infoTitulo = data.docs[index]['titulo'];
                final infoDataHora = data.docs[index]['dataHora'].toString();
                final infoResumo = data.docs[index]['Resumo'];
                // final infoCid = data.docs[index]['cid'];
                final infoArq = data.docs[index]['nomeArq'];
                // ignore: unused_local_variable
                final infoCid = data.docs[index]['cid'];
                final updateDados = snapshot.data.docs[index];

                return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 100),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 2500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: FadeInAnimation(
                        curve: Curves.fastLinearToSlowEaseIn,
                        duration: const Duration(milliseconds: 2500),
                        child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            height: 70.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: ListTile(
                                leading: const Icon(Icons.add_circle_outline),
                                title: Text(data.docs[index]['titulo']),
                                subtitle: Text(DateFormat('dd/MM/yyyy, HH:mm')
                                    .format(DateTime.fromMillisecondsSinceEpoch(
                                        data.docs[index]['dataHora']))
                                    .toString()),
                                trailing: SizedBox(
                                  width: 50,
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.green, size: 32),
                                        tooltip: 'Editar',
                                        onPressed: () {
                                          final Future future = Navigator.push(
                                              context, MaterialPageRoute(
                                                  builder: (context) {
                                            return EditarFormInfo(
                                                infoTitulo,
                                                infoResumo,
                                                infoDataHora.toString(),
                                                infoCid,
                                                infoArq,
                                                updateDados);
                                          }));

                                          future.then((reg) {
                                            debugPrint("$reg"); //testes 
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ))),
                      ),
                    ));
              }),
        );
      },
    );
  }
}
