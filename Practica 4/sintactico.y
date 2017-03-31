%{
#include <stdio.h>
#include <stdlib.h>
#include "alfa.h"
#include "generacion.h"
#include "y.tab.h"
#include <string.h>

#define TOK_ERROR -1


extern int yylex();
extern FILE * yyout;
extern int flag;
int yyerror(char *s);
extern int linea;
extern int columna;
extern char * yytext;
extern int yyleng;

extern FILE * fSalida;
/*Tabla de simbolos*/
tablaHash *hashLocal;
tablaHash *hashGlobal;
tablaHash *ambitoActual;
bool ambitoAbierto = false;

/*Declaracion de variables*/
int tipo_actual;
int clase_actual;
int tamanio_vector_actual;
int pos_variable_local_actual;
int num_parametros_actual;
int pos_parametro_actual;


/* LLamada a funcion*/
int num_parametros_llamada_actual;
int en_explist=0;
int funcion_return;
int etiqueta=0;
int num_variables_locales_actual;
char funcion_actual[80];
int enFuncion=0;
%}

%union
{

tipo_atributos atributos;

}
/*FALTAN TOKENS?????*/
%token TOK_MAIN
%token TOK_INT
%token TOK_BOOLEAN
%token TOK_ARRAY
%token TOK_FUNCTION
%token TOK_IF
%token TOK_ELSE
%token TOK_WHILE
%token TOK_SCANF
%token TOK_PRINTF
%token TOK_RETURN

%token TOK_PUNTOYCOMA
%token TOK_COMA
%token TOK_PARENTESISIZQUIERDO
%token TOK_PARENTESISDERECHO
%token TOK_CORCHETEIZQUIERDO
%token TOK_CORCHETEDERECHO
%token TOK_LLAVEIZQUIERDA
%token TOK_LLAVEDERECHA
%token TOK_ASIGNACION
%token TOK_MAS
%token TOK_MENOS
%token TOK_DIVISION
%token TOK_ASTERISCO
%token TOK_AND
%token TOK_OR
%token TOK_NOT
%token TOK_IGUAL
%token TOK_DISTINTO
%token TOK_MENORIGUAL
%token TOK_MAYORIGUAL
%token TOK_MENOR
%token TOK_MAYOR

%token <atributos> TOK_IDENTIFICADOR
%token <atributos> TOK_CONSTANTE_ENTERA
%token TOK_TRUE
%token TOK_FALSE

%type <atributos> exp asignacion
%type <atributos> comparacion

%type <atributos> tipo clase clase_escalar clase_vector identificador identificadores idpf
%type <atributos> fn_name fn_declaration idf_llamada_funcion
%type <atributos> parametro_funcion constante_logica constante constante_entera elemento_vector
%type <atributos> if_exp else_exp while_exp while_exp_exp
%left TOK_MAS TOK_MENOS TOK_OR
%left TOK_ASTERISCO  TOK_DIVISION TOK_AND

/* %right MU TOK_NOT*/
%right MU TOK_NOT
%start programa

%%


/*


TRANSPARENCIA 42 revisar mas adelante
TRANSPARENCIA 63 generacion codigo

*/




programa: inicioTabla TOK_MAIN TOK_LLAVEIZQUIERDA  declaraciones escritura_TS funciones escritura_main sentencias TOK_LLAVEDERECHA {


/*Fin programa SIN ERRORES*/

/*Esta esto bien aqui?*/
errores_fin(fSalida);
if(ambitoAbierto==true){
vaciarHash(hashLocal);
destruirHash(hashLocal);
}
vaciarHash(hashGlobal);
destruirHash(hashGlobal);

}
;
escritura_TS: {

	if(fSalida==NULL){
		printf("Error al abrir el fichero.\n");
		return -1;
	}    

mensajes_error(fSalida);
segmento_datos(hashGlobal,fSalida);
cabecera_codigo(fSalida);
}
;

escritura_main: {
etiqueta_main(fSalida);
}
;


