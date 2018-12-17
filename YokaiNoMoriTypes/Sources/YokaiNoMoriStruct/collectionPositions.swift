import YokaiNoMoriTypes

public struct collectionPositions : collectionPositionsProtocol {


  // Collecton de position : tableau de tuples d'Int
  private var col : [(Int, Int)]

  // init : -> CollectionPositions
  // création d'une collection de positions
  public init() {
      self.col = [(Int, Int)]()
  }

  // countPositions : CollectionPositions -> Int
  // renvoie le nombre des elements dans la collection (0 si c’est vide)
  public func countPositions() -> Int {
      return self.col.count
  }

  // addPosition : collectionPositions x Int x Int -> CollectionPositions
  // ajoute un neuf touple (x,y) a la collection
  // Pre : 1<= x <= 3
  // Pre : 1<= y <= 4
  // Pre : le touple (x,y) n’est pas deja dans la collection
  // Post : la collection a le nouveau touple (x,y) si les preconditions ont été respectées, sinon, rien n'est changé.
  @discardableResult
  public mutating func addPosition(x : Int, y: Int) -> collectionPositions {
    if (x >= 1 && x <= 3) && (y >= 1 && y <= 4) {
      let tuple = (x,y)
      self.col.append(tuple)
    }
    return self
  }

  // removePosition : collectionPositions x Int x Int -> CollectionPositions
  // enleve un neuf touple (x,y) de la collection
  // Pre : 1 <= x <= 3
  // Pre : 1 <= y <= 4
  // Pre : le touple (x,y) est dans la collection
  // Post : la collection avec le touple (x,y) efface si les preconditions ont été respectées, sinon, rien n'est changé.
  @discardableResult
  public mutating func removePosition(x : Int, y: Int) -> collectionPositions {
    if (x >= 1 && x <= 3) && (y >= 1 && y <= 4) {
      let tuple = (x,y)
      if let index = self.col.firstIndex(where: { $0 == tuple }) {
          self.col.remove(at: index)
      }
    }
    return self
  }

  // makeIterator : collectionPositionsProtocol -> positionsIterateurProtocol
  // crée un itérateur sur le collection pour itérer avec for in.
  public func makeIterator() -> positionsIterateur {
    return positionsIterateur()

  }
}

public struct positionsIterateur : positionsIterateurProtocol {

    public init() {

    }

    // next : IterateurPositionsProtocol -> PlateauProtocolIterator x (Int, Int)?
    // renvoie la prochaine position (touple (coordX, coordY)) dans la collection du positions
    // Pre :
    // Post : retourne la position suivante dans la collection du positions, ou nil si on est au fin de la collection

    public func next() -> (Int, Int)? {
      return nil
    }
}
