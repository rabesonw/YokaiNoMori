import Foundation
import YokaiNoMoriTypes


public struct TableDeJeu : tableDeJeuProtocol {

  typealias CP = YokaiNoMoriStruct.CollectionPositions

  private enum TDJError: Error {
    case initPiece
    case kodamaNotInTDJ
    case NotAKodama
    case kodamaNotEnPromotion
    case PieceNotInReserve
  }

  private var tab : [[pieceProtocol?]]

  private var r1 : YokaiNoMoriStruct.Reserve // Reserve du j1
  private var r2 : YokaiNoMoriStruct.Reserve // Reserve du j2

	public var joueur1 : joueurProtocol
	public var joueur2 : joueurProtocol

  public var reserve1 : YokaiNoMoriStruct.Reserve {
    get {
      return self.r1
    }
  }

  public var reserve2 : YokaiNoMoriStruct.Reserve {
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
    let cp = self.deplacementsPossibles(piece)
    var colpo : CP = CP()
    // Verification de la validite du deplacment
    for deplacement in cp {

      // Si le deplacement ne s'effectue pas hors des limites du plateau
      if !(deplacement.0 < 1 || deplacement.1 < 1 || deplacement.0 > 3 || deplacement.1 > 4) {

        // Si la case du deplacment est vide
        if (self.tab[deplacement.0-1][deplacement.1-1] == nil) {
          colpo.addPosition(x: deplacement.0, y: deplacement.1)
        }
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
		let colpo : CP = self.positionsPossibles(Piece)
		if neufX < 1 || neufY < 1 || neufX > 3 || neufY > 4 || !self.estVide(neufX, neufY) {
			return false
		} else {
			for pos in colpo {
        if neufX == pos.0 && neufY == pos.1 {
					return true
				}
			}
		}
    return false
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
		let colpo : CP  = self.deplacementsPossibles(Piece)

    guard let p = self.tab[neufX-1][neufY-1] else {
      return false
    }

		if neufX < 1 || neufY < 1 || neufX > 3 || neufY > 4 || p.joueur.nombre == Piece.joueur.nombre {
			return false
		} else {
			for pos in colpo {
				if (neufX, neufY) == pos {
					return true
				}
			}
		}
    return false
  }


	// deplacerPiece : tableDeJeu x Piece x Int x Int -> tableDeJeu
	// deplace une Piece d'une position à une autre
	// Pre : le deplacement est valide, conforme au validerDeplacement
	// Post : si les preconditions sont satisfaites, la position de depart est vide,
	//		la Piece est à la position voulue. Sinon, l’etat de la table de jeu reste le meme.
	//		Apres on deplace la piece, on verifie si on doit la promouvoir, en appelant
	//		estEnPromotion(piece) pour verifier, et transformerKodama(piece) pour la transformer.
	@discardableResult
	public mutating func deplacerPiece(_ Piece: pieceProtocol, _ neufX : Int, _ neufY : Int) -> TableDeJeu {

    if self.validerDeplacement(Piece, neufX, neufY) {
      // Deplacement de la piece
      var p = self.tab[Piece.coordX-1][Piece.coordY-1]!
      self.tab[p.coordX-1][p.coordY-1] = nil
      p.coordX = neufX
      p.coordY = neufY
      self.tab[neufX-1][neufY-1] = p

      // Verif promotion
      if p.nom == "kodama" && p.estEnPromotion() {
        do {
          try self.transformerKodama(p)
        } catch {}
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
	public mutating func capturerPiece(_ pieceAttaquante : pieceProtocol, _ neufX : Int, _ neufY : Int) -> TableDeJeu {

    if (self.validerCapture(pieceAttaquante, neufX, neufY)) {
      var pieceAttaquee = self.tab[neufX-1][neufY-1]!;

      // transforme
      if (pieceAttaquee.nom == "kodama samurai") {
        do {
          try self.transformerKodama(pieceAttaquee)
        } catch{}

        pieceAttaquee = self.tab[neufX-1][neufY-1]!;
      }

      // Ajoute la piece attaquee a la reserve
      self.mettreEnReserve(pieceAttaquee)

      // Deplacement de la piece
      self.tab[neufX-1][neufY-1] = nil
      self.deplacerPiece(pieceAttaquante, neufX, neufY)
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
	public mutating func transformerKodama(_ piece : pieceProtocol) throws -> TableDeJeu {
    if (piece.nom != "kodama" && piece.nom != "kodama samurai") {
      throw TDJError.NotAKodama
    } else {
      if self.tab[piece.coordX-1][piece.coordY-1] != nil {
        var p = piece

        if !p.estEnPromotion() {
          throw TDJError.kodamaNotEnPromotion
        } else {
      		if p.nom == "kodama" {
      			p.nom = "kodama samurai"
      		} else if p.nom == "kodama samurai" {
      			p.nom = "kodama"
      		}
          self.tab[p.coordX-1][p.coordY-1] = p
        }
      } else {
        throw TDJError.kodamaNotInTDJ
      }
    }
    return self

  }

    // mettreEnReserve : tableDeJeu x Piece -> tableDeJeu
    // met un pion en reserve en changeant son joueur d'origine
    // Pre : la pièce est sur la table de jeu (contre-exemple : etre deja en reserve)
    // Post : la Piece est en reserve et son joueur est changé
	@discardableResult
	public mutating func mettreEnReserve(_ piece : pieceProtocol) -> TableDeJeu {
    var p = piece

    if (self.estSurPlateau(p)) {
      if (p.joueur.nombre == self.joueur1.nombre) {
        p.joueur = self.joueur2
        self.r2.ajoutePiece(piece: p)
      } else {
        p.joueur = self.joueur1
        self.r1.ajoutePiece(piece: p)
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
  public mutating func parachuter(_ piece : pieceProtocol, _ neufX : Int, _ neufY : Int) throws -> TableDeJeu {
    if self.estVide(neufX, neufY) {
      // Joueur 1
      if piece.joueur.nombre == self.joueur1.nombre {

        // Si la piece est dans la reserve
        if self.reserve1.searchPieceNom(nom: piece.nom, joueur: piece.joueur) != nil{
          // Retire la piece
          do {
            try self.r1.enlevePiece(nomPiece: piece.nom)
          } catch {}

          // Ajout a la tdj
          self.tab[neufX-1][neufY-1] = piece
        } else {
            throw TDJError.PieceNotInReserve
        }
        // Joueur 2
      } else {

        // Si la piece est dans la reserve
        if self.reserve2.searchPieceNom(nom: piece.nom, joueur: piece.joueur) != nil {
          // Retire la piece
          do {
            try self.r2.enlevePiece(nomPiece: piece.nom)
          } catch {}

          // Ajout a la tdj
          self.tab[neufX-1][neufY-1] = piece

        } else {
            throw TDJError.PieceNotInReserve
        }
      }
    }
    return self
  }

	// gagnerPartie : tableDeJeu x Joueur -> Bool
	// verifie si la partie est gagnée par le joueur indique par le parametre
	// Pre : aucune
	// Post : renvoie true si le jouer donne a gagne, false sinon
  public func gagnerPartie(_ joueur : joueurProtocol) -> Bool {
		if joueur.nombre == self.joueur1.nombre {
			for i in 0...2 {
        if let p = self.tab[i][3] {
  				if p.nom == "koropokkuru" && p.joueur.nombre == joueur.nombre {
  					return true
  				}
        }
			}
      for piece in self.reserve1 {
				if piece.nom == "koropokkuru" {
					return true
				}
			}
		} else {
			for i in 0...2 {
        if let p = self.tab[i][0] {
  				if p.nom == "koropokkuru" && p.joueur.nombre == joueur.nombre {
  					return true
  				}
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
		return TableDeJeuIterateur(self)
  }

  // Retourne vrai si la piece fait partie du plateau
  private func estSurPlateau(_ piece: pieceProtocol) -> Bool {
    for ligne in self.tab {
      for c in ligne {
        if let p = c {
          if p.nom == piece.nom && p.coordX == piece.coordX && p.coordY == piece.coordY && p.joueur.nombre == piece.joueur.nombre {
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

  // Renvoie une collection de positions pour tous les deplacements possibles de la piece
  // Sans prendre en compte les obstacles et les limites du plateau
  private func deplacementsPossibles(_ piece: pieceProtocol) -> CP {
    var colpo = CP()
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

	public mutating func next() -> pieceProtocol? {
    while self.y>=4 && self.tdj.estVide(x+1, y+1) {
      self.incrementer()
    }

    if (self.y>=4) {
      return nil
    }

    else {
      if !self.tdj.estVide(x+1, y+1) {
        let piece = self.tdj.searchPiecePosition(x+1, y+1)
        self.incrementer()
        return piece
      } else {
        return nil
      }
    }
  }

  // Passe a la case suivante
  private mutating func incrementer () {
    self.x = self.x + 1
    if self.x >= 3 {
      self.x = 0
      self.y = self.y + 1
    }
  }

}
