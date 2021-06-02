import 'produit.dart';

class Transfert {

final String sender;
final String senderName;
final String senderRole;
final String receiverRole;
final String receiverName;
final String receiver;
final int oldQ;
final Produit produit;

  Transfert({this.senderRole, this.receiverRole, this.senderName,this.receiverName, this.sender, this.receiver, this.oldQ=0, this.produit});

}