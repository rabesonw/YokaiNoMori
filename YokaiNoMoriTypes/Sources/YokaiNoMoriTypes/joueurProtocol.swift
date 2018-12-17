import Foundation

protocol joueurProtocol {

	// le nombre du joueur, en general c'est 1 ou 2
    var nombre : Int{get}

    // creation d’un joueur, avec un nombre donne
    // init : Int -> Joueur
    init(nombre : Int) 
}