inicioTabla: {  /* Inicializar Tabla simbolos , recordar que hay quel liberarla al final*/



hashGlobal = crearHash();
inicializarHash(hashGlobal);
    if (hashGlobal == NULL) {
printf("Error al crear las tablas de simbolos.");
        return -1;
    }
//ambito actual
    ambitoActual = hashGlobal;


 }
;

declaraciones: declaracion {}
|declaracion declaraciones {}
;

declaracion: clase identificadores TOK_PUNTOYCOMA {
/*parametros -> Tipo clase tamaño*/

}
;

clase: clase_escalar {clase_actual=CLASE_ESCALAR; tamanio_vector_actual=1;}
|clase_vector {clase_actual=CLASE_VECTOR;}
;

clase_escalar: tipo {}
;

tipo: TOK_INT {tipo_actual= TIPO_ENTERO;}
|TOK_BOOLEAN {tipo_actual=TIPO_LOGICO;}
;

clase_vector: TOK_ARRAY tipo TOK_CORCHETEIZQUIERDO TOK_CONSTANTE_ENTERA TOK_CORCHETEDERECHO {tamanio_vector_actual=$4.valor_entero;
if((tamanio_vector_actual < 1 )|| (tamanio_vector_actual > MAX_TAMANIO_VECTOR)){
flag=3;
yyerror("Error semantico en la declaracion del vector ");
return -1;
}

 }
;
identificadores: identificador {strcpy($$.lexema,$1.lexema);}
|identificador TOK_COMA identificadores {/*  çççç Completar mas tarde, pero esto seria devolver en $$.lexema todos los identificadores que se han declarado. separando strings con algo?¿  */}
;

funciones: funcion funciones {}
| {}
;


fn_name: TOK_FUNCTION tipo TOK_IDENTIFICADOR {

/* Se crea un nodo  de tipo funcion*/

nodo * node=crearNodoFuncion($3.lexema,tipo_actual,clase_actual,tamanio_vector_actual,0);



if(insertarElem($3.lexema, hashGlobal,node)==ERR){
printf("identificador %s duplicado",$3.lexema);
return -1;
}

ambitoAbierto = true;

hashLocal = crearHash();
inicializarHash(hashLocal);

ambitoActual = hashLocal;

insertarElem($3.lexema, ambitoActual, node);

num_variables_locales_actual=0;
num_parametros_actual=0;
pos_variable_local_actual=1;
pos_parametro_actual=0;
funcion_return = 0;

strcpy($$.lexema,$3.lexema);
strcpy(funcion_actual,$3.lexema);

}
;

fn_declaration: fn_name TOK_PARENTESISIZQUIERDO parametros_funcion TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA declaraciones_funcion {

/*buscar la funcion actual y meterle numero de parametros*/
nodo * nodoo=buscarNodo($1.lexema,hashGlobal);
nodo * node=buscarNodo($1.lexema,ambitoActual);

addNumeroParametros(nodoo,num_parametros_actual);
addNumeroParametros(node,num_parametros_actual);

addNumeroVariables(nodoo,num_variables_locales_actual);
addNumeroVariables(node,num_variables_locales_actual);


strcpy($$.lexema,$1.lexema);
gc_cuerpo_funcion(fSalida, $1.lexema, num_variables_locales_actual);
}
;

funcion: fn_declaration sentencias TOK_LLAVEDERECHA {
/*Cerrar ambito*/
                    if (ambitoAbierto == true) {
                        vaciarHashAux(hashLocal);
			destruirHash(hashLocal);
                        ambitoActual = hashGlobal;
                        ambitoAbierto = false;                        
                        //AMBITO CERRADO CON EXITO
                       
                    }
					
					if(funcion_return == 0){
							flag=3;
							yyerror("Error semantico funcion sin return");							
							return -1;
						}
	
/* num_parametros_actual a 0??? çç*/
/*addNumeroParametros(buscarNodo($1.lexema,ambitoActual),num_parametros_actual);*/


}
;




