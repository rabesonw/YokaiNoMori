import YokaiNoMoriTypes.joueurProtocol

public struct joueur : joueurProtocol {
    private var nb

    // le nombre du joueur, en general c'est 1 ou 2
    var nombre : Int{
      get {
        return self.nb
      }
    }

    // creation d’un joueur, avec un nombre donne
    // init : Int -> Joueur
    init(nombre : Int) {
      self.nb = nombre
    }
}
