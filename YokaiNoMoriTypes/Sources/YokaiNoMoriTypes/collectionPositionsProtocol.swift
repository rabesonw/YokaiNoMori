import Foundation

protocol collectionPositionsProtocol : Sequence {
    associatedtype IteratorPositions : IteratorProtocol where IteratorPositions.Element == (Int, Int) // touple qui est (coordX, coordY)

    // init : -> CollectionPositions
    // création d'une collection de positions
    init()

    // countPositions : CollectionPositions -> Int
    // renvoie le nombre des elements dans la collection (0 si c’est vide)
    func countPositions() -> Int

    // addPosition : collectionPositions x Int x Int -> CollectionPositions
    // ajoute un neuf touple (x,y) a la collection 
    // Pre : 1<= x <= 3
    // Pre : 1<= y <= 4
    // Pre : le touple (x,y) n’est pas deja dans la collection
	// Post : la collection a le nouveau touple (x,y) si les preconditions ont été respectées, sinon, rien n'est changé.
	@discardableResult
	mutating func addPosition(x : Int, y: Int) -> Self

	// removePosition : collectionPositions x Int x Int -> CollectionPositions
    // enleve un neuf touple (x,y) de la collection 
    // Pre : 1 <= x <= 3
    // Pre : 1 <= y <= 4
    // Pre : le touple (x,y) est dans la collection
	// Post : la collection avec le touple (x,y) efface si les preconditions ont été respectées, sinon, rien n'est changé.
	@discardableResult
	mutating func removePosition(x : Int, y: Int) -> Self
    
	// makeIterator : collectionPositionsProtocol -> IteratorPositions
    // crée un itérateur sur le collection pour itérer avec for in.
    func makeIterator() -> IteratorPositions
}

