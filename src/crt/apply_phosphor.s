/*
Signature: void applyPhosphor(Pixel& p, int subpixel);

Paramètres:
p : la référence vers le pixel à modifier (sur place)
subpixel : indice du pixel dominant

Description : Le paramètre subpixel détermine quelle composante reste dominante :
	si subpixel == 0 → le rouge est conservé, le vert et le bleu sont réduits à 70 % de leur valeur initiale.
	si subpixel == 1→ le vert est conservé, le rouge et le bleu sont réduits à 70 % de leur valeur initiale.
	sinon → le bleu est conservé, le rouge et le vert sont réduits à 70 % de leur valeur initiale.

Encore une fois, puisqu’on travaille avec des divisions entières, la réduction se fait avec la formule suivante : nouvelle_valeur = valeur_originale × 70 / 100


*/
.data 

offset:
    .int 3

factor:
    .int 70

percent_conversion: 
    .int 100
        
.text 
.globl applyPhosphor                      

applyPhosphor:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    # TODO
    pushl %ebx
    pushl %edi
    pushl %esi

    # placer l'adresse du pixel dans edi
    movl 8(%ebp), %edi   
    # placer le facteur de subpixel
    movl 12(%ebp), %ebx   

    # 2 couleurs à modifier dans tous les cas
    movl $2, %ecx
    comparaison:
    cmpl $0, %ebx
    je rouge
    cmpl $1, %ebx
    je vert
    jmp bleu

    rouge:
    movl $0, %eax
    # déplacer l'octet d'une couleur du pixel dans al
    movb (%edi, %ecx, 1), %al
    mull factor
    movl $0, %edx
    # multiplication de l'octet d'une couleur du pixel par le facteur d'assombrissement
    divl percent_conversion
    # replacer la nouvelle valeur de couleur                  
    movb %al, (%edi, %ecx, 1)
    loop rouge
    jmp fin

    vert:
    movl $0, %eax
    # déplacer l'octet d'une couleur du pixel dans al
    movb -2(%edi, %ecx, 2), %al
    mull factor
    movl $0, %edx
    # multiplication de l'octet d'une couleur du pixel par le facteur d'assombrissement
    divl percent_conversion
    # replacer la nouvelle valeur de couleur                  
    movb %al, -2(%edi, %ecx, 2)
    loop vert
    jmp fin    

    bleu:
    movl $0, %eax
    # déplacer l'octet d'une couleur du pixel dans al
    movb -1(%edi, %ecx, 1), %al
    mull factor
    movl $0, %edx
    # multiplication de l'octet d'une couleur du pixel par le facteur d'assombrissement
    divl percent_conversion
    # replacer la nouvelle valeur de couleur                  
    movb %al, -1(%edi, %ecx, 1)
    loop bleu
    jmp fin

    fin:

    popl %esi
    popl %edi
    popl %ebx
    # epilogue
    leave 
    ret   

