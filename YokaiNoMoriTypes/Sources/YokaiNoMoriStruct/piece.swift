import YokaiNoMoriTypes


public struct Piece : pieceProtocol {

  private enum PieceError: Error {
      case nomInvalide
      case coordXInvalide
      case coordYInvalide
      case joueurNil
  }
  // Le nom signifie le type de yokai : “koropokkuru”, ”kitsune”, etc
  public var nom : String

  // Les deux coordonnes signifient la position absolue sur la table de jeu
  // On a, au debut :  (j1 - joueur nb. 1,  j2 - joueur nb. 2)
  // | x=1, y = 1, tanuki de j1   | x = 2 , y = 1, koropokkuru de j1  | x = 3, y = 1, kitsune de j1 |
  // | x=1, y = 2, libre          | x = 2 , y = 2, kodama de j1       | x = 3, y = 2, libre         |
  // | x=1, y = 3, libre          | x = 2 , y = 3, kodama de j2       | x = 3, y = 3, libre         |
  // | x=1, y = 4, kitsune de j2  | x = 2 , y = 4, koropokkuru de j2  | x = 3, y = 4, tanuki de j2  |
  public var coordX : Int
  public var coordY : Int

  // Pour savoir a quel joueur appartient la piece
  public var joueur : joueurProtocol

  // creation d'une Piece avec des parametres donnes
  // init : String x Int x Int x Joueur-> Piece
  // Pre : les parametres donnes sont valides
  //		le nom est un des {'kitsune', 'koropokkuru', 'tanuki', 'kodama', 'kodama samurai'}
  //		1 <= coordX <= 3
  //		1 <= coordY <= 4
  // Sinon, la creation echoue
  public init?(nom : String, coordX : Int, coordY : Int, joueur : joueurProtocol) throws {
    // Verification des preconditions
    if nom != "kitsune" && nom != "koropokkuru" && nom != "tanuki" && nom != "kodama" && nom != "kodama samurai" {
      throw PieceError.nomInvalide
    }
    if (coordX < 1 || coordX > 3) {
      throw PieceError.coordXInvalide
    }
    if (coordY < 1 || coordY > 4) {
      throw PieceError.coordYInvalide
    }

    // Construction
    self.nom = nom
    self.coordX = coordX
    self.coordY = coordY
    self.joueur = joueur
  }


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
  public func estEnPromotion() -> Bool {
    if self.joueur.nombre == 1 {
      return self.coordY == 4
    } else {
      return self.coordY == 1
    }
  }

}
