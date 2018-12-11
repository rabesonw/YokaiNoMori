import Foundation
import YokaiNoMoriTypes

// Fonctions pour verifier les fonctions du tableDeJeuProtocol :

func verifSearchPiecePosition() -> Int {
    var ret  : Int = 0
    var tdj = tableDeJeu()

    // La position indiquee doit etre dans la tdj :
    if let piece = tdj.searchPiecePosition(coordX : -1 , coordY : 5){
        print("[searchPiecePosition] est mal definie pour des parametres <1 ou >4.")
        ret = ret + 1;
    }
    else {
        print("[searchPiecePosition] est bien definie pour des parametres <1 ou >4.")
    }

    // La position doit indiquer une case non vide :
    if let piece = tdj.searchPiecePosition(coordX :1, coordY :2){
        print("[searchPiecePosition] est mal definie pour des cases vides.")
        ret = ret + 1
    }
    else {
        print("[searchPiecePosition] est bien definie pour des cases vides.")
    }

    // La piece renvoyee est la bonne:
    if let piece = tdj.searchPiecePosition(coordX :2, coordY :2){
        if(piece.nom == "kodama" ){
            print("[searchPiecePosition] trouve correctement les pieces.")
        }
        else {
            print("[searchPiecePosition] ne trouve pas correctement les pieces.")
            ret = ret + 1
        }
    }

    return ret
}

func verifSearchPieceNJ() -> Int{
    var ret  : Int = 0;
    var tdj = tableDeJeu();

    // Le nom ne doit pas etre vide :
    if let piece = tdj.searchPieceNJ(nom : "" , joueur : tdj.j1 ){
        print("[searchPieceNJ] est mal definie pour un nom vide.")
        ret = ret + 1;
    }
    else {
        print("[searchPieceNJ] est bien definie pour un nom vide.")
    }
    
    // Le nom de joueur doit etre valide :
    if let piece = tdj.searchPieceNJ(nom :"kitsunette", joueur : tdj.j1){
        print("[searchPieceNJ] mal definie pour nom de piece invalide.")
        ret = ret + 1
    }
    else {
        print("[searchPieceNJ] bien definie pour nom de piece invalide.")
    }

    // Bonne entree, test du renvoie :
    if let piece = tdj.searchPieceNJ(nom :"kitsune", joueur : tdj.j1){
        if(piece.coordX == 3  && piece.coordY == 1) {
            print("[searchPieceNJ] bien definie pour donnees valides.")
        }
        else {
                print("[searchPieceNJ] mal definie pour donnees valides  : ne renvoie pas la bonne piece.")
                ret = ret + 1
            }
    }
    
    else {
        print("[searchPieceNJ] mal definie pour donnees valides : il renvoie Vide.")
        ret = ret + 1
    }
    
    return ret
}

func verifPositionsPossibles() -> Int {

    var ret  : Int = 0
    var tdj  = TableDeJeu()
    var pc = tdj.searchPiecePosition(coordX : 1, coordY : 1) // tanuki de j1
    var cpp = tdj.positionsPossibles(Piece : pc)
    
    // doit compter toutes les positions
    if (cpp.countPositions() == 0) {
        print("[positionsPossibles] Il y a des positions que vous n’avez pas trouve.")
    }
    // on ne peut pas aller sur une de nos propres pieces
    for position in cpp {
        let (x , y) = position
        if( x == 1 && y == 2){
            print("[positionsPossibles] Vous avez bien trouve une position possible.")
        }
        else if(x == 2 && y == 1) {
                print("[positionsPossibles] Il y a deja une piece ici.")
                ret = ret + 1
            } 
            else {
                print("[positionsPossibles] Vous n’avez pas respecte les regles du jeu, votre piece ne peux pas se deplacer la, meme si la case est vide.") // depend du nom de la piece
                ret = ret + 1
            }
    }
    return ret
}

