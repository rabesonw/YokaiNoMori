import Foundation

protocol reserveProtocol : Sequence {

	typealias Piece = pieceProtocol
	typealias Joueur = joueurProtocol
	associatedtype reserveIterateurProtocol : IteratorProtocol where reserveIterateurProtocol.Element == Piece

	// init : -> reserveProtocol
	// cree une reserve vide
	init()

	// ajoutePiece : Piece x reserveProtocol -> reserveProtocol
	// ajoute la piece donne en parametre a la collection de pieces dans la reserveProtocol
	// (quand la piece est capturee)
	// Pre : aucune
	// Post : la collection contient maintenant la piece donne en parametre
	mutating func ajoutePiece(piece : Piece)

	// searchPieceNom : String -> (Piece | Vide)
	// fonction pour chercer une piece selon son nom dans la reserve
	// Pre : le String est non vide et corresponde a un nom valide de piece
	// Post : la Piece cherche, si elle existe dans la reserve
	//		sinon, ou si le nom est invalide, Vide
	func searchPieceNom(nom : String, joueur : Joueur) -> Piece?

	// enlevePiece : String x reserveProtocol -> reserveProtocol
	// enleve la piece qui a le nom donne en parametre de la collection de pieces dans la reserveProtocol
	// (quand la piece est parachutee).
	// cette fonction va utiliser searchPieceNom pour trouver la reference 
	// Pre : il y a dans la reserve une piece avec le nom donne
	// Post : la collection ne contient plus la piece donne en parametre, ou envoie une exception
	//		si la recherche de la piece selon son nom a echouee
	mutating func enlevePiece(nomPiece : String) throws

	// makeIterator : reserveProtocol -> reserveIterateurProtocol
    // crée un itérateur sur le collection pour itérer avec for in.
    func makeIterator() -> reserveIterateurProtocol

}

protocol reserveIterateurProtocol : IteratorProtocol {

	typealias Piece = pieceProtocol

    // next : reserveIterateurProtocol -> reserveIterateurProtocol x pieceProtocol?
    // renvoie la prochaine piece dans la collection du Reserve
    // Pre : aucune
    // Post : retourne la piece suivante dans la collection du Reserve, ou nil si on est au fin de la collection

	func next() -> Piece? 

}
