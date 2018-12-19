import Foundation
import YokaiNoMoriTypes

public typealias JoueurT = YokaiNoMoriStruct.Joueur
public typealias PieceT = YokaiNoMoriStruct.Piece
public typealias ReserveT = YokaiNoMoriStruct.Reserve


public struct TableDeJeu : tableDeJeuProtocol {
  private var tab : [[PieceT?]]

  private var r1 : ReserveT // Reserve du j1
  private var r2 : ReserveT // Reserve du j2

	public var joueur1 : JoueurT
	public var joueur2 : JoueurT

  public var reserve1 : ReserveT {
    get {
      return self.r1
    }
  }

  public var reserve2 : ReserveT {
    get {
      return self.r2
    }
  }


	// init : -> tableDeJeu
	// creation d’une table de jeu: on initialise la table de jeu, les 2 joueurs, les 2 reserves vides
    // et apres, les 8 pieces
	public init() {
    var a = JoueurT(nombre : 2)
    // Init du tableau

    // Cree un tableau de 4 lignes (y) et 3 colonnes (x)
    self.tab = Array(repeating: Array(repeating: nil, count: 4), count: 3)

    // Creation des joueurs
    self.joueur1 = JoueurT(nombre: 1)
    self.joueur2 = JoueurT(nombre: 2)

    // Creation des reserves vides
    self.r1 = ReserveT()
    self.r2 = ReserveT()

    // Creation des 8 pieces
    // Note : Prendre en compte que coorX est a l'indice coordX-1 et coordY est a l'indice coordY-1 dans le tableau
    // Pieces du J1
    self.tab[0][0] = PieceT (nom: "tanuki", coordX: 1, coordY: 1, joueur: self.joueur1)
    self.tab[1][0] = PieceT (nom: "koropokkuru", coordX: 2, coordY: 1, joueur: self.joueur1)
    self.tab[1][1] = PieceT (nom: "kodama", coordX: 2, coordY: 2, joueur: self.joueur1)
    self.tab[2][0] = PieceT (nom: "kitsune", coordX: 3, coordY: 1, joueur: self.joueur1)

    // Pieces du J2
    self.tab[2][3] = YokaiNoMoriStruct.Piece (nom: "tanuki", coordX: 3, coordY: 4, joueur: self.joueur2)
    self.tab[1][3] = PieceT (nom: "koropokkuru", coordX: 2, coordY: 4, joueur: self.joueur2)
    self.tab[1][2] = PieceT (nom: "kodama", coordX: 2, coordY: 3, joueur: self.joueur2)
    self.tab[0][3] = PieceT (nom: "kitsune", coordX: 1, coordY: 4, joueur: self.joueur2)


  }

	// searchPiecePosition : Int x Int -> (Piece | Vide)
	// fonction pour chercer une piece selon sa position
	// Pre : le touple correspond a un pair des (coordX, coordY) valides
	// 		1 <= coordX <= 3 , 1 <= coordY <= 4
	// Pre : la piece existe sur le table de Jeu
	// Post : la piece cherche si les preconditions sont respectees, sinon retourne Vide
	public func searchPiecePosition(_ coordX : Int,_  coordY : Int) -> PieceT? {

  }

	// positionsPossibles : tableDeJeu x Piece -> CollectionPositions
	// evaluation des toutes les futurs positions disponibles pour une pièce
	public func positionsPossibles<CP: CollectionPositions>(_ piece: Piece) -> CP {

  }

	// validerDeplacement : tableDeJeu x Piece x Int x Int -> Bool
	// verifie qu'une Piece a bien le droit d'aller à l'emplacement indique
	// Pre : aucune
	// Post : renvoie True si le deplacement respecte les regles du jeu :
	//		la position (neufX, neufY) est atteignable de la position courante de la piece donnee en premier parametre
	//		la case (neufX, neufY) est vide
	//		1 <= x <= 3 et 1 <= y <=4.
	//		renvoie False sinon.
	public func validerDeplacement(_ Piece : PieceT, _ neufX : Int, _ neufY : Int) -> Bool {

  }


    // validerCapture : tableDeJeu x Piece x Int x Int -> Bool
	// verifie qu'une Piece a bien le droit d'attaquer à l'emplacement indique
	// Pre: aucune
	// Post : renvoie True si le deplacement respecte les regles du jeu :
	//		la position (neufX, neufY) est atteignable de la position courante de la piece donnee en premier parametre
	//		la case (neufX, neufY) est occupee par une piece ennemie
	//		1 <= x <= 3 et 1 <= y <=4.
	//		renvoie False sinon.
	public func validerCapture(_ Piece : PieceT, _ neufX : Int, _ neufY : Int) -> Bool {

  }