parametros_funcion: parametro_funcion resto_parametros_funcion {}
| {}
;

resto_parametros_funcion: TOK_PUNTOYCOMA parametro_funcion resto_parametros_funcion {}
| {}
;

parametro_funcion: tipo idpf {
}
;

declaraciones_funcion: declaraciones {}
| {}
;

sentencias: sentencia {}
|sentencia sentencias {}
;
sentencia: sentencia_simple TOK_PUNTOYCOMA {}
|bloque {}
;

sentencia_simple: asignacion {}
|lectura {}
|escritura {}
|retorno_funcion {}
;

bloque: condicional {}
|bucle {}
;

asignacion: TOK_IDENTIFICADOR TOK_ASIGNACION exp {
/*variable que indica si ha sido encontrado en la tabla global*/
int tabla_global;
nodo *node;



if(ambitoAbierto == true){
/*Buscar en las dos tablas*/
	node=buscarNodo($1.lexema, ambitoActual);

	if(node== NULL){
		node=buscarNodo($1.lexema, hashGlobal);
		if(node== NULL){
printf ( "     ****Error semántico en [lin %d, col %d]: identificador <%s> no declarado\n", linea,columna-yyleng,$1.lexema);			
				return -1;

			}
		//encontrado en la global
		tabla_global=1;
	}else{
	//encontrado en la tabla local
	tabla_global=0;
}


}else{
	node=buscarNodo($1.lexema, ambitoActual);
		if(node== NULL){
printf ( "     ****Error semántico en [lin %d, col %d]: identificador <%s> no declarado\n", linea,columna-yyleng,$1.lexema);				
				return -1;

			}
		tabla_global=1;
}


	
	/*encontrado*/

	if(esFuncion(node)==true){
		flag=3;
		printf("Error semantico %s es una funcion",$1.lexema);
		yyerror("");	
		return -1;
	}
	if(esVector(node)==true){
		flag=3;
		printf("Error semantico %s es un vector",$1.lexema);
		yyerror("");	
		return -1;
	}
	

	if(tipoNodo(node) != $3.tipo){
printf ( "     ****Error semántico en [lin %d, col %d]: asignacion invalida por tipos incompatibles\n", linea,columna-yyleng);
		return -1;	
	}
	
	$$.tipo=tipoNodo(node);
	$$.es_direccion=1;
	
	


	if(tabla_global == 0){	
	
	if(posicionParametro(node)==-1){
/*No es parametro*/
	
	gc_asignacion_funcion_variable(fSalida,$3.es_direccion,posicionVariable(node)); 

	

	}else{
/*Es parametro*/
	nodo * nodee=buscarNodo(funcion_actual,ambitoActual);
	gc_asignacion_funcion_parametro(fSalida, $3.es_direccion,posicionParametro(node),numVarLocales(nodee));	

	

	}		
	}else{ 

	/* identificador = constante*/
	gc_identificador_igual_identificador(fSalida, $3.es_direccion, $1.lexema);	
	}

	}
	

| elemento_vector TOK_ASIGNACION exp {

if($1.tipo != $3.tipo){
printf ( "     ****Error semántico en [lin %d, col %d]: asignacion invalida por tipos incompatibles\n", linea,columna-yyleng);
		return -1;
	
	}	
	gc_asignacion_elemento_vector(fSalida, $3.es_direccion);
}
;

