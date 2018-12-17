import Foundation


/////////////////////////// --- Tests Table de jeu --- /////////////////////////////////////// 


func verifSearchPiecePosition() -> Int {
    var ret  : Int = 0;
    var tdj = tableDeJeu();

    // Premier cas  : 
    if let piece = tdj.searchPiecePosition(coordX : -1 , coordY : 5){
        print("[searchPiecePosition] Mal definie pour parametres <1 ou >4")
        ret = ret + 1;
    }
    else {
        print("[searchPiecePosition] Bien definie pour parametres <1 ou >4")
    }

    // Deuxieme cas  :
    if let piece = tdj.searchPiecePosition(coordX :1, coordY :2){
        print("[searchPiecePosition] trouve une piece dans une case theoretiquement vide")
        ret = ret + 1
    }
    else {
        print("[searchPiecePosition] bien definie pour cases vides")
    }

    // Troisieme cas  : 
    if let piece = tdj.searchPiecePosition(coordX :2, coordY :2){
        if(piece.nom == "kodama" ){
            print("[searchPiecePosition] trouve correctement les pieces")
        }
        else {
            print("[searchPiecePosition] ne trouve pas correctement les pieces")
            ret = ret + 1
        }
    }

    return ret
}



func verifPositionsPossibles() -> Int {

    var ret  : Int = 0
    var tdj  = TableDeJeu()
    var pc = tdj.searchPiecePosition(coordX : 1, coordY : 1) // tanuki de j1
    var cpp = tdj.positionsPossibles(piece : pc)

    if (cpp.count() == 0) {
        print("Il y a des positions que vous n’avez pas trouve.")
    }

    for position in cpp {
        let (x , y) = position
        if( x == 1 && y == 2){
            print("Vous avez bien trouve une position possible.")
        }
        else if(x == 2 && y == 1) {
                print("Il y a deja une pièce de vous la-bas.")
                ret = ret + 1
            } 
            else {
                print("Vous n’avez pas respecte les regles de jeu, votre pièce ne peux pas se deplacer la, meme si la cas est vide.")
                ret = ret + 1
            }
    }
    return ret
}

func verifValiderActions() -> Int {
    var ret  : Int = 0
    var tdj = TableDeJeu()
    var pc = tdj.searchPiecePosition(coordX : 1, coordY : 1) // tanuki de j1
    
    // Premier cas  : la case ou on veut deplacer n’est pas vide
    var x = tdj.validerAction(piece :pc, coordX :2, coordY :1)
    if(x == true){
        print("On ne peux pas deplacer sur une autre pièce amie. Mal defini.")
        ret = ret + 1
    }
    else {
        print("Bien definie pour les cases deja occupees.")
    }

    // Deuxieme cas  : la case est vide, mais pas touchable
    x = tdj.validerAction(piece :pc,coordX :1,coordY :3)
    if(x==true){
        print("On ne peux pas deplacer sur les cases vides, mais pas touchables! Mal defini.")
        ret = ret + 1
    }
    else {
        print("Bien definie pour les cases vides et pas touchables.")
    }

    // troisieme cas  : la case est vide et touchable
    x = tdj.validerAction(piece :pc, coordX :1, coordY :2)
    if(x==false){
        print("On peux deplacer sur les cases touchables et vides! Mal defini.")
        ret = ret + 1
    }
    else {
        print("Bien definie pour les cases touchables et vides.")
    }

    // 4eme  : positions invalides
    x = tdj.validerAction(piece :pc, coordX :2, coordY :7)
    if(x == true){
        print("Mal defini pour positions invalides.")
        ret = ret + 1
    }
    else {
        print("Bien definie pour positions invalides.")
    }
 
    return ret       
}

func verifDeplacerPiece() -> Int {
    // mutating func deplacerPiece(piece : Piece, xApres  : Int, yApres  : Int)
    var ret  : Int = 0countPositions() 
    var tdj = TableDeJeu()
    var pc = tdj.searchPiecePosition(coordX  : 1,coordY  : 1) // tanuki de j1

    var tdj2 = tdj.deplacerPiece(piece : pc, xApres : 1 , yApres : 2)
    var tdj3 = tdj.deplacerPiece(piece : pc, xApres : 2 , yApres : 1)

    if(tdj2 == tdj){
        print("Mal defini pour deplacements valides")
        ret = ret + 1
    }

    if(tdj3 != tdj){
        print("Mal defini pour deplacements invalides")
        ret = ret + 1
    }

    return ret
}

func verifCapturerPiece() -> Int {
    var ret  : Int = 0
    var tdj = TableDeJeu()
    var piece = tdj.searchPiecePosition(coordX  : 1,coordY  : 1) // tanuki de j1
    
    // cas ou on ne peut pas se deplacer ici
    if (tdj.validerCapture(Piece : piece,neufX : 1,neufY : 2)){
        print("Mal definie : on ne peut pas capturer un ami.")
        ret = ret + 1
	}	
	else {
	print("Bien definie, on ne peut pas capturer un ami.")
	}

    //cas piece ennemie
    var piece = tdj.searchPiecePosition(coordX  : 2,coordY  : 2) // kodama de j1
	if (tdj.validerCapture(Piece : piece,neufX : 3,neufY : 2)){
        print("Bien definie : on peut capturer un ennemi.")
        ret = ret + 1
	}	
	else {
	print("Mal definie : on peut capturer un ennemi.")
	}
    return ret
}

func verifGagnerPartie() -> Int {
    var ret  : Int = 0
    var tdj = TableDeJeu()

    // en debut de partie, on a pas de gagnant
    if (tdj.gagnerPartie(joueur  : tdj.joueur1) || tdj.gagnerPartie(joueur  : tdj.joueur2)){
        print("En debut de partie il n’y a pas de gagnant, gagnerPartie mal definie.")
        ret = ret + 1
    }
    else{
        print("En debut de partie il n’y a pas de gagnant, gagnerPartie bien definie.")   
    }

    return ret

}