	// deplacerPiece : tableDeJeu x Piece x Int x Int -> tableDeJeu
	// deplace une Piece d'une position à une autre
	// Pre : le deplacement est valide, conforme au validerDeplacement
	// Post : si les preconditions sont satisfaites, la position de depart est vide,
	//		la Piece est à la position voulue. Sinon, l’etat de la table de jeu reste le meme.
	//		Apres on deplace la piece, on verifie si on doit la promouvoir, en appelant
	//		estEnPromotion(piece) pour verifier, et transformerKodama(piece) pour la transformer.
	@discardableResult
	public mutating func deplacerPiece(_ Piece: PieceT, _ neufX : Int, _ neufY : Int) -> TableDeJeu {

  }

	// capturerPiece : tableDeJeu x Piece x Piece -> tableDeJeu
	// capture une pièce de l’autre joueur (donnee par le deuxieme parametre) avec une Piece de le joueur courant
	// Pre : la capture est valide, conforme au validerDeplacement
	// Post : si les preconditions sont satisfaites, les deux Pieces changent leurs positions
	//	et la pièce capturee est dans la reserve de le joueur attaquant . Sinon, l’etat de la table de jeu reste le meme.
	@discardableResult
	public mutating func capturerPiece(_ pieceAttaquante : PieceT, _ neufX : Int, _ neufY : Int) -> TableDeJeu {

  }

	// transformerKodama : tableDeJeu x Piece
	// transforme un "kodama" en "kodama samourai" ou la chose inverse.
	// Fontion appelle a la fin de capturerPiece(): on verifie si on a capture un kodama samurai
	// et a la fin de deplacerPiece(), on verifie si on a deplace la piece dans la zone de promotion
	// Pre : la Piece est un kodama et se trouve dans la zone de promotion
	//        ou c'est un kodama samurai qui est capture
	// Post : la nouvelle Piece est au même emplacement mais est un kodama samourai
	//        ou c'est un kodama dans la reserve de l'attaquant
	@discardableResult
	public mutating func transformerKodama(_ piece : PieceT) throws -> TableDeJeu {

  }

    // mettreEnReserve : tableDeJeu x Piece -> tableDeJeu
    // met un pion en reserve en changeant son joueur d'origine
    // Pre : la pièce est sur la table de jeu (contre-exemple : etre deja en reserve)
    // Post : la Piece est en reserve et son joueur est changé
	@discardableResult
	public mutating func mettreEnReserve(_ piece : PieceT) -> TableDeJeu {

  }

	// parachuter : tableDeJeu x Piece x Int x Int -> tableDeJeu
    // parachute un pion, qui est identifie par son nom, de la reserve du joueur Joueur sur la table de jeu;
    //           la position voulue est donnee par les troisieme et quatrieme parametres
    // Pre : la pièce est en reserve du joueur qui veut parachuter une Piece
    // Pre : la neuf case est libre avant parachuter
    // Post : si les preconditions sont respectees, l’etat de la pièce est change
	@discardableResult
  public mutating func parachuter(_ piece : PieceT, _ neufX : Int, _ neufY : Int) throws -> TableDeJeu {

  }

	// gagnerPartie : tableDeJeu x Joueur -> Bool
	// verifie si la partie est gagnée par le joueur indique par le parametre
	// Pre : aucune
	// Post : renvoie true si le jouer donne a gagne, false sinon
  public func gagnerPartie(_ joueur : JoueurT) -> TableDeJeu {

  }

	// makeIterator : tableDeJeuProtocol -> tableDeJeuIterateurProtocol
    // crée un itérateur sur le collection pour itérer avec for in.
  public func makeIterator() -> TableDeJeuIterateur {

  }

}

public struct TableDeJeuIterateur : tableDeJeuIterateurProtocol {

  public init() {

  }

	// next : tableDeJeuIterateurProtocol -> tableDeJeuIterateurProtocol x pieceProtocol?
    // renvoie la prochaine piece dans la collection du tableDeJeu
    // Pre : aucune
    // Post : retourne la piece suivante dans la collection du tableDeJeu, ou nil si on est au fin de la collection

	public func next() -> PieceT? {

  }

}
