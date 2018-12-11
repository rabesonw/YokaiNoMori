import Foundation

protocol joueurProtocol {
    var nombre : Int{get}

    // creation d’un joueur, avec un nombre donne
    // init : Int -> Joueur
    init(nombre : Int) 
}