elemento_vector: TOK_IDENTIFICADOR TOK_CORCHETEIZQUIERDO exp TOK_CORCHETEDERECHO {

	/* Buscar en el ambito actual*/
	nodo *node = buscarNodo($1.lexema, ambitoActual);
	if(node== NULL){	
		if(ambitoAbierto==true){
			/*Buscar tambien en la tabla global solo en el caso de que haya un ambito abierto*/
			node=buscarNodo($1.lexema, hashGlobal);
			if(node== NULL){
printf ( "     ****Error semántico en [lin %d, col %d]: identificador <%s> no declarado\n", linea,columna-yyleng,$1.lexema);				
				return -1;
			}
		}else{
			return -1;
		}
	}
	/*encontrado*/
	if(esFuncion(node)==true){
		flag=3;
		printf("Error semantico %s es una funcion",$1.lexema);
		yyerror("");
		return -1;
	}
	if(esVector(node)==false){
		flag=3;
		printf("Error semantico %s no es un vector",$1.lexema);
		yyerror("");
		return -1;
	}

	if($3.tipo != TIPO_ENTERO){
		flag=3;
		printf("Error semantico el vector debe usar como indice un numero entero");
		yyerror("");
	}
	$$.tipo=tipoNodo(node);
	$$.es_direccion=1;
	
	
	gc_vector_dentro_rango(fSalida, $3.es_direccion, tamanoNodo(node));
	gc_direccion_vector(fSalida, $1.lexema);
	
}
;


if_exp: TOK_IF TOK_PARENTESISIZQUIERDO exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA {
	if($3.tipo != TIPO_LOGICO){		
		printf("    ****Error semantico en [lin %d, col %d]: la expresion no es un valor booleano\n",linea,columna-yyleng);
		return -1;
	}
	$$.etiqueta=etiqueta++;
	gc_if(fSalida, $3.es_direccion, $$.etiqueta);
	
}
;
else_exp:  if_exp sentencias TOK_LLAVEDERECHA {
/*	if($3.tipo != TIPO_LOGICO){
		flag=3;
		printf("Error semantico la expresion no es un valor booleano");
		yyerror("");
	}
	*/
	gc_else(fSalida, $1.etiqueta); 
}
;

while_exp_exp : TOK_WHILE TOK_PARENTESISIZQUIERDO {$$.etiqueta=etiqueta++; fprintf(fSalida,"inicio_while%d:\n", $$.etiqueta);}
;

while_exp: while_exp_exp exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA{
	if($2.tipo != TIPO_LOGICO){
		printf("    ****Error semantico en [lin %d, col %d]: la expresion no es un valor booleano\n",linea,columna-yyleng);
		return -1;
	}
	$$.etiqueta=$1.etiqueta;
	gc_while(fSalida,$2.es_direccion, $$.etiqueta);

}
;

condicional: if_exp  sentencias TOK_LLAVEDERECHA { fprintf(fSalida,"\nfin_si%d:\n", $1.etiqueta); }
|else_exp TOK_ELSE TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA { fprintf(fSalida,"\nfin_sino%d:\n", $1.etiqueta);}
;

bucle:while_exp sentencias TOK_LLAVEDERECHA {	
	 fprintf(fSalida,"jmp near inicio_while%d\n", $1.etiqueta);
				   fprintf(fSalida,"fin_while%d:\n", $1.etiqueta);}
;

lectura:TOK_SCANF TOK_IDENTIFICADOR {
int tabla_global;
nodo *node;



if(ambitoAbierto == true){
/*Buscar en las dos tablas*/
	node=buscarNodo($2.lexema, ambitoActual);

	if(node== NULL){
		node=buscarNodo($2.lexema, hashGlobal);
		if(node== NULL){
printf ( "     ****Error semántico en [lin %d, col %d]: identificador <%s> no declarado\n", linea,columna-yyleng,$2.lexema);				
				return -1;

			}
		//encontrado en la global
		tabla_global=1;
	}else{
	//encontrado en la tabla local
	tabla_global=0;
}


}else{
	node=buscarNodo($2.lexema, ambitoActual);
		if(node== NULL){
printf ( "     ****Error semántico en [lin %d, col %d]: identificador <%s> no declarado\n", linea,columna-yyleng,$2.lexema);			
				return -1;

			}
		tabla_global=1;
}
	
	/*encontrado*/
	if(esFuncion(node)==true){
		flag=3;
		printf("Error semantico %s es una funcion",$2.lexema);
		yyerror("");	
		return -1;
	}
	if(esVector(node)==true){
		flag=3;
		printf("Error semantico %s es un vector",$2.lexema);
		yyerror("");	
		return -1;
	}
	
	
	if(tabla_global == 0){
	
	
	if(posicionParametro(node)==-1){
	/* es una variable pero dentro de una funcion */
	/*identificador = variable*/	
	gc_scanf_variable(fSalida,tipoNodo(node),posicionVariable(node));


	}else{
	/*Es un parametro de una funcion*/	
	nodo * nodee=buscarNodo(funcion_actual,ambitoActual);
	gc_scanf_parametro(fSalida, tipoNodo(node),posicionParametro(node),numParametros(nodee));	

	}		
	}else{ 
	/*variable normal, fuera de funciones*/
	gc_scanf(fSalida, $2.lexema, tipoNodo(node));	

	}

	}
	
	
