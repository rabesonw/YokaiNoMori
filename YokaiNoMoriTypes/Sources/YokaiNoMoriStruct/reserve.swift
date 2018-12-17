import YokaiNoMoriTypes

public struct Reserve : reserveProtocol {

    var res : [Piece]

    enum ReserveError: Error {
        case itemNotInRes
    }
    
    public init() {
        self.res = [Piece]()
    }

    public mutating func ajouterPiece(piece : Piece) {
        self.res.append(Piece)
    }

    public func searchPieceNom(nom : String, joueur : Joueur) -> Piece? {
        for piece in self.res {
            if (piece.nom == nom) && (piece.joueur == joueur) {
                return piece
            } else {
                return nil
            }
        }
    }

    public mutating func enlevePiece(nomPiece : String) throws {
        var tab = self.res
        self.res = self.res.filter { $0.nom == nomPiece } 
        if tab == self.res {
            throw ReserveError.itemNotInRes
        }
    }

    public func makeIterator() -> reserveIterator {
        return reserveIterator(self.res)
    }
}

public struct reserveIterator : reserveIterateurProtocol {

    init(_ res: [Piece]) {

    }

    public func next() -> Piece? {

    }

}