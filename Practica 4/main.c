#include "alfa.h"
#include <stdio.h>
#include <stdlib.h>



extern FILE * yyin;
extern int yyparse ();
FILE* fSalida;
tablaHash *hashGlobal;
/*TablaHash tabla_global;*/

int main(int argc, char** argv) {


	if (argc != 3) {
		
		printf("Numero de argumentos incorrecto \n");
        	return -1;
    	}

		yyin=fopen(argv[1],"r");
		fSalida=fopen(argv[2],"w");
if(yyin == NULL || fSalida == NULL){
printf("Error en los ficheros de los argumentos.\n");
return -1;
}
		
		yyparse();
		fclose(yyin);
		fclose(fSalida);
	

	
	return 1;

}
