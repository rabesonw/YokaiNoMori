import YokaiNoMoriTypes

public typealias JoueurR = YokaiNoMoriStruct.joueur
public typealias PieceR = YokaiNoMoriStruct.Piece

public struct Reserve : reserveProtocol {
    
    
    /*
        Tableau de piece de la reserve
    */
    var res : [PieceR]

    private enum ReserveError: Error {
        case itemNotInRes
    }
    
    public init() {
        self.res = [PieceR]()
    }

    public mutating func ajouterPiece(piece : PieceR) {
        self.res.append(piece)
    }

    func searchPieceNom(nom : String, joueur : Joueur) -> PieceR? {
        for piece in self.res {
            if (piece.nom == nom) && (piece.joueur.nombre == joueur.nombre) {
                return piece
            } else {
                return nil
            }
        }
    }

    public mutating func enlevePiece(nomPiece : String) throws {
        let pieceRemoved = self.res.filter { $0.nom == nomPiece }
        if pieceRemoved.isEmpty {
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

    public mutating func next() -> PieceR? {
        if self.counter < self.resIt.res.count {
            let current : Int = self.counter
            self.counter += 1
            return self.resIt.res[current]
        } else {
            return nil
        }
    }

}