func verifValiderDeplacement() -> Int {
    var ret  : Int = 0
    var tdj = TableDeJeu()
    var pc = tdj.searchPiecePosition(coordX : 1, coordY : 1) // tanuki de j1
    
    // Premier cas  : la case ou on veut deplacer n’est pas vide
    var x = tdj.validerDeplacement(piece :pc, coordX :2, coordY :1)
    if(x == true){
        print("[validerDeplacement] On ne peux pas deplacer sur une autre piece amie : mal defini.")
        ret = ret + 1
    }
    else {
        print("[validerDeplacement] Bien definie pour les cases deja occupees par nous-meme.")
    }
    
    // Deuxieme cas  : la case est vide, mais pas atteignable
    x = tdj.validerDeplacement(piece : pc, coordX : 1, coordY : 3)
    if(x==true){
        print("[validerDeplacement] On ne peux pas deplacer sur les cases vides, mais pas touchables! Mal defini.")
        ret = ret + 1
    }
    else {
        print("[validerDeplacement] Bien definie pour les cases vides et pas touchables.")
    }
    
    // Troisieme cas  : la case est vide et atteignable
    x = tdj.validerDeplacement(piece :pc, coordX :1, coordY :2)
    if(x==false){
        print("[validerDeplacement] On peux deplacer sur les cases touchables et vides! Mal defini.")
        ret = ret + 1
    }
    else {
        print("[validerDeplacement] Bien definie pour les cases touchables et vides.")
    }
    
    // quatrieeme  : positions invalides
    x = tdj.validerDeplacement(piece :pc, coordX :2, coordY :7)
    if(x == true){
        print("[validerDeplacement] Mal defini pour positions invalides.")
        ret = ret + 1
    }
    else {
        print("[validerDeplacement] Bien definie pour positions invalides.")
    }
    
    return ret
}