;

escritura:TOK_PRINTF exp {
gc_printf(fSalida, $2.es_direccion, $2.tipo);
}
;

retorno_funcion:TOK_RETURN exp {


nodo * node=buscarNodo(funcion_actual, ambitoActual);

if(node==NULL){
printf ( "     ****Error semántico en [lin %d, col %d]: identificador no declarado\n", linea,columna-yyleng);
	return -1;
  }	
if($2.tipo!=tipoNodo(node)){
printf ( "     ****Error semántico en [lin %d, col %d]: asignacion invalida por tipos incompatibles\n", linea,columna-yyleng);
		return -1;
  }

 if($2.es_direccion!=1 && $2.es_direccion!=0){
		flag=3;
		printf ( "Direccion incorrecta");
		yyerror("");	
		return -1;
  }


  funcion_return++;

 gc_final_funcion(fSalida, $2.es_direccion);



}
;

exp: exp TOK_MAS exp {
	if($1.tipo != TIPO_ENTERO || $3.tipo != TIPO_ENTERO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);		
		return -1;
	}
	$$.tipo=TIPO_ENTERO;
	$$.es_direccion=0;
	
	gc_suma_enteros(fSalida,$1.es_direccion,$3.es_direccion);
	
}
|exp TOK_MENOS exp {
	if($1.tipo != TIPO_ENTERO || $3.tipo != TIPO_ENTERO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);
		return -1;
	}
	$$.tipo=TIPO_ENTERO;
	$$.es_direccion=0;
	gc_resta_enteros(fSalida, $1.es_direccion, $3.es_direccion);
}
|exp TOK_DIVISION exp {
	if($1.tipo != TIPO_ENTERO || $3.tipo != TIPO_ENTERO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);	
		return -1;
	}
	$$.tipo=TIPO_ENTERO;
	$$.es_direccion=0;
	gc_divide_enteros(fSalida, $1.es_direccion, $3.es_direccion);
}
|exp TOK_ASTERISCO exp {
	if($1.tipo != TIPO_ENTERO || $3.tipo != TIPO_ENTERO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);
		return -1;
	}
	$$.tipo=TIPO_ENTERO;
	$$.es_direccion=0;
	
	gc_multiplica_enteros(fSalida, $1.es_direccion, $3.es_direccion);
}
|TOK_MENOS exp %prec MU {
	if($2.tipo != TIPO_ENTERO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);	
		return -1;
	}
	$$.tipo=TIPO_ENTERO;
	$$.es_direccion=0;
	gc_unario(fSalida, $2.es_direccion);
}
|exp TOK_AND exp {
	if($1.tipo != TIPO_LOGICO || $3.tipo != TIPO_LOGICO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);	
		return -1;
	}
	$$.tipo=TIPO_LOGICO;
	$$.es_direccion=0;
	
	gc_and(fSalida, $1.es_direccion, $3.es_direccion);
}
|exp TOK_OR exp {
	if($1.tipo != TIPO_LOGICO || $3.tipo != TIPO_LOGICO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);
		return -1;
	}
	$$.tipo=TIPO_LOGICO;
	$$.es_direccion=0;
	
	gc_or(fSalida, $1.es_direccion, $3.es_direccion);
}
|TOK_NOT exp {
	if($2.tipo != TIPO_LOGICO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);
		return -1;
	}
	$$.tipo=TIPO_LOGICO;
	$$.es_direccion=0;
	
	/* posible error con la etiqueta ? meter en atributos??*/
	
	$$.etiqueta=etiqueta++;
	gc_not(fSalida, $2.es_direccion,$$.etiqueta);
	$$.etiqueta++;
	}
