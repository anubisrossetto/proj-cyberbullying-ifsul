class Registro{

  final String id;
  final String titulo;
  final String resumo;
  final String datahora;
  final String cid;

  Registro(
      this.id,
      this.titulo,
      this.resumo,
      this.datahora,
      this.cid);

  @override
  String toString() {
    return "Registro($titulo, $datahora, $cid)";
  }

}