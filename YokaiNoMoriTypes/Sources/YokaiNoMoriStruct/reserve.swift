import YokaiNoMoriTypes

// public typealias JoueurR = YokaiNoMoriStruct.Joueur
// public typealias pieceProtocol = YokaiNoMoriStruct.Piece

public struct Reserve : reserveProtocol {


    /*
        Tableau de piece de la reserve
    */
    var res : [pieceProtocol]

    private enum ReserveError: Error {
        case itemNotInRes
    }

    public init() {
        self.res = [pieceProtocol]()
    }

    public mutating func ajouterPiece(piece : pieceProtocol) {
        self.res.append(piece)
    }

    func searchPieceNom(nom : String, joueur : Joueur) -> pieceProtocol? {
        for piece in self.res {
            if (piece.nom == nom) && (piece.joueur.nombre == joueur.nombre) {
                return piece
            } else {
                return nil
            }
        }
    }

    public mutating func enlevePiece(nomPiece : String) throws {
        let pieceProtocolemoved = self.res.filter { $0.nom == nomPiece }
        if pieceProtocolemoved.isEmpty {
            throw ReserveError.itemNotInRes
        } else {
            self.res = self.res.filter { $0.nom != nomPiece }
        }

    }

    public func makeIterator() -> reserveIterator {
        return reserveIterator(self)
    }
}

public struct reserveIterator : reserveIterateurProtocol {

    let resIt : Reserve
    var counter : Int

    init(_ res: Reserve) {
        self.resIt = res
        self.counter = 0
    }

    public mutating func next() -> pieceProtocol? {
        if self.counter < self.resIt.res.count {
            let current : Int = self.counter
            self.counter += 1
            return self.resIt.res[current]
        } else {
            return nil
        }
    }

}
