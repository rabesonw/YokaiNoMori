import Foundation
import YokaiNoMoriTypes


public struct TableDeJeu : tableDeJeuProtocol {
  typealias Reserve = reserveProtocol

  typealias CP = YokaiNoMoriStruct.CollectionPositions

  private enum TDJError: Error {
    case initPiece
  }

  private var tab : [[pieceProtocol?]]

  private var r1 : reserveProtocol // Reserve du j1
  private var r2 : reserveProtocol // Reserve du j2

	public var joueur1 : joueurProtocol
	public var joueur2 : joueurProtocol

  public var reserve1 : reserveProtocol {
    get {
      return self.r1
    }
  }

  public var reserve2 : reserveProtocol {
    get {
      return self.r2
    }
  }


	// init : -> tableDeJeu
	// creation d’une table de jeu: on initialise la table de jeu, les 2 joueurs, les 2 reserves vides
    // et apres, les 8 pieces
	public init() {
    // Init du tableau
    // Cree un tableau de 4 lignes (y) et 3 colonnes (x)
    self.tab = Array(repeating: Array(repeating: nil, count: 4), count: 3)

    // Creation des joueurs
    self.joueur1 = YokaiNoMoriStruct.Joueur(nombre: 1)
    self.joueur2 = YokaiNoMoriStruct.Joueur(nombre: 2)

    // Creation des reserves vides
    self.r1 = YokaiNoMoriStruct.Reserve()
    self.r2 = YokaiNoMoriStruct.Reserve()

    // Creation des 8 pieces
    // Note : Prendre en compte que coordX est a l'indice coordX-1 et coordY est a l'indice coordY-1 dans le tableau
    // Pieces du J1
    do {
      try self.tab[0][0] = YokaiNoMoriStruct.Piece(nom: "tanuki", coordX: 1, coordY: 1, joueur: self.joueur1)
      try self.tab[1][0] = YokaiNoMoriStruct.Piece(nom: "koropokkuru", coordX: 2, coordY: 1, joueur: self.joueur1)
      try self.tab[1][1] = YokaiNoMoriStruct.Piece(nom: "kodama", coordX: 2, coordY: 2, joueur: self.joueur1)
      try self.tab[2][0] = YokaiNoMoriStruct.Piece(nom: "kitsune", coordX: 3, coordY: 1, joueur: self.joueur1)

      // Pieces du J2
      try self.tab[2][3] = YokaiNoMoriStruct.Piece(nom: "tanuki", coordX: 3, coordY: 4, joueur: self.joueur2)
      try self.tab[1][3] = YokaiNoMoriStruct.Piece(nom: "koropokkuru", coordX: 2, coordY: 4, joueur: self.joueur2)
      try self.tab[1][2] = YokaiNoMoriStruct.Piece(nom: "kodama", coordX: 2, coordY: 3, joueur: self.joueur2)
      try self.tab[0][3] = YokaiNoMoriStruct.Piece(nom: "kitsune", coordX: 1, coordY: 4, joueur: self.joueur2)
    }
    catch{}

  }

	// searchPiecePosition : Int x Int -> (Piece | Vide)
	// fonction pour chercer une piece selon sa position
	// Pre : le touple correspond a un pair des (coordX, coordY) valides
	// 		1 <= coordX <= 3 , 1 <= coordY <= 4
	// Pre : la piece existe sur le table de Jeu
	// Post : la piece cherche si les preconditions sont respectees, sinon retourne Vide
	public func searchPiecePosition(_ coordX : Int,_  coordY : Int) -> pieceProtocol? {
		if (coordX<1 || coordY<1) || (coordX>3 || coordY>4) {
			return nil
		} else {
			return self.tab[coordX-1][coordY-1]
		}
  }

