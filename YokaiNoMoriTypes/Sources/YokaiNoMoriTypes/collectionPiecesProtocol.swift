import Foundation

protocol collectionPiecesProtocol : Sequence {

	typealias Piece = pieceProtocol
	typealias Joueur = joueurProtocol

	// l'iterateur associe
	associatedtype CollectionPiecesIterateur : IteratorProtocol where CollectionPiecesIterateur.Element == Piece

	// searchPiecePosition : Int x Int -> (Piece | Vide)
	// fonction pour chercer une pièce selon sa position
	// Pre : le touple correspond a un pair des (coordX, coordY) detenues par une pièce
	// Post : la piece cherche si la precondition est respectee, sinon retourne Vide
	func searchPiece(coordX : Int, coordY : Int) -> Piece?

	// searchPieceNJ : String x Joueur -> (Piece | Vide)
	// fonction pour chercer une pièce selon son nom et son joueur
	// Pre : le String est non vide et corresponde a un nom valide de pièce
	// Pre : le nombre de Joueur existe parmi les joueurs
	// Post : la Pièce cherche si la precondition est respectee, sinon retourne Vide
	func searchPieceNJ(nom : String, joueur : Joueur) -> Piece?

	// makeIterator : tableDeJeuProtocol -> CollectionPiecesIterateur
    // crée un itérateur sur le collection pour itérer avec for in.
    func makeIterator() -> CollectionPiecesIterateur

}
