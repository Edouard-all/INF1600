/*
Signature: void applyPhosphor(applyScanline& p, int percent);

Paramètres:
p : la référence vers le pixel à modifier (sur place)
percent : facteur d’assombrissement

Description : Cette fonction applique un facteur d’assombrissement à un pixel en multipliant chacune de ses composantes RGB par un pourcentage donné: nouvelle_valeur = valeur_orignale x percent / 100
*/    
.data 

percent_conversion: 
.int 100

.text 
.globl applyScanline                      

applyScanline:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    # TODO
    pushl %ebx
    pushl %edi
    pushl %esi

    # placer l'adresse du pixel dans edi
    movl 8(%ebp), %edi   
    # placer le pourcentage d'assombrissement dans ebx
    movl 12(%ebp), %ebx  

    movl $3, %ecx
    iteration:
    movl $0, %eax
    # Déplacer l'octet d'une couleur du pixel dans al
    movb -1(%edi, %ecx, 1), %al     
    mull %ebx
    movl $0, %edx
    # multiplication de l'octet d'une couleur du pixel par le facteur d'assombrissement
    divl percent_conversion
    # Replacer la nouvelle valeur de couleur                  
    movb %al, -1(%edi, %ecx, 1)    
    loop iteration





    popl %esi
    popl %edi
    popl %ebx

    # epilogue
    leave 
    ret   

