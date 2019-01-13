import Foundation
import YokaiNoMoriTypes
import YokaiNoMoriStruct

// afficheTableCourante : TableDeJeu ->
// une fonction qui, apres chaque tour, montre la table de jeu aux joueurs
func afficheTableCourante(tdj : TableDeJeu) {
    print("______ETAT COURANT______")
    print("Y :\t 1 \t 2\t 3 \t 4")
    var str : String
    for i in 1...3 {
      str = ""
        str = str + "X : \(i) \t"
        for j in 1...4 {
            if let pc = tdj.searchPiecePosition(i, j){
                if(pc.joueur.nombre == tdj.joueur1.nombre){
                  str = str + pc.nom.prefix(3) + " j1 | "
                }
                else {
                    str = str + pc.nom.prefix(3) + " j2 | "
                }
            }
            else {
                str = str + " \t | "
            }

        }
        print (str)
    }

    print("Reserve du joueur 1 : ")
    for piece in tdj.reserve1 {
        print(" , " + piece.nom)
    }

    print("Reserve du joueur 2 : ")
    for piece in tdj.reserve2 {
        print(" , " + piece.nom )
    }

}

// parseCommandJoueur: TableDeJeu x Joueur x String -> Boolean
// une fonction qui parse et execute la commande pris, en appelant les fonctions necessaires pour
// l’executer.
// Pre : aucune
// Post     print (self.tab): Retourne true si l’action est valide, false sinon
func parseCommandeJoueur(tdj : inout TableDeJeu, joueur: Joueur, cmd : String) -> Bool {

    // cmda = array de mots dans cmd (‘deplacer 1 2 3 4’ devient [‘deplacer’ , ‘1‘, ’2’ , ‘3’, ‘4’ ])
    var cmda = cmd.components(separatedBy: " ")
    switch (cmda[0]) {

    case "deplacer":
        let x1s : Int? = Int(cmda[1])
        let y1s : Int? = Int(cmda[2])
        let x2s : Int? = Int(cmda[3])
        let y2s : Int? = Int(cmda[4])

        if let x1 = x1s, let y1 = y1s, let x2 = x2s, let y2 = y2s {
            if let piece = tdj.searchPiecePosition(x1, y1) {
                print (piece)

                if (tdj.validerDeplacement(piece, x2, y2)){
                    tdj.deplacerPiece(piece, x2, y2)
                    return true
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
        }
        else {
            return false
        }


    case "capturer" :
        let x1s : Int? = Int(cmda[1])
        let y1s : Int? = Int(cmda[2])
        let x2s : Int? = Int(cmda[3])
        let y2s : Int? = Int(cmda[4])

        if let x1 = x1s, let y1 = y1s, let x2 = x2s, let y2 = y2s {
            if let piece = tdj.searchPiecePosition(x1, y1) {
                if (tdj.validerCapture(piece, x2, y2)){
                    tdj.capturerPiece(piece, x2, y2)
                    return true
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
        }
        else {
            return false
        }



    case "parachuter" :
        let noms : String? = cmda[1]
        let xs : Int? = Int(cmda[2])
        let ys : Int? = Int(cmda[3])

        if let x = xs, let y = ys, let nom = noms {

            if(joueur.nombre == tdj.joueur1.nombre){
                if let piece = tdj.reserve1.searchPieceNom(nom: nom, joueur: joueur) {
                    do{
                        try tdj.parachuter(piece , x, y)
                        return true
                    } catch {
                        return false
                    }
                }
                else {
                    return false
                }
            }
            else {
                if let piece = tdj.reserve2.searchPieceNom(nom: nom, joueur: joueur) {
                    do{
                        try tdj.parachuter(piece , x, y)
                        return true
                    } catch {
                        return false
                    }
                }
                else {
                    return false
                }
            }
        }

        else {
            return false
        }

    default :
        return false
    }
    return false
}

// La partie principale :

var tdj = TableDeJeu()

// La boucle principale :
while(true){
    var cmd : String?;
    //let cmd2 : String;

    // Pour joueur 1
    while(true) {
      afficheTableCourante(tdj: tdj)
        print("Ecrivez votre action : ")
        cmd = readLine()
		if cmd != nil {
			if(parseCommandeJoueur(tdj : &tdj, joueur: Joueur(nombre: tdj.joueur1.nombre), cmd : cmd!)) {
				break;
			}
            else {
                print("Veuillez reesayez.")
            }
		}

    }

    if (tdj.gagnerPartie(tdj.joueur1)){
        print("Joueur 1 a gagne ! ")
        break;
    }

    // Pour joueur 2
    while(true) {
      afficheTableCourante(tdj: tdj)
        print("Ecrivez votre action : ")
        cmd = readLine()
		if cmd != nil {
			if(parseCommandeJoueur(tdj : &tdj, joueur: Joueur(nombre: tdj.joueur2.nombre), cmd : cmd!)) {
				break;
			}
            else {
                print("Veuillez reesayez.")
            }
		}

    }

    if ( tdj.gagnerPartie(tdj.joueur2)){
        print("Joueur 2 a gagne ! ")
        break;
    }
}