|constante  {
$$.tipo=$1.tipo;
$$.es_direccion=$1.es_direccion;
	}
|TOK_PARENTESISIZQUIERDO exp TOK_PARENTESISDERECHO {
$$.tipo=$2.tipo;
$$.es_direccion=$2.es_direccion;
	}
|TOK_PARENTESISIZQUIERDO comparacion TOK_PARENTESISDERECHO {
$$.tipo=$2.tipo;
$$.es_direccion=$2.es_direccion;
	}
|elemento_vector {
$$.tipo=$1.tipo;
$$.es_direccion=$1.es_direccion;
	}
|idf_llamada_funcion TOK_PARENTESISIZQUIERDO lista_expresiones TOK_PARENTESISDERECHO {

	nodo *node = buscarNodo($1.lexema, ambitoActual);
	if(node== NULL){	
		if(ambitoAbierto==true){
			/*Buscar tambien en la tabla global solo en el caso de que haya un ambito abierto*/
			node=buscarNodo($1.lexema, hashGlobal);
			if(node== NULL){
printf ( "     ****Error semántico en [lin %d, col %d]: identificador <%s> no declarado\n", linea,columna-yyleng,$1.lexema);
				return -1;
			}
		}else{
			return -1;
		}
	}	
	if(numParametros(node) !=num_parametros_llamada_actual){
printf("    ****Error semantico en [lin %d, col %d]: <%s> numero incorrecto de parametros\n",linea,columna-yyleng,$1.lexema);
return -1;
	}
	en_explist=0;	
enFuncion=0;
	$$.tipo=tipoNodo(node);
	$$.es_direccion=0;
	
	gc_llamada_funcion (fSalida, $1.lexema, num_parametros_llamada_actual);	

	
}
|TOK_IDENTIFICADOR{

int tabla_global;
nodo *node;



if(ambitoAbierto == true){
/*Buscar en las dos tablas*/
	node=buscarNodo($1.lexema, ambitoActual);

	if(node== NULL){
		node=buscarNodo($1.lexema, hashGlobal);
		if(node== NULL){
printf ( "     ****Error semántico en [lin %d, col %d]: identificador <%s> no declarado\n", linea,columna-yyleng,$1.lexema);			
				return -1;

			}
		//encontrado en la global
		tabla_global=1;
	}else{
	//encontrado en la tabla local
	tabla_global=0;
}


}else{
	node=buscarNodo($1.lexema, ambitoActual);
		if(node== NULL){
printf ( "     ****Error semántico en [lin %d, col %d]: identificador <%s> no declarado\n", linea,columna-yyleng,$1.lexema);				
				return -1;

			}
		tabla_global=1;
}


	
	/*encontrado*/

	if(esFuncion(node)==true){
		printf("     ****Error semántico en [lin %d, col %d]: es una funcion",linea,columna-yyleng);	
		return -1;
	}
	if(esVector(node)==true){		
		printf("     ****Error semántico en [lin %d, col %d]: es un vector <%s>",linea,columna-yyleng,$1.lexema);			
		return -1;
	}	


	
	$$.tipo=tipoNodo(node);
	$$.es_direccion=1;

	
	/* Errores ?? tortilla ççççç*/


	if(tabla_global == 0){	
	
	if(posicionParametro(node)==-1){

	/*No es un parametro */
	/*identificador = variable*/

		fprintf(fSalida, "\nlea eax, [ebp-4*%d]\n", posicionVariable(node));
					fprintf(fSalida, "\npush dword eax\n");

	}else{
	/*Es un parametro	*/	
	/*identificador = variable (parametro)*/

				nodo *nodee = buscarNodo(funcion_actual,ambitoActual);
				fprintf(fSalida, "\nlea eax, [ebp+4+4*%d]\n", (numParametros(nodee) - posicionParametro(node)));
				fprintf(fSalida, "\npush dword eax\n");	

	}		
	}else{ 
	/* identificador = constante*/
		if (enFuncion==0){

		fprintf(fSalida, "push dword _%s\n", $1.lexema);
		}else{

		fprintf(fSalida, "push dword [_%s]\n", $1.lexema);
		}
	}
		
}
;

