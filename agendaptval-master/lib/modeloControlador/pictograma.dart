class Pictograma{

  int idPictograma;
  String url;
  String texto;

  //  Constructor
  //  @author victor
  Pictograma(
      this.idPictograma);

  Pictograma.fromJson(int id):
        this.idPictograma = id;

}