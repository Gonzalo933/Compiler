#include <stdio.h>
#include <stdlib.h>
#include "tokens.h"
extern FILE * yyin;
extern int yylex();
extern char * yytext;
extern int yyleng;
extern int columna;
extern int linea;
 /* en el main abrir los dos ficheros? ?  */
int main(int argc, char *argv[]) {
    yyin = fopen(argv[1], "r");
    FILE *fsalida = fopen(argv[2], "w");

    int t;
    int seguir = 1;
    while (seguir == 1) {
        t = yylex();
        switch (t) {
            case 0:
                seguir = 0; /* Hay que cerrar fsalida ?? */
                break;
            case TOK_PRINTF:
                // fprintf(fsalida, "TOK_PRINTF\t%d\t%s\n", t,yytext);
                fprintf(fsalida, "TOK_PRINTF\t%d\t%s\n", t,yytext);
                break;
            case TOK_SCANF:
                fprintf(fsalida, "TOK_SCANF\t%d\t%s\n", t,yytext);
                break;
            case TOK_WHILE:
                fprintf(fsalida, "TOK_WHILE\t%d\t%s\n", t,yytext);
                break;
            case TOK_ASIGNACION:
                fprintf(fsalida, "TOK_ASIGNACION\t%d\t%s\n", t,yytext);
                break;
            case TOK_IGUAL:
                fprintf(fsalida, "TOK_IGUAL\t%d\t%s\n", t,yytext);
                break;
            case TOK_OR:
                fprintf(fsalida, "TOK_OR\t%d\t%s\n", t,yytext);
                break;
            case TOK_AND:
                fprintf(fsalida, "TOK_AND\t%d\t%s\n", t,yytext);
                break;
            case TOK_NOT:
                fprintf(fsalida, "TOK_NOT\t%d\t%s\n", t,yytext);
                break;
            case TOK_DISTINTO:
                fprintf(fsalida, "TOK_DISTINTO\t%d\t%s\n", t,yytext);
                break;
            case TOK_ASTERISCO:
                fprintf(fsalida, "TOK_ASTERISCO\t%d\t%s\n", t,yytext);
                break;
            case TOK_DIVISION:
                fprintf(fsalida, "TOK_DIVISION\t%d\t%s\n", t,yytext);
                break;
            case TOK_MAS:
                fprintf(fsalida, "TOK_MAS\t%d\t%s\n", t,yytext);
                break;
            case TOK_MENOS:
                fprintf(fsalida, "TOK_MENOS\t%d\t%s\n", t,yytext);
                break;
            case TOK_MAYORIGUAL:
                fprintf(fsalida, "TOK_MAYORIGUAL\t%d\t%s\n", t,yytext);
                break;
            case TOK_MENORIGUAL:
                fprintf(fsalida, "TOK_MENORIGUAL\t%d\t%s\n", t,yytext);
                break;
            case TOK_MENOR:
                fprintf(fsalida, "TOK_MENOR\t%d\t%s\n", t,yytext);
                break;
            case TOK_MAYOR:
                fprintf(fsalida, "TOK_MAYOR\t%d\t%s\n", t,yytext);
                break;
            case TOK_MAIN:
                fprintf(fsalida, "TOK_MAIN\t%d\t%s\n", t,yytext);
                break;
            case TOK_PARENTESISIZQUIERDO:               
                fprintf(fsalida, "TOK_PARENTESISIZQUIERDO\t%d\t%s\n", t,yytext);
                break;
            case TOK_PARENTESISDERECHO:               
                fprintf(fsalida, "TOK_PARENTESISDERECHO\t%d\t%s\n", t,yytext);
                break;
            case TOK_LLAVEIZQUIERDA:               
                fprintf(fsalida, "TOK_LLAVEIZQUIERDA\t%d\t%s\n", t,yytext);
                break;
            case TOK_LLAVEDERECHA:               
                fprintf(fsalida, "TOK_LLAVEDERECHA\t%d\t%s\n", t,yytext);
                break;
            case TOK_CORCHETEIZQUIERDO:               
                fprintf(fsalida, "TOK_CORCHETEIZQUIERDO\t%d\t%s\n", t,yytext);
                break;
            case TOK_CORCHETEDERECHO:               
                fprintf(fsalida, "TOK_CORCHETEDERECHO\t%d\t%s\n", t,yytext);
                break;
	    case TOK_INT:               
                fprintf(fsalida, "TOK_INT\t%d\t%s\n", t,yytext);
                break;
	    case TOK_BOOLEAN:               
                fprintf(fsalida, "TOK_BOOLEAN\t%d\t%s\n", t,yytext);
                break;
	    case TOK_ARRAY:               
                fprintf(fsalida, "TOK_ARRAY\t%d\t%s\n", t,yytext);
                break;
	    case TOK_FUNCTION:               
                fprintf(fsalida, "TOK_FUNCTION\t%d\t%s\n", t,yytext);
                break;
	    case TOK_IF:               
                fprintf(fsalida, "TOK_IF\t%d\t%s\n", t,yytext);
                break;
	    case TOK_ELSE:               
                fprintf(fsalida, "TOK_ELSE\t%d\t%s\n", t,yytext);
                break;
	    case TOK_RETURN:               
                fprintf(fsalida, "TOK_RETURN\t%d\t%s\n", t,yytext);
                break;
	    case TOK_TRUE:               
                fprintf(fsalida, "TOK_TRUE\t%d\t%s\n", t,yytext);
                break;
	    case TOK_FALSE:               
                fprintf(fsalida, "TOK_FALSE\t%d\t%s\n", t,yytext);
                break;
	    case TOK_CONSTANTE_ENTERA:               
                fprintf(fsalida, "TOK_CONSTANTE_ENTERA\t%d\t%s\n", t,yytext);
                break;
	    case TOK_IDENTIFICADOR:               
                fprintf(fsalida, "TOK_IDENTIFICADOR\t%d\t%s\n", t,yytext);
if(yyleng > 100){ 
fprintf(fsalida,"\t**** Error en [lin %d, col %d]: identificador %s demasiado largo!!\n",linea,columna,yytext);
}
                break;
	    case TOK_COMA:               
                fprintf(fsalida, "TOK_COMA\t%d\t%s\n", t,yytext);
                break;
	    case TOK_PUNTOYCOMA:               
                fprintf(fsalida, "TOK_PUNTOYCOMA\t%d\t%s\n", t,yytext);
                break;

        
            case TOK_ERROR:                
	fprintf(fsalida, "TOK_ERROR\t%d\t%s\n", t,yytext);               
                fprintf(fsalida,"\t**** Error en [lin %d, col %d]: simbolo %s no permitido!!\n",linea,columna,yytext);
                break;
            default:
                break;
        }
columna=columna+yyleng;

    }
    return 1;
}
