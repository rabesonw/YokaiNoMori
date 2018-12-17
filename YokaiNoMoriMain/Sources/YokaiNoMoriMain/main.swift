import Foundation
import YokaiNoMoriTypes

// afficheTableCourante : tableDeJeu ->
// une fonction qui, apres chaque tour, montre la table de jeu aux joueurs
func afficheTableCourante(tdj : tableDeJeu) {
    print("______ETAT COURANT______")
    print("X : 1 \t 2 \t 3 \t")
    for i in 1...4 {
        print("Y : " + i)
        for j in 1...3 {
            if let pc = tdj.searchPiecePosition(i, j){
                if(pc.joueur == tdj.joueur1){
                  print(pc.nom + " j1| \t")  
                }
                else {
                    print(pc.nom + " j2| \t")
                }
            }
            else {
                print(" | \t")
            }
            
        }
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

// parseCommandJoueur: tableDeJeu x Joueur x String -> Boolean
// une fonction qui parse et execute la commande pris, en appelant les fonctions necessaires pour
// l’executer. 
// Pre : aucune
// Post : Retourne true si l’action est valide, false sinon
func parseCommandeJoueur(tdj : tableDeJeu, joueur: Joueur, cmd : String) -> Bool {

    // cmda = array de mots dans cmd (‘deplacer 1 2 3 4’ devient [‘deplacer’ , ‘1‘, ’2’ , ‘3’, ‘4’ ])
    var cmda = cmd.components(separatedBy: " ")
    switch (cmda[0]) {
        
    case "deplacer":
        let x1s : Int? = Int(cmda[1])
        let y1s : Int? = Int(cmda[2])
        let x2s : Int? = Int(cmda[3])
        let y2s : Int? = Int(cmda[4])
        
        if let x1 = x1s, let y1 = y1s, let x2 = x2s, let y2 = y2s {
            if let piece = tdj.searchPiecePosition(coordX : x1, coordY : y1) {
                if (tdj.validerDeplacement(Piece : piece, neufX : x2, neufY : y2)){
                    tdj.deplacerPiece(Piece : piece, neufX : x2, neufY : y2)
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
            if let piece = tdj.searchPiecePosition(coordX : x1, coordY : y1) {
                if (tdj.validerCapture(Piece : piece, neufX : x2, neufY : y2)){
                    tdj.capturerPiece(Piece : piece, neufX : x2, neufY : y2)
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
            
            if(joueur == tdj.joueur1){
                if let piece = tdj.reserve1.searchPieceNom(nom) {
                    do{
                        try tdj.parachuter(piece : piece , neufX : x, neufY : y)
                    } catch {
                        return false
                    }
                }
                else {
                    return false
                }
            }
            else {
                if let piece = tdj.reserve2.searchPieceNom(nom) {
                    do{
                        try tdj.parachuter(piece : piece , neufX : x, neufY : y)
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
}

// La partie principale : 

var tdj = tableDeJeu()

// La boucle principale : 
while(true){
    var cmd : String?;
    var cmd2 : String;

    // Pour joueur 1
    while(true) {
        print("Ecrivez votre action : ")
        cmd = readLine()
		if let cmd2 = cmd {
			if(parseCommandeJoueur(tdj : tdj, joueur: tdj.j1, cmd : cmd)) {
				break;
			}
            else {
                print("Veuillez reesayez.")
            }
		}

    }

    if (tdj.gagnerPartie(tdj.j1)){
        print("Joueur 1 a gagne ! ")
        break;
    }

    // Pour joueur 2
    while(true) {
        print("Ecrivez votre action : ")
        cmd = readLine()
		if let cmd2 = cmd {
			if(parseCommandeJoueur(tdj : tdj, joueur: tdj.j2, cmd : cmd)) {
				break;
			}
            else {
                print("Veuillez reesayez.")
            }
		}

    }

    if ( tdj.gagnerPartie(tdj.j2)){
        print("Joueur 2 a gagne ! ")
        break;
    }
}
