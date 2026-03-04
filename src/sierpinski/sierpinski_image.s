/*
Implementation en C:
void sierpinskiImage(uint32_t x, uint32_t y, uint32_t size, Image& img, Pixel color) {
    // vérifier les bornes
    if (x >= img.largeur || y >= img.hauteur) return;

    // Cas de base: dessiner un seul pixel
    if (size == 1) {
        img.pixels[y][x] = color;
        return;
    }

    uint32_t half = size / 2;

    // Triangle en bas à gauche
    sierpinskiImage(x, y + half, half, img, color);
    // Triangle en bas à droite
    sierpinskiImage(x + half, y + half, half, img, color);
    // Triangle du haut
    sierpinskiImage(x + half / 2, y, half, img, color);
}

L’algorithme fonctionne mieux avec des tailles puissances de 2.
L’appel de la fonction dans le main sera ainsi : sierpinskiImage(0, 0, 1024, img, color);
*/

.data 

.text 
.globl sierpinskiImage                      

sierpinskiImage:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    # TODO

    # réserver 2 variables locales
    subl $8, %esp
    # préserver les registres caller-save
    pushl %ebx
    pushl %edi
    pushl %esi

    # mettre l'image dans eax
    movl 20(%ebp), %eax

    # mettre la taille dans edi
    movl 12(%ebp), %edi
    # vérifier les bornes, retour si une des coordonnées est supérieure ou égale à la dimension de l'image correspondante
    # mettre x, y dans ebx, ecx
    movl 8(%ebp), %ebx
    movl 12(%ebp), %ecx
    cmpl (%eax), %ebx
    jae retour
    cmpl 4(%eax), %ecx
    jae retour

    # Cas de base
    cmpl $1, %edi
    # accéder au pixel
    movl 8(%eax, %ecx, 4), %edx
    movl (%edx, %ebx, 4), %esi
    # colorer le pixel
    movl 24(%ebp), %esi
    jmp retour

    # traiter la taille
    pushl %eax
    pushl %edx
    movl $0, %edx
    movl %edi, %eax
    pushl %esi
    movl $2, %esi
    divl %esi
    popl %esi
    # continuer avec la moitié de la taille
    movl %eax, %edi
    popl %edx
    popl %eax

    # Appels récursifs
    # sauvegarder les registres eax, ebx et ecx
    pushl %eax
    pushl %ebx
    pushl %ecx
    # triangle en bas à gauche
    # empiler les paramètres
    pushl 24(%ebp)
    pushl %eax
    pushl %edi
    addl %edi, %ecx
    pushl %ecx
    pushl %ebx
    # appel et nettoyage de la pile au retour
    call sierpinskiImage
    addl $20, %esp

    # triangle en bas à droite
    # restaurer la valeur des registres eax, ebx et ecx tout en les sauvegardant
    popl %ecx
    popl %ebx
    popl %eax
    pushl %eax
    pushl %ebx
    pushl %ecx
    # empiler les paramètres
    pushl 24(%ebp)
    pushl %eax
    pushl %edi
    addl %edi, %ecx
    pushl %ecx
    addl %edi, %ebx
    pushl %ebx
    # appel et nettoyage de la pile au retour
    call sierpinskiImage
    addl $20, %esp

    # triangle du haut
    # restaurer la valeur des registres eax, ebx et ecx tout en les sauvegardant
    popl %ecx
    popl %ebx
    popl %eax
    pushl %eax
    pushl %ebx
    pushl %ecx
    # empiler les paramètres
    pushl 24(%ebp)
    pushl %eax
    pushl %edi
    pushl %ecx
    # organiser la division de la taille par deux pour un passage de paramètres correct
    movl $0, %edx
    movl %edi, %eax
    pushl %esi
    movl $2, %esi
    divl %esi
    popl %esi
    addl %eax, %ebx
    pushl %ebx
    # appel et nettoyage de la pile au retour
    call sierpinskiImage
    addl $20, %esp
    # restaurer les registres eax, ebx et ecx
    popl %ecx
    popl %ebx
    popl %eax

    retour:
    # restaurer les registres caller-save
    popl %esi
    popl %edi
    popl %ebx
    # epilogue
    leave 
    ret   

