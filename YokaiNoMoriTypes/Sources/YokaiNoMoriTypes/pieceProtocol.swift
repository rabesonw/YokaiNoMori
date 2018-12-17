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
	var coordX : Int{get set}
	var coordY : Int{get set}

	// Pour savoir a quel joueur appartient la piece
	var joueur : Joueur{get set}

	// creation d'une Piece avec des parametres donnes
	// init : String x Int x Int x Joueur-> Piece
	// Pre : les parametres donnes sont valides
	//		le nom est un des {'kitsune', 'koropokkuru', 'tanuki', 'kodama', 'kodama samurai'}
	//		1 <= coordX <= 3
	//		1 <= coordY <= 4
	//		joueur n'est pas nil (une piece appartient a un joueur toujours).
	// Sinon, la creation echoue 
	init?(nom : String, coordX : Int, coordY : Int, joueur : Joueur) throws

	// estEnPromotion : Piece -> Bool
	// verifie si une piece est dans la zone de promotion adverse
	// Note : est appelle seulement immediatement apres un deplacement ou un attaque,
	//		pour s'assurer qu'on ne parachute un kodama directement en zone de promotion
	//		et pour verifier si notre koropokkuru est deplace dans la zone de victoire.
	// Note :  
	// Pre : aucune
	// Post : renvoie True si la piece est en zone de promotion
	//		pour le joueur1, la zone de promotion est la ligne 4 (c'est a dire coordY == 4)
	//		et pour joueur2, ligne 1 (c'est a dire coordY == 1)
	func estEnPromotion(_ piece : Piece) -> Bool
} 
