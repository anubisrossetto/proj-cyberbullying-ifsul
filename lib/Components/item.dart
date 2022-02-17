import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projcyberbullying/Screens/EditarInfo.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class Item extends StatelessWidget {
  final Stream<QuerySnapshot> registros =
  FirebaseFirestore.instance.collection('registros').snapshots();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return StreamBuilder<QuerySnapshot> (
      stream: registros,
      builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Algo não deu certo !'),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center (
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
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                                    subtitle: Text(data.docs[index]['dataHora'].toString()),
                                    trailing: SizedBox(
                                      width: 50,
                                      child: Row(
                                        children: <Widget>[
                                          IconButton (
                                            icon: const Icon(Icons.edit, color: Colors.green, size: 32),
                                            tooltip: 'Editar',
                                            onPressed: () {

                                              final Future future =
                                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                return EditarFormInfo(infoTitulo, infoResumo,  infoDataHora.toString(), updateDados);
                                              }));

                                              future.then((reg) {
                                                debugPrint("$reg");
                                                debugPrint('Dados atualizados');
                                              });

                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                )),
                      ),
                    )
                );
              }),
        );
      },
    );
  }
}