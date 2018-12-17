import YokaiNoMoriTypes

public struct joueur : joueurProtocol {
    private var nb : Int

    // le nombre du joueur, en general c'est 1 ou 2
    public var nombre : Int{
      get {
        return self.nb
      }
    }

    // creation d’un joueur, avec un nombre donne
    // init : Int -> Joueur
    public init(nombre : Int) {
      self.nb = nombre
    }
}
