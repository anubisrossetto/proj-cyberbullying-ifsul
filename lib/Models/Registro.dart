class Registro{

  final String id;
  final String titulo;
  final String resumo;
  final String datahora;
  final String cid;
  final String userId;

  Registro(
      this.id,
      this.titulo,
      this.resumo,
      this.datahora,
      this.cid,
      this.userId);

  @override
  String toString() {
    return "Registro($titulo, $datahora, $cid)";
  }

}