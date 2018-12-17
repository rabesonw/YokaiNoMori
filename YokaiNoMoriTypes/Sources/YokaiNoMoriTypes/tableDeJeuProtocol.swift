import Foundation

protocol tableDeJeuProtocol : Sequence {

    typealias Piece = pieceProtocol
    typealias Joueur = joueurProtocol
    typealias CollectionPositions = collectionPositionsProtocol
	
	// l'iterateur associe
	associatedtype tableDeJeuIterateurProtocol : IteratorProtocol
	associatedtype Reserve : reserveProtocol
    
    
	var joueur1 : Joueur{get set}
	var joueur2 : Joueur{get set}
    
    var reserve1 : Reserve{get}
    var reserve2 : Reserve{get}

	// init : -> tableDeJeu
	// creation d’une table de jeu: on initialise la table de jeu, les 2 joueurs, les 2 reserves vides
    // et apres, les 8 pieces
	init()

	// searchPiecePosition : Int x Int -> (Piece | Vide)
	// fonction pour chercer une piece selon sa position
	// Pre : le touple correspond a un pair des (coordX, coordY) valides
	// 		1 <= coordX <= 3 , 1 <= coordY <= 4
	// Pre : la piece existe sur le table de Jeu
	// Post : la piece cherche si les preconditions sont respectees, sinon retourne Vide
	func searchPiecePosition(_ coordX : Int,_  coordY : Int) -> Piece?

	// positionsPossibles : tableDeJeu x Piece -> CollectionPositions
	// evaluation des toutes les futurs positions disponibles pour une pièce
	func positionsPossibles<CP: CollectionPositions>(_ piece: Piece) -> CP

	// validerDeplacement : tableDeJeu x Piece x Int x Int -> Bool
	// verifie qu'une Piece a bien le droit d'aller à l'emplacement indique
	// Pre : aucune 
	// Post : renvoie True si le deplacement respecte les regles du jeu : 
	//		la position (neufX, neufY) est atteignable de la position courante de la piece donnee en premier parametre
	//		la case (neufX, neufY) est vide
	//		1 <= x <= 3 et 1 <= y <=4.
	//		renvoie False sinon.
	func validerDeplacement(_ Piece : Piece, _ neufX : Int, _ neufY : Int) -> Bool

	
    // validerCapture : tableDeJeu x Piece x Int x Int -> Bool
	// verifie qu'une Piece a bien le droit d'attaquer à l'emplacement indique
	// Pre: aucune
	// Post : renvoie True si le deplacement respecte les regles du jeu : 
	//		la position (neufX, neufY) est atteignable de la position courante de la piece donnee en premier parametre
	//		la case (neufX, neufY) est occupee par une piece ennemie
	//		1 <= x <= 3 et 1 <= y <=4.
	//		renvoie False sinon.
	func validerCapture(_ Piece : Piece, _ neufX : Int, _ neufY : Int) -> Bool
    
    
	// deplacerPiece : tableDeJeu x Piece x Int x Int -> tableDeJeu
	// deplace une Piece d'une position à une autre 
	// Pre : le deplacement est valide, conforme au validerDeplacement
	// Post : si les preconditions sont satisfaites, la position de depart est vide, 
	//		la Piece est à la position voulue. Sinon, l’etat de la table de jeu reste le meme.
	//		Apres on deplace la piece, on verifie si on doit la promouvoir, en appelant
	//		estEnPromotion(piece) pour verifier, et transformerKodama(piece) pour la transformer.
	@discardableResult
	mutating func deplacerPiece(_ Piece: Piece, _ neufX : Int, _ neufY : Int) -> Self

	// capturerPiece : tableDeJeu x Piece x Piece -> tableDeJeu
	// capture une pièce de l’autre joueur (donnee par le deuxieme parametre) avec une Piece de le joueur courant
	// Pre : la capture est valide, conforme au validerDeplacement
	// Post : si les preconditions sont satisfaites, les deux Pieces changent leurs positions 
	//	et la pièce capturee est dans la reserve de le joueur attaquant . Sinon, l’etat de la table de jeu reste le meme.
	@discardableResult
	mutating func capturerPiece(_ pieceAttaquante : Piece, _ neufX : Int, _ neufY : Int) -> Self

	// transformerKodama : tableDeJeu x Piece
	// transforme un "kodama" en "kodama samourai" ou la chose inverse.
	// Fontion appelle a la fin de capturerPiece(): on verifie si on a capture un kodama samurai
	// et a la fin de deplacerPiece(), on verifie si on a deplace la piece dans la zone de promotion
	// Pre : la Piece est un kodama et se trouve dans la zone de promotion 
	//        ou c'est un kodama samurai qui est capture
	// Post : la nouvelle Piece est au même emplacement mais est un kodama samourai
	//        ou c'est un kodama dans la reserve de l'attaquant
	@discardableResult
	mutating func transformerKodama(_ piece : Piece) throws -> Self

    // mettreEnReserve : tableDeJeu x Piece -> tableDeJeu
    // met un pion en reserve en changeant son joueur d'origine 
    // Pre : la pièce est sur la table de jeu (contre-exemple : etre deja en reserve)
    // Post : la Piece est en reserve et son joueur est changé
	@discardableResult
	mutating func mettreEnReserve(_ piece : Piece) -> Self

	// parachuter : tableDeJeu x Piece x Int x Int -> tableDeJeu
    // parachute un pion, qui est identifie par son nom, de la reserve du joueur Joueur sur la table de jeu;
    //           la position voulue est donnee par les troisieme et quatrieme parametres
    // Pre : la pièce est en reserve du joueur qui veut parachuter une Piece
    // Pre : la neuf case est libre avant parachuter
    // Post : si les preconditions sont respectees, l’etat de la pièce est change
	@discardableResult
    mutating func parachuter(_ piece : Piece, _ neufX : Int, _ neufY : Int) throws -> Self

	// gagnerPartie : tableDeJeu x Joueur -> Bool
	// verifie si la partie est gagnée par le joueur indique par le parametre
	// Pre : aucune 
	// Post : renvoie true si le jouer donne a gagne, false sinon
	func gagnerPartie(_ joueur : Joueur) -> Bool

	// makeIterator : tableDeJeuProtocol -> tableDeJeuIterateurProtocol
    // crée un itérateur sur le collection pour itérer avec for in.
    func makeIterator() -> tableDeJeuIterateurProtocol

}

protocol tableDeJeuIterateurProtocol : IteratorProtocol {

    typealias Piece = pieceProtocol

	// next : tableDeJeuIterateurProtocol -> tableDeJeuIterateurProtocol x pieceProtocol?
    // renvoie la prochaine piece dans la collection du tableDeJeu
    // Pre : aucune
    // Post : retourne la piece suivante dans la collection du tableDeJeu, ou nil si on est au fin de la collection

	func next() -> Piece? 

}