idf_llamada_funcion: TOK_IDENTIFICADOR {

num_parametros_llamada_actual=0;
num_variables_locales_actual=0;
/* Buscar en el ambito actual*/

	nodo *node = buscarNodo($1.lexema, hashGlobal);
if(node==NULL){
printf ( "     ****Error semántico en [lin %d, col %d]: identificador <%s> no declarado\n", linea,columna-yyleng,$1.lexema);
				return -1;
}
	
	/*encontrado*/

	if(esFuncion(node)==false){
		flag=3;
		printf("Error semantico %s no es una funcion",$1.lexema);
		yyerror("");	
		return -1;
	}
	if(esVector(node)==true){
		flag=3;
		printf("Error semantico %s es un vector",$1.lexema);
		yyerror("");	
		return -1;
	}
	if(en_explist == 1){
		flag=3;
		printf("Error semantico %s es una llamada a otra funcion",$1.lexema);
		yyerror("");	
		return -1;

	}
	strcpy($$.lexema , $1.lexema);
	num_parametros_llamada_actual=0;
	en_explist=1;
	enFuncion=1;

}
;

lista_expresiones:exp resto_lista_expresiones {
num_parametros_llamada_actual++;
}
| {}
;

resto_lista_expresiones:TOK_COMA exp resto_lista_expresiones {
num_parametros_llamada_actual++;
}
|{}
;

comparacion:exp TOK_IGUAL exp {
if($1.tipo != TIPO_ENTERO || $3.tipo != TIPO_ENTERO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);
		return -1;
	}
	$$.tipo=TIPO_LOGICO;
	$$.es_direccion=0;
	
	
	$$.etiqueta= etiqueta++;
	gc_igual(fSalida, $1.es_direccion,$3.es_direccion,$$.etiqueta);
	
}
|exp TOK_DISTINTO exp {
if($1.tipo != TIPO_ENTERO || $3.tipo != TIPO_ENTERO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);
		return -1;
	}
	$$.tipo=TIPO_LOGICO;
	$$.es_direccion=0;
	
	$$.etiqueta= etiqueta++;
	 gc_distinto(fSalida,$1.es_direccion,$3.es_direccion, $$.etiqueta);
	 
}
|exp TOK_MENORIGUAL exp {
if($1.tipo != TIPO_ENTERO || $3.tipo != TIPO_ENTERO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);	
		return -1;
	}
	$$.tipo=TIPO_LOGICO;
	$$.es_direccion=0;
	
	$$.etiqueta= etiqueta++;
	gc_menorigual(fSalida, $1.es_direccion,$3.es_direccion, $$.etiqueta);
	
}
|exp TOK_MAYORIGUAL exp {
if($1.tipo != TIPO_ENTERO || $3.tipo != TIPO_ENTERO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);	
		return -1;
	}
	$$.tipo=TIPO_LOGICO;
	$$.es_direccion=0;
	
	$$.etiqueta= etiqueta++;
	gc_mayorigual(fSalida, $1.es_direccion,$3.es_direccion,$$.etiqueta);
	
}
|exp TOK_MENOR exp {
if($1.tipo != TIPO_ENTERO || $3.tipo != TIPO_ENTERO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);
		return -1;
	}
	$$.tipo=TIPO_LOGICO;
	$$.es_direccion=0;
	
	$$.etiqueta= etiqueta++;
	gc_menor(fSalida, $1.es_direccion,$3.es_direccion, $$.etiqueta);
	
}
|exp TOK_MAYOR exp {
if($1.tipo != TIPO_ENTERO || $3.tipo != TIPO_ENTERO){
printf ( "     ****Error semántico en [lin %d, col %d]: tipo invalido en expresion\n", linea,columna-yyleng);	
		return -1;
	}
	$$.tipo=TIPO_LOGICO;
	$$.es_direccion=0;
	
	$$.etiqueta= etiqueta++;
	gc_mayor(fSalida, $1.es_direccion,$3.es_direccion, $$.etiqueta);
	
}
;

