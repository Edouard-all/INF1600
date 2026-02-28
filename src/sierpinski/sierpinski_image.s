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

    # Réserver 2 variables locales
    subl $8, %esp
    pushl %ebx
    pushl %edi
    pushl %esi

    // mettre l'image dans eax
    movl 20(%ebp), %eax

    // Itération

    // mettre size dans %edi
    movl 12(%ebp), %edi
    // vérifier les bornes
    // mettre x, y dans ebx, ecx
    movl 8(%ebp), %ebx
    movl 12(%ebp), %ecx
    cmpl (%eax), %ebx
    jae retour
    cmpl 4(%eax), %ecx
    jae retour

    // Cas de base
    cmpl $1, %edi
    // Dessiner le pixel
    movl (%eax, %ecx, 4), %edx
    movl (%edx, %ebx, 4), %esi
    movl 24(%ebp), %esi
    jmp retour

    // traiter la size
    pushl %eax
    pushl %edx
    movl $0, %edx
    movl %edi, %eax
    pushl %esi
    movl $2, %esi
    divl %esi
    popl %esi
    movl %eax, %edi
    popl %edx
    popl %eax

    // appels récursifs
    pushl %eax
    pushl %ebx
    pushl %ecx
    //triangle en bas à gauche
    pushl 24(%ebp)
    pushl %eax
    pushl %edi
    addl %edi, %ecx
    pushl %ecx
    pushl %ebx
    call sierpinskiImage
    addl $20, %esp

    // Triangle en bas à droite
    popl %ecx
    popl %ebx
    popl %eax
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl 24(%ebp)
    pushl %eax
    pushl %edi
    addl %edi, %ecx
    pushl %ecx
    addl %edi, %ebx
    pushl %ebx
    call sierpinskiImage
    addl $20, %esp

    // triangle du haut
    popl %ecx
    popl %ebx
    popl %eax
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl 24(%ebp)
    pushl %eax
    pushl %edi
    pushl %ecx
    movl $0, %edx
    movl %edi, %eax
    pushl %esi
    movl $2, %esi
    divl %esi
    popl %esi
    addl %eax, %ebx
    pushl %ebx
    call sierpinskiImage
    addl $20, %esp
    popl %ecx
    popl %ebx
    popl %eax




    retour:


    popl %esi
    popl %edi
    popl %ebx
    # epilogue
    leave 
    ret   

