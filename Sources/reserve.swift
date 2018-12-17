import YokaiNoMoriTypes.reserveProtocol

public struct reserve : Sequence, reserveProtocol {
    var res = [Piece]

    init() {
    }

    mutating func ajouterPiece(piece : Piece) {

    }

    func searPieceNom(nom : String, joueur : Joueur) -> Piece? {

    }

    mutating func enlevePiece(nomPiece : String) throws {

    }

    func makeIterator() -> reserveIteratorProtocol {

    }
}

struct reserveIteratorProtocol : IteratorProtocol {

    func next() -> Piece? {

    }

}