/*
Signature : void crtFilter(Image& img, int scanlineSpacing)

Paramètres :
img : la référence vers l’image à modifier (sur place)
scanlineSpacing : espacement entre les lignes que l’on va dessiner sur l’image pour l’effet CRT


Description : Cette fonction applique un filtre global à une image afin de reproduire l’apparence d’un ancien écran CRT. Elle combine les deux fonctions précédentes.
Il faut parcourir TOUS les pixels et appliquer les traitements suivants:
1.	Appeler applyScanline() 
    	Si la ligne y est un multiple de scanlineSpacing on applique un assombrissement de 60 %.

2.	Appler applyPhosphor()
        Le paramètre subpixel est déterminé par la position horizontale du pixel : x % 3

*/
.data   

full_color:
    .int 100

less_color:
    .int 60

max_index:
    .int 3

.text 
.globl crtFilter                      

crtFilter:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    # TODO
    # Réserver 3 variables locales
    addl $8, %esp
    pushl %ebx
    pushl %edi
    pushl %esi

    # Placer l'adresse de l'image dans eax et le facteur de Scanline dans ebx
    movl 8(%ebp), %eax
    movl 12(%ebp), %ebx

    # Placer la hauteur de l'image dans la première variable locale
    movl 4(%eax),%esi
    movl %esi, -4(%ebp)

    # Placer l'entité tableau de pointeurs de lignes de pixels dans ecx
    movl 8(%eax), %ecx

    iteration_hauteur:
    # Placer la largeur de l'image dans la deuxième variable locale
    movl (%eax), %edi
    movl %edi, -8(%ebp)
    # Placer l'indice de la ligne de pointeurs courante
    pushl %eax
    movl -4(%ebp), %eax
    movl -4(%ecx, %eax, 4), %edx
    popl %eax
    
    iteration_largeur:
    # Placer le pointeur du pixel courant dans esi
    pushl %eax
    movl -8(%ebp), %eax
    movl -4(%edx, %eax, 4), %esi
    popl %eax

    verification_Scanline:
    cmpl %ebx, -4(%ebp)
    jne appel_Phosphor

    appel_Scanline:
    # Appel de scanline
    pushl %eax
    pushl %edx
    pushl %ecx
    pushl less_color
    pushl %esi
    call applyScanline
    addl $8, %esp
    popl %ecx
    popl %edx
    popl %eax

    appel_Phosphor:
    # Calcul du subpixel
    pushl %eax
    pushl %edx
    movl -8(%ebp), %eax
    divl max_index
    movl %edx, %edi
    popl %edx
    popl %eax
    # Appel de phosphor
    pushl %eax
    pushl %edx
    pushl %ecx
    pushl %edi
    pushl %esi
    call applyPhosphor
    addl $8, %esp
    popl %ecx
    popl %edx
    popl %eax

    incrementation_largeur:
    # Note : tester dec si tout fonctionne
    subl $1, -8(%ebp)
    cmpl $0, -8(%ebp)
    jne iteration_largeur

    incrementation_hauteur:
    subl $1, -4(%ebp)
    cmpl $0, -4(%ebp)
    jne iteration_hauteur


    fin:

    popl %esi
    popl %edi
    popl %ebx
    # Libérer les variables locales
    movl %ebp, %esp
    # epilogue
    leave 
    ret 