	// positionsPossibles : tableDeJeu x Piece -> CollectionPositions
	// evaluation des toutes les futurs positions disponibles pour une pièce
	public func positionsPossibles<CP: collectionPositionsProtocol>(_ piece: pieceProtocol) -> CP {
		var colpo = YokaiNoMoriStruct.CollectionPositions()
		if piece.nom == "tanuki" {
			colpo.addPosition(x: piece.coordX+1, y: piece.coordY)
			colpo.addPosition(x: piece.coordX-1, y: piece.coordY)
			colpo.addPosition(x: piece.coordX, y: piece.coordY+1)
			colpo.addPosition(x: piece.coordX, y: piece.coordY-1)
		} else if piece.nom == "koropokkuru" {
			colpo.addPosition(x: piece.coordX+1, y: piece.coordY)
			colpo.addPosition(x: piece.coordX-1, y: piece.coordY)
			colpo.addPosition(x: piece.coordX, y: piece.coordY+1)
			colpo.addPosition(x: piece.coordX, y: piece.coordY-1)
			colpo.addPosition(x: piece.coordX+1, y: piece.coordY+1)
			colpo.addPosition(x: piece.coordX+1, y: piece.coordY-1)
			colpo.addPosition(x: piece.coordX-1, y: piece.coordY+1)
			colpo.addPosition(x: piece.coordX-1, y: piece.coordY-1)
		} else if piece.nom == "kitsune" {
			colpo.addPosition(x: piece.coordX+1, y: piece.coordY+1)
			colpo.addPosition(x: piece.coordX+1, y: piece.coordY-1)
			colpo.addPosition(x: piece.coordX-1, y: piece.coordY+1)
			colpo.addPosition(x: piece.coordX-1, y: piece.coordY-1)
		}
		if piece.joueur.nombre == self.joueur1.nombre {
			if piece.nom == "kodama" {
				colpo.addPosition(x: piece.coordX, y: piece.coordY+1)
			} else if piece.nom == "kodama samurai" {
				colpo.addPosition(x: piece.coordX, y: piece.coordY-1)
				colpo.addPosition(x: piece.coordX, y: piece.coordY+1)
				colpo.addPosition(x: piece.coordX+1, y: piece.coordY)
				colpo.addPosition(x: piece.coordX-1, y: piece.coordY)
				colpo.addPosition(x: piece.coordX+1, y: piece.coordY+1)
				colpo.addPosition(x: piece.coordX-1, y: piece.coordY+1)
			}
		} else if piece.joueur.nombre == self.joueur2.nombre {
			if piece.nom == "kodama" {
				colpo.addPosition(x: piece.coordX, y: piece.coordY-1)
			} else if piece.nom == "kodama samurai" {
				colpo.addPosition(x: piece.coordX, y: piece.coordY-1)
				colpo.addPosition(x: piece.coordX, y: piece.coordY+1)
				colpo.addPosition(x: piece.coordX+1, y: piece.coordY)
				colpo.addPosition(x: piece.coordX-1, y: piece.coordY)
				colpo.addPosition(x: piece.coordX+1, y: piece.coordY-1)
				colpo.addPosition(x: piece.coordX-1, y: piece.coordY-1)
			}
		}
		return colpo
  }

	// validerDeplacement : tableDeJeu x Piece x Int x Int -> Bool
	// verifie qu'une Piece a bien le droit d'aller à l'emplacement indique
	// Pre : aucune
	// Post : renvoie True si le deplacement respecte les regles du jeu :
	//		la position (neufX, neufY) est atteignable de la position courante de la piece donnee en premier parametre
	//		la case (neufX, neufY) est vide
	//		1 <= x <= 3 et 1 <= y <=4.
	//		renvoie False sinon.
	public func validerDeplacement(_ Piece : pieceProtocol, _ neufX : Int, _ neufY : Int) -> Bool {
		var colpo = self.positionsPossibles(Piece)
		if neufX < 1 || neufY < 1 || neufX > 3 || neufY > 4 || !self.estVide(neufX, neufY) {
			return false
		} else {
			for pos in colpo {
				if (neufX, neufY) == pos {
					return true
				}
			}
		}
  }


    // validerCapture : tableDeJeu x Piece x Int x Int -> Bool
	// verifie qu'une Piece a bien le droit d'attaquer à l'emplacement indique
	// Pre: aucune
	// Post : renvoie True si le deplacement respecte les regles du jeu :
	//		la position (neufX, neufY) est atteignable de la position courante de la piece donnee en premier parametre
	//		la case (neufX, neufY) est occupee par une piece ennemie
	//		1 <= x <= 3 et 1 <= y <=4.
	//		renvoie False sinon.
	public func validerCapture(_ Piece : pieceProtocol, _ neufX : Int, _ neufY : Int) -> Bool {
		var colpo = self.positionsPossibles(Piece)
		if neufX < 1 || neufY < 1 || neufX > 3 || neufY > 4 || self.tab[neufX-1][neufY-1].joueur.nombre == Piece.joueur.nombre {
			return false
		} else {
			for pos in colpo {
				if (neufX, neufY) == pos {
					return true
				}
			}
		}
  }