func verifDeplacerPiece() -> Int {
    
    // mutating func deplacerPiece(piece : Piece, xApres  : Int, yApres  : Int)
    var ret  : Int = 0
    var tdj = TableDeJeu()
    var pc = tdj.searchPiecePosition(coordX  : 1,coordY  : 1) // tanuki de j1
    var tdj2 = tdj.deplacerPiece(piece : pc, xApres : 1 , yApres : 2)
    var tdj3 = tdj.deplacerPiece(piece : pc, xApres : 2 , yApres : 1)
    
    // La tdj doit avoir change apres le deplacement
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

func verifValiderCapture() -> Int {
    var ret  : Int = 0
    var tdj = TableDeJeu()
    var pc = tdj.searchPiecePosition(coordX : 1, coordY : 1) // tanuki de j1
    
    // Premier cas  : la piece que l'on veut capturer ne peut pas etre a nous
    var x = tdj.validerCapture(piece :pc, coordX :2, coordY :1)
    if(x == true){
        print("[validerCapture] On ne peux pas capturer une autre piece amie: mal definie.")
        ret = ret + 1
    }
    else {
        print("[validerCapture] Bien definie pour les cases occupees de nous.")
    }
    
    // Deuxieme cas  : la piece est a l'ennemi, mais pas atteignable
    x = tdj.validerCapture(piece : pc, coordX : 1, coordY : 4)
    if(x == true){
        print("[validerCapture] On ne peux pas capturer sur les cases ennemies, mais pas touchables: mal definie.")
        ret = ret + 1
    }
    else {
        print("[validerCapture] Bien definie pour les cases ennemies et pas touchables.")
    }
    
    // troisieme cas  : la case est ennemi et atteignable
    pc = tdj.searchPiecePosition(coordX : 2, coordY : 2) // kodama de j1
    x = tdj.validerCapture(piece : pc, coordX : 2, coordY : 3)
    if(x == false){
        print("[validerCapture] On peux attaquer les cases touchables et ennemies! Mal defini.")
        ret = ret + 1
    }
    else {
        print("[validerCapture] Bien definie pour les cases touchables et ennemies.")
    }
    
    // quatrieme cas : les positions sont invalides
    x = tdj.validerCapture(piece :pc, coordX :2, coordY :7)
    if(x == true){
        print("[validerCapture] Mal defini pour une position invalide.")
        ret = ret + 1
    }
    else {
        print("[validerCapture] Bien definie pour une position invalide.")
    }
    
    return ret
}

func verifGagnerPartie() -> Int {
    var ret  : Int = 0
    var tdj = TableDeJeu()
    
    // en debut de partie, on a pas de gagnant
    if (tdj.gagnerPartie(joueur : tdj.joueur1) || tdj.gagnerPartie(joueur : tdj.joueur2)){
        print("[gagnerPartie] En debut de partie il n’y a pas de gagnant, gagnerPartie mal definie.")
        ret = ret + 1
    }
    else{
        print("[gagnerPartie] En debut de partie il n’y a pas de gagnant, gagnerPartie bien definie.")
    }
    
    return ret
    
}

func verifTransformerKodama() -> Int {
    var ret  : Int = 0
    var tdj = TableDeJeu()
    
    var pc = tdj.searchPiecePosition(coordX : 1, coordY : 1)
    
    //La piece doit etre un kodama
    do{
        try tdj.trasformerKodama(pc)
        print("[transformerKodama] On ne peux pas transformer une piece qui n'est pas un kodama: mal definie.")
        ret = ret + 1
    }
    catch{
        print("[transformerKodama] On ne peux pas transformer une piece qui n'est pas un kodama: bien definie.")
    }
    
    //Il faut que le kodama en question soit dans la zone de promotion
    pc = tdj.searchPiecePosition(coordX : 2, coordY : 2)
    do{
        try tdj.trasformerKodama(pc)
        print("[transformerKodama] On ne peux pas transformer une kodama qui n'est pas dans la zone de promotion: mal definie.")
        ret = ret + 1
    }
    catch{
        print("[transformerKodama] On ne peux pas transformer une kodama qui n'est pas dans la zone de promotion: bien definie.")
    }
    return ret
}

func verifParachuter() -> Int {
    
    var ret  : Int = 0
    var tdj = TableDeJeu()
    var pc : Piece = tdj.searchPieceNJ(nom: "kodama", joueur : tdj.j1)
    
    // A l'etat inintial il n'y a rien dans la reserve, donc pas de parachutage possible
    do{
        try tdj.parachuter(nomPiece: "kodama", tdj.joueur1, neufX : 1, neufY : 2)
        print("[parachuter] On ne peut pas parachuter un element sans qu’il ne soit dans la reserve, meme si la case est vide.")
        ret = ret + 1
    }
    catch{
        print("[parachuter] Bien definie pour les pieces non existantes dans la reserve.")
    }
    
    
    tdj = tdj.attaquerPiece(pieceAttaquante : pc, xApres : 2, yApres : 3)
    var pc2 : Piece = tdj.searchPieceNJ("kodama", joueur : tdj.j1, estEnReserve : true)
    
    //Une piece peut etre parachutee sur une case vide
    do{
        try tdj.parachuter(nomPiece: "kodama", joueur : tdj.joueur1, neufX : 1, neufY : 2)
        print("[parachuter] Bien definie pour les pieces existantes dans la reserve et mises sur des cases vides.")
    }
    catch{
        print("[parachuter] Mal definie pour les pieces existantes dans la reserve et mises sur des cases vides.")
        ret = ret + 1
    }
    //Une piece ne peut pas etre parachutee sur une case non vide
    do{
        try tdj.parachuter(nomPiece: "kodama", joueur : tdj.joueur1, neufX : 3, neufY : 1)
        print("[parachuter] Mal definie pour les pieces existantes dans la reserve et mises sur des cases non vides.")
        ret = ret + 1
    }
    catch{
        print("[parachuter] Bien definie pour les pieces existantes dans la reserve et mises sur des cases vides.")
    }
    
    return ret
    
}

func verifEstEnPromotion() -> Int {
    
    var ret  : Int = 0
    var tdj = TableDeJeu()
    var pc : Piece = tdj.searchPiecePosition(coordX : 1 , coordY : 1)
    
    // en debut de partie on doit verifier que les pieces d'un joueur ne sont pas dans la zone de promotion
    if(tdj.estEnPromotion(pc)){
        print("[estEnPromotion] Mal definie.")
        ret = ret + 1
    }
    else{
        print("[estEnPromotion] Bien definie.")
    }
    
    return ret
    
}