func verifTransformerKodama() -> Int {
    var ret  : Int = 0
    var tdj = TableDeJeu()

    var pc = tdj.searchPiecePosition(coordX : 1, coordY : 1)
    do{
        try tdj.tranformerKodama(pc)
        print("[transformerKodama] On ne peut pas transformer une piece qui n'est pas un kodama. Mal definie.")
        ret = ret + 1
    }
    catch{
        print("[transformerKodama] On ne peut pas transformer une piece qui n'est pas un kodama. Bien definie.")
    }

    pc = tdj.searchPiecePosition(coordX : 2, coordY : 2)
    do{
        try tdj.transformerKodama(pc)
        print("[transformerKodama] On ne peut pas transformer une kodama qui n'est pas dans la zone de promotion. Mal definie.")
        ret = ret + 1
    }
    catch{
        print("[transformerKodama] On ne peut pas transformer une kodama qui n'est pas dans la zone de promotion. Bien definie.")
    }

	pc.coordY = 4
	do{
        try tdj.transformerKodama(pc)
        print("[transformerKodama] Bien definie: un kodama en zone de promotion est bien transforme")
        ret = ret + 1
    }
    catch{
        print("[transformerKodama] Mal definie : un kodama en zone de promotion doit pouvoir etre transforme.")
    }

    return ret

	
}


func verifParachuter() -> Int {

    var ret  : Int = 0
    var tdj = TableDeJeu()
    var pc : Piece = tdj.reserve1.searchPieceNom(nom: "kodama", nbJoueur: 1)

    // maintenant il n’y a rien dans la réserve, c'est l'etat initiel
    do{
        try tdj.parachuter(nomPiece: "kodama", tdj.joueur1, neufX :1, neufY :2)
        print("[parachuter] On ne peut pas parachuter un element sans qu’il ne soit dans la reserve, meme si la case est vide.")
        ret = ret + 1
    }
    catch{
        print("[parachuter] Bien definie pour pieces non existant dans la reserve.")
    }

    return ret

}

func verifEstEnPromotion() -> Int {

    var ret  : Int = 0
    var tdj = TableDeJeu()
    var pc : Piece = tdj.searchPiecePosition(coordX : 1 , coordY : 1)

    if(tdj.estEnPromotion(pc)){
        print("[estEnPromotion] Mal definie.")
        ret = ret + 1
    }
    else{
        print("[estEnPromotion] Bien definie.")
    }

    return ret
}

/////////////////////////// --- Tests reserveProtocol --- ////////////////////////////////////// 

//on test ajouterPiece, et searchPiecePosition doit aussi marcher
func verifAjouterPiece() -> Int {
	var ret  : Int = 0
	var tdj = TableDeJeu()
	var pc : Piece = tdj.searchPiecePosition(coordX : 2 , coordY : 2)
	tdj.reserve2.ajouterPiece(pc)
	if let pc = tdj.reserve2.searPieceNom("kodama"){
		print("[ajouterPiece] Bien definie, la piece a ete mise en reserve")	
	}
	else{
		print("[ajouterPiece] Mal defini, la piece n'a pas ete mise en reserve")
		ret +=1
	}
	return ret
}

/////////////////////////// --- Tests pieceProtocol --- ////////////////////////////////////////

func verifCreationPiece() -> Int {
	var ret  : Int = 0
	var tdj = TableDeJeu()

	if let pc = Piece ("" , 2, 2, tdj.joueur1) {
		print("[initPiece] Mal definie pour nom vide")	
		ret = ret + 1
	}
	else{
		print("[initPiece] Bien definie pour nom vide")	
	}

	if let pc = Piece ("kitsunette" , 2, 2, tdj.joueur1) {
		print("[initPiece] Mal definie pour nom invalide")	
		ret = ret + 1
	}
	else{
		print("[initPiece] Bien definie pour nom invalide")	
	}

	if let pc = Piece ("kitsune" , -1, 2, tdj.joueur1) {
		print("[initPiece] Mal definie pour coordX invalide")	
		ret = ret + 1
	}
	else{
		print("[initPiece] Bien definie pour coordX invalide")	
	}

	if let pc = Piece ("kitsune" , 1, 5, tdj.joueur1) {
		print("[initPiece] Mal definie pour coordY invalide")	
		ret = ret + 1
	}
	else{
		print("[initPiece] Bien definie pour coordY invalide")	
	}

	if let pc = Piece ("kitsune" , 1, 2, nil) {
		print("[initPiece] Mal definie pour joueur nil")	
		ret = ret + 1
	}
	else{
		print("[initPiece] Bien definie pour joueur nil")	
	}


}

/////////////////////////// --- Tests collectionPositionProtocol --- ///////////////////////////

// Il n'y a pas de tests possibles ici non plus.

/////////////////////////// --- Application des tests --- ////////////////////////////////////// 

var resFinal : Int = 0
resFinal += verifSearchPiecePosition()
resFinal += verifPositionsPossibles()
resFinal += verifValiderActions()
resFinal += verifDeplacerPiece()
resFinal += verifCapturerPiece()
resFinal += verifGagnerPartie()
resFinal += verifTransformerKodama()
resFinal += verifParachuter()
resFinal += verifEstEnPromotion()
resFinal += verifAjouterPiece()
resFinal += verifCreationPiece() 

if resFinal == 0 {
    print("Tous les tests sont passes !")
} else{
    print("Quelques tests echoues. Regardez au-dessus pour details.")
}
