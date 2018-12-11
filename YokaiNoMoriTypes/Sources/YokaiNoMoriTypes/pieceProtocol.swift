import Foundation

protocol pieceProtocol {
    typealias Piece = pieceProtocol
    typealias Joueur = joueurProtocol

	// Le nom signifie le type de yokai : “koropokkuru”, ”kitsune”, etc
	var nom : String{get set}

	// Les deux coordonnes signifie la position absolut sur le table de jeu
	// On a, au debut :  (j1 - joueur nb. 1,  j2 - joueur nb. 2)
	// | x=1, y = 1, tanuki de j1   | x = 2 , y = 1, koropokkuru de j1  | x = 3, y = 1, kitsune de j1 |
	// | x=1, y = 2, libre          | x = 2 , y = 2, kodama de j1       | x = 3, y = 2, libre         |
	// | x=1, y = 3, libre          | x = 2 , y = 3, kodama de j2       | x = 3, y = 3, libre         |
	// | x=1, y = 4, kitsune de j2  | x = 2 , y = 4, koropokkuru de j2  | x = 3, y = 4, tanuki de j2  |
	var coordX : Int{get}
	var coordY : Int{get}

	// Pour savoir a quel joueur appartient la piece
	var joueur : Joueur{get}

	// Pour savoir si la pièce est en Reserve :
	// var estEnReserve : Bool{get}

	// creation d'une Piece avec des parametres donnes
	// init : String x int x int x Joueur-> Piece
	// Pre : les parametres donnes sont valides. Sinon, la creation echoue 
	init?(nom : String, coordX : Int, coordY : Int, joueur : Joueur) throws

	// estEnPromotion : Piece -> Bool
	// verifie si une piece est dans la zone de promotion adverse
	// Note : est appelle seulement immediatement apres un deplacement ou un attaque,
	//		pour s'assurer qu'on ne parachute un kodama directement en zone de promotion
	//		et pour verifier si notre koropokkuru est deplace dans la zone de victoire.
	// Note :  
	// Pre : aucune
	// Post : renvoie True si la piece est en zone de promotion 
	func estEnPromotion(piece : Piece) -> Bool
} 