	// deplacerPiece : tableDeJeu x Piece x Int x Int -> tableDeJeu
	// deplace une Piece d'une position à une autre
	// Pre : le deplacement est valide, conforme au validerDeplacement
	// Post : si les preconditions sont satisfaites, la position de depart est vide,
	//		la Piece est à la position voulue. Sinon, l’etat de la table de jeu reste le meme.
	//		Apres on deplace la piece, on verifie si on doit la promouvoir, en appelant
	//		estEnPromotion(piece) pour verifier, et transformerKodama(piece) pour la transformer.
	@discardableResult
	public mutating func deplacerPiece(_ Piece: pieceProtocol, _ neufX : Int, _ neufY : Int) -> tableDeJeuProtocol {

    if self.validerDeplacement(Piece, neufX, neufY) {

      // Deplacement de la piece
      self.tab[Piece.coordX-1][Piece.coordY-1] = nil
      Piece.coordX = neufX
      Piece.coordY = neufY
      self.tab[neufX-1][neufY-1] = Piece

      // Verif promotion
      if Piece.nom == "kodama" && Piece.estEnPromotion() {
        self = self.transformerKodama(Piece)
      }
    }

    return self
  }

	// capturerPiece : tableDeJeu x Piece x Piece -> tableDeJeu
	// capture une pièce de l’autre joueur (donnee par le deuxieme parametre) avec une Piece de le joueur courant
	// Pre : la capture est valide, conforme au validerCapture
	// Post : si les preconditions sont satisfaites, les deux Pieces changent leurs positions
	//	et la pièce capturee est dans la reserve de le joueur attaquant . Sinon, l’etat de la table de jeu reste le meme.
	@discardableResult
	public mutating func capturerPiece(_ pieceAttaquante : pieceProtocol, _ neufX : Int, _ neufY : Int) -> tableDeJeuProtocol {

    if (self.validerCapture(pieceAttaquante, neufX, neufY)) {
      var pieceAttaquee = self.tab[neufX-1][neufY-1];

      // transforme
      if (pieceAttaquee.nom = "kodama samurai") {
        self = self.tranformerKodama(pieceAttaquee)
        pieceAttaquee = self.tab[neufX-1][neufY-1];
      }

      // Ajoute la piece attaquee a la reserve
      self.mettreEnReserve(pieceAttaquee)

      // Deplacement de la piece
      self = self.deplacerPiece(pieceAttaquante, neufX, neufY)
    }

    return self

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
	public mutating func transformerKodama(_ piece : pieceProtocol) throws -> tableDeJeuProtocol {
		if piece.nom == "kodama" && self.estSurPlateau(piece) {
			piece.nom = "kodama samurai"
		} else if piece.nom == "kodama samurai" && !self.estSurPlateau(piece) {
			piece.nom = "kodama"
		}
  }

    // mettreEnReserve : tableDeJeu x Piece -> tableDeJeu
    // met un pion en reserve en changeant son joueur d'origine
    // Pre : la pièce est sur la table de jeu (contre-exemple : etre deja en reserve)
    // Post : la Piece est en reserve et son joueur est changé
	@discardableResult
	public mutating func mettreEnReserve(_ piece : pieceProtocol) -> tableDeJeuProtocol {
    if (self.estSurPlateau(piece)) {
      if (piece.joueur.nombre == self.joueur1.nombre) {
        piece.joueur.nombre = self.joueur2.nombre
        self.reserve2.ajoutePiece(piece)
      } else {
        piece.joueur.nombre = self.joueur1.nombre
        self.reserve1.ajoutePiece(piece)
      }
    }
    return self
  }

	// parachuter : tableDeJeu x Piece x Int x Int -> tableDeJeu
    // parachute un pion, qui est identifie par son nom, de la reserve du joueur Joueur sur la table de jeu;
    //           la position voulue est donnee par les troisieme et quatrieme parametres
    // Pre : la pièce est en reserve du joueur qui veut parachuter une Piece
    // Pre : la neuf case est libre avant parachuter
    // Post : si les preconditions sont respectees, l’etat de la pièce est change
	@discardableResult
  public mutating func parachuter(_ piece : pieceProtocol, _ neufX : Int, _ neufY : Int) throws -> tableDeJeuProtocol {
    if self.estVide(neufX, neufY) {
      // Joueur 1
      if piece.joueur.nombre == self.joueur1.nombre {

        // Si la piece est dans la reserve
        if let p = self.reserve1.searchPieceNom(piece.nom, piece.joueur) {
          // Retire la piece
          do {
            try self.reserve1.enlevePiece(piece.nom)
          } catch {}

          // Ajout a la tdj
          self.tab[neufX-1][neufY-1] = piece
        }
        // Joueur 2
      } else {

        // Si la piece est dans la reserve
        if let p = self.reserve2.searchPieceNom(piece.nom, piece.joueur) {
          // Retire la piece
          do {
            try self.reserve2.enlevePiece(piece.nom)
          } catch {}

          // Ajout a la tdj
          self.tab[neufX-1][neufY-1] = piece
        }
      }
    }
  }

	// gagnerPartie : tableDeJeu x Joueur -> Bool
	// verifie si la partie est gagnée par le joueur indique par le parametre
	// Pre : aucune
	// Post : renvoie true si le jouer donne a gagne, false sinon
  public func gagnerPartie(_ joueur : joueurProtocol) -> Bool {
		if joueur.nombre == self.joueur1.nombre {
			for i in 0...2 {
				if tab[i][3].nom == "koropokkuru" || tab[i][3].joueur == joueur {
					return true
				}
			}
			for piece in self.reserve1 {
				if piece.nom == "koropokkuru" {
					return true
				}
			}
		} else {
			for i in 0...2 {
				if tab[i][0].nom == "koropokkuru" || tab[i][0].joueur == joueur {
					return true
				}
			}
			for piece in self.reserve2 {
				if piece.nom == "koropokkuru" {
					return true
				}
			}
		}
		return false
  }

	// makeIterator : tableDeJeuProtocol -> tableDeJeuIterateurProtocol
    // crée un itérateur sur le collection pour itérer avec for in.
  public func makeIterator() -> TableDeJeuIterateur {
		return TableDeJeuIterator(self)
  }

  // Retourne vrai si la piece fait partie du plateau
  private func estSurPlateau(_ piece: pieceProtocol) -> Bool {
    for ligne in self.tab {
      for c in ligne {
        if let p = c {
          if p == piece {
            return true
          }
        }
      }
    }
    return false
  }

  // Retourne vrai si la case est vide
  public func estVide(_ x: Int, _ y: Int) -> Bool {
    return self.tab[x-1][y-1] == nil
  }

}

public struct TableDeJeuIterateur : tableDeJeuIterateurProtocol {

  let tdj : TableDeJeu
  var x : Int
  var y : Int

  public init(_ tdj: TableDeJeu) {
    self.tdj = tdj
    self.x = 0
    self.y = 0
  }

	// next : tableDeJeuIterateurProtocol -> tableDeJeuIterateurProtocol x pieceProtocol?
    // renvoie la prochaine piece dans la collection du tableDeJeu
    // Pre : aucune
    // Post : retourne la piece suivante dans la collection du tableDeJeu, ou nil si on est au fin de la collection

	public func next() -> pieceProtocol? {
    while self.y>=4 && self.tdj.estVide(x+1, y+1) {
      self.incrementer()
    }

    if (self.y>=4) {
      return nil
    }

    else {
      if !self.tdj.estVide(x+1, y+1) {
        var piece = self.tdj.searchPiecePosition(x+1, y+1)
        self.incrementer()
        return piece
      } else {
        return nil
      }
    }
  }

  // Passe a la case suivante
  private func incrementer () {
    self.x = self.x + 1
    if self.x >= 3 {
      self.x = 0
      self.y = self.y + 1
    }
  }

}