constante:constante_logica {
$$.tipo=$1.tipo;
$$.es_direccion=$1.es_direccion;
}
|constante_entera {
$$.tipo=$1.tipo;
$$.es_direccion=$1.es_direccion;
}
;
constante_logica:TOK_TRUE {
$$.tipo=TIPO_LOGICO;
$$.es_direccion=0;

/* generacion de codigo*/
fprintf(fSalida,";linea%d\n",linea);
fprintf(fSalida, "\tpush dword 1\n");

}
|TOK_FALSE {
$$.tipo=TIPO_LOGICO;
$$.es_direccion=0;

/* generacion de codigo*/
fprintf(fSalida,";linea%d\n",linea);
fprintf(fSalida, "\tpush dword 0\n");
}
;

constante_entera: TOK_CONSTANTE_ENTERA {
$$.tipo=TIPO_ENTERO;
$$.es_direccion=0;

/* generacion de codigo*/
fprintf(fSalida,";linea%d\n",linea);
fprintf(fSalida, "\tpush dword %d\n",$1.valor_entero);
}
;


identificador:TOK_IDENTIFICADOR  {
/*Regla para identificadores normales*/


nodo *node;
		node=buscarNodo($1.lexema, ambitoActual);

		if(node!= NULL){		
			printf("   **** Error semántico en [lin %d, col %d]: declaracion duplicada\n",linea,columna-yyleng);					
			return -1;
			}

node= creaNodoVariable($1.lexema,tipo_actual,clase_actual, tamanio_vector_actual,pos_variable_local_actual);
if(insertarElem($1.lexema, ambitoActual, node)==ERR){
		flag=3;
		yyerror("Error semantico en la declaracion ");
		return -1;
	}

pos_variable_local_actual++;
num_variables_locales_actual++;
strcpy($$.lexema,$1.lexema);




}
;

idpf: TOK_IDENTIFICADOR {

if (ambitoAbierto==false){
			   		printf( "   **** Error semántico en [lin %d, col %d]\n]: Ambito local no abierto ",  linea,columna-yyleng);
			   		return -1;
			   	}


nodo *node;
		node=buscarNodo($1.lexema, ambitoActual);

		if(node!= NULL){		
			printf("   **** Error semántico en [lin %d, col %d]: declaracion duplicada\n",linea,columna-yyleng);					
			return -1;
			}

node= creaNodoVariableFuncion($1.lexema,tipo_actual,CLASE_ESCALAR,tamanio_vector_actual,pos_parametro_actual,0);


insertarElem($1.lexema,ambitoActual,node);

strcpy($$.lexema,$1.lexema);
num_parametros_actual++;
pos_parametro_actual++;
}
;


%%
int yyerror(char * s){
if(flag==0){
/*error sintactico*/
printf("    ****Error sintactico en [lin %d, col %d]\n",linea,columna-yyleng);
}else if(flag==3){
//return -1;
printf("%s [lin %d, col %d]\n",s,linea,columna-yyleng);
}
flag=0;

/*Fin programa con error*/
if(ambitoAbierto==true){
vaciarHash(hashLocal);
destruirHash(hashLocal);
}
vaciarHash(hashGlobal);
destruirHash(hashGlobal);

return -1;
}

