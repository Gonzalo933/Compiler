%{ 
#include <stdio.h> //no necesario
#include "tokens.h"
/*antes del punto poner el identificador, es decir si hace int hola, ese hola tendria que estar antes del punto ,pero ni puta idea de como ponerlo.*/
/*  el punto este se activa cuando es cualquier cosa menos \n, esta al final porque si estuviera el primero entraria siempre en el. se puede poner .* (error repetido muchas veces)*/
/* \n {}
\r {}
\t {}
" " {}
[ \n\r\t] {printf("espacio\n"); return;}

"//" {}
; { return TOK_PUNTOYCOMA;}
" " {printf("espacio\n"); return;}
[0-9a-zA-Z]* { return TOK_IDENTIFICADOR;}


extern int n_columnas y n_filas;
extern int yylex();
*/
%}
IDENTIFICADOR [0-9a-zA-Z]+
DIGITO [0-9]+
LETRA [a-zA-Z]
ESPACIO [ \n\r\t]
TODO [^\n]

%%
"//"({TODO})* {}
printf { return TOK_PRINTF; }
scanf { return TOK_SCANF; }
while { return TOK_WHILE; }
main { return TOK_MAIN; }
"=" { return TOK_ASIGNACION; }
"*" { return TOK_ASTERISCO; }
"+" { return TOK_MAS; }
"<=" {  return TOK_MENORIGUAL; }
"(" { return TOK_PARENTESISIZQUIERDO;}
")" { return TOK_PARENTESISDERECHO;}
"{" { return TOK_LLAVEIZQUIERDA;}
"}" { return TOK_LLAVEDERECHA;}
int{ESPACIO} { return TOK_INT;}
true { return TOK_TRUE;}
false { return TOK_FALSE;}
{DIGITO} { return TOK_CONSTANTE_ENTERA;}
{IDENTIFICADOR} { return TOK_IDENTIFICADOR;}
"," { return TOK_COMA; }
";" { return TOK_PUNTOYCOMA; }
{ESPACIO} {}
. {return TOK_ERROR;}
%%
 /* en el main abrir los dos ficheros? ?  */
int main(int argc, char *argv[]) {
    // yyin = fopen(argv[1], "r");
    //yyout = fopen("prueba_salida.txt", "w");

    int t;
    int seguir = 1;
    while (seguir == 1) {
        t = yylex();
        switch (t) {
            case 0:
                seguir = 0; /* Hay que cerrar yyout ?? */
                break;
            case TOK_PRINTF:
                // fprintf(yyout, "TOK_PRINTF\t%d\t%s\n", t,yytext);
                printf("TOK_PRINTF\t%d\t%s\n", t,yytext);
                break;
            case TOK_SCANF:
                printf("TOK_SCANF\t%d\t%s\n", t,yytext);
                break;
            case TOK_WHILE:
                printf("TOK_WHILE\t%d\t%s\n", t,yytext);
                break;
            case TOK_ASIGNACION:
                printf("TOK_ASIGNACION\t%d\t%s\n", t,yytext);
                break;
            case TOK_ASTERISCO:
                printf("TOK_ASTERISCO\t%d\t%s\n", t,yytext);
                break;
            case TOK_MAS:
                printf("TOK_MAS\t%d\t%s\n", t,yytext);
                break;
            case TOK_MENORIGUAL:
                printf("TOK_MENORIGUAL\t%d\t%s\n", t,yytext);
                break;
            case TOK_MAIN:
                // fprintf(yyout, "TOK_PRINTF\t%d\t%s\n", t,yytext);
                printf("TOK_MAIN\t%d\t%s\n", t,yytext);
                break;
            case TOK_PARENTESISIZQUIERDO:               
                printf("TOK_PARENTESISIZQUIERDO\t%d\t%s\n", t,yytext);
                break;
            case TOK_PARENTESISDERECHO:               
                printf("TOK_PARENTESISDERECHO\t%d\t%s\n", t,yytext);
                break;
            case TOK_LLAVEIZQUIERDA:               
                printf("TOK_LLAVEIZQUIERDA\t%d\t%s\n", t,yytext);
                break;
            case TOK_LLAVEDERECHA:               
                printf("TOK_LLAVEDERECHA\t%d\t%s\n", t,yytext);
                break;
	    case TOK_INT:               
                printf("TOK_INT\t%d\t%s\n", t,yytext);
                break;
	    case TOK_TRUE:               
                printf("TOK_TRUE\t%d\t%s\n", t,yytext);
                break;
	    case TOK_FALSE:               
                printf("TOK_FALSE\t%d\t%s\n", t,yytext);
                break;
	    case TOK_CONSTANTE_ENTERA:               
                printf("TOK_CONSTANTE_ENTERA\t%d\t%s\n", t,yytext);
                break;
	    case TOK_IDENTIFICADOR:               
                printf("TOK_IDENTIFICADOR\t%d\t%s\n", t,yytext);
                break;
	    case TOK_COMA:               
                printf("TOK_COMA\t%d\t%s\n", t,yytext);
                break;
	    case TOK_PUNTOYCOMA:               
                printf("TOK_PUNTOYCOMA\t%d\t%s\n", t,yytext);
                break;

        
            case TOK_ERROR:
                //  fprintf(yyout, "Error, mirar lo que hay que imprimir");
                printf("encontro ERROR\n");
                break;
            default:
                break;
        }

    }
    return;
}
int yywrap(){
return 1;
}
