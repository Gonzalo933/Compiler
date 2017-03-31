#include <stdio.h>
#include <stdlib.h>
extern FILE * yyin;
extern FILE * yyout;
extern char * yytext;
extern int yyleng;
extern int columna;
extern int linea;
extern int flag;
extern int yyparse();
 /* en el main abrir los dos ficheros? ?  */
int main(int argc, char *argv[]) {
   // yyin = fopen(argv[1], "r");
if(argc != 3){
printf("Error en los argumentos.\n");
return -1;
}

	yyin=fopen(argv[1],"r");
if(yyin== NULL){
printf("Error al abrir el fichero de entrada.\n");
return -1;
}
    yyout = fopen(argv[2], "w");
if(yyout== NULL){
printf("Error al abrir el fichero de salida.\n");
return -1;
}
yyparse();
fclose(yyin);
fclose(yyout);
return 0;
}